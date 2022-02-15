-- si5338.lua
--
-- Program an Si5338 clock generator connected to an FPGA by I2C through the
-- Opal Kelly I2C core. Register settings are loaded from a CSV file exported
-- from the Silicon Labs ClockBuilder Pro software.
--
-- Copyright 2019 Opal Kelly Incorporated

-- Script init, run on XFP load
function OnInit(event)
	-- Definitions
	I2CMAXBUFLEN = 64
	I2C_TRIGIN = 0x40
	I2C_TRIGOUT = 0x60
	I2C_WIREIN_DATA = 0x01
	I2C_WIREOUT_DATA = 0x20

	I2C_TRIGIN_GO = 0
	I2C_TRIGIN_MEM_RESET = 1
	I2C_TRIGIN_MEM_WRITE = 2
	I2C_TRIGIN_MEM_READ = 3
	I2C_TRIGOUT_DONE = 0

	I2C_MAX_TIMEOUT_MS = 250

	NUM_REGS_MAX = 350

	-- Global variables
	I2CDataBuf = {}
	I2CDataStart = 0

	StatusString = ""

	UpdateStatus()

	mask_table = {}

	local current_directory = okUI:GetProfileDirectory()

	mask_file = io.open(current_directory .. "/si5338_mask.csv", "r")
	data_file = io.open(current_directory .. "/si5338_data.csv", "r")

	InitMask()
end

-- Initialize and reset the I2C Core
function I2CInit(dev)
		dev:SetWireInValue(0x00, 0x0001, 0x0001)
		dev:UpdateWireIns()
		dev:SetWireInValue(0x00, 0x0000, 0x0001)
		dev:UpdateWireIns()
end

-- Initialize the mask array from the mask CSV file
function InitMask()
	local csv_result = {}

	local mask_line = ""

	while true do
		mask_line = mask_file:read()
		if (mask_line == "") then break end
		if (mask_line == nil) then break end

		csv_result = ParseCSVLine(mask_line)

		if ((csv_result[1] ~= nil) and (csv_result[2] ~= nil)) then
			mask_table[tonumber(csv_result[1])] = tonumber(csv_result[2]:gsub('h',''),16)
		end
	end
end

function OnSetupSi5338Button(button, event)
	if not button:IsPressed() then return end

	SetupSi5338(event:GetDevice())
end

-- Configure Si5338 registers with data from CSV file
function SetupSi5338(dev)
	local mask = 0x00
	local new_val = {}
	local addr = 0
	local curr_val = {}
	local check_val = {}
	local csv_result = {}
	local data_line = ""
	local mismatch = false
	local pagebit = 0

	I2CInit(dev)

	SetStatus("Starting...")
	-- From Si5338 Datasheet, figure 9...
	-- Disable all outputs
	I2CWrite8(dev, 230, {0x10})

	-- Pause LOL
	I2CWrite8(dev, 241, {0x80 | 0x65})

	while true do
		data_line = data_file:read()
		if (data_line == "") then break end
		if (data_line == nil) then break end
		csv_result = ParseCSVLine(data_line)

		if ((csv_result[1] ~= nil) or (csv_result[2] ~= nil)) then
			new_val[1] = tonumber(csv_result[2]:gsub('h',''),16)
			addr = tonumber(csv_result[1])
			mask = mask_table[addr]

			if ((addr > 255) and (pagebit == 0)) then
				pagebit = 1
				I2CWrite8(dev, 255, {pagebit})
				addr = addr - 256
			elseif ((addr < 255) and (pagebit == 1)) then
				pagebit = 0
				I2CWrite8(dev, 255, {pagebit})
			end

			if (mask ~= 0x00) then
				if (mask == 0xFF) then
					I2CWrite8(dev, addr, new_val)
				else
					I2CRead8(dev, addr, curr_val)
					curr_val[1] = curr_val[1] & ~mask
					new_val[1] = (new_val[1] & mask) | curr_val[1]
					I2CWrite8(dev, addr, new_val)
				end

				I2CRead8(dev, addr, check_val)

				if (check_val[1] ~= new_val[1]) then
					DebugLog("MISMATCH")
					mismatch = true
				end
			end

			if (addr == 255 and mask == 255 and new_val[1] == 0) then
				break
			end
		end
	end

	if (mismatch == true) then return end

	-- Check input clock
	for i = 0,100 do
		I2CRead8(dev, 218, check_val)

		if ((check_val[1] & 0x04) == 0) then
			SetStatus("Input clock valid")
			UpdateStatus()
			break
		end
		SetStatus("Waiting for input clock valid")
		UpdateStatus()
		OpalKelly.Sleep(1)
	end

	if (i == 100) then
		SetStatus("Input clock invalid")
		UpdateStatus()
		return
	end

	SetStatus("Configuring PLL for locking...")
	UpdateStatus()

	I2CRead8(dev, 49, curr_val)
	new_val[1] = curr_val[1] & 0x7F -- Clear bit 7
	I2CWrite8(dev, 49, new_val)

	SetStatus("Initiate locking of PLL...")
	UpdateStatus()
	I2CWrite8(dev, 246, {0x02})

	OpalKelly.Sleep(25)

	SetStatus("Restart LOL...")
	UpdateStatus()
	I2CWrite8(dev, 241, {0x65})

	for i = 0,100 do
		I2CRead8(dev, 218, check_val)

		if ((check_val[1] & 0x15) == 0) then
			SetStatus("PLL locked")
			UpdateStatus()
			break
		end
		SetStatus("Waiting for PLL lock")
		UpdateStatus()
		OpalKelly.Sleep(1)
	end

	if (i == 100) then
		SetStatus("ERROR: PLL not locked")
		UpdateStatus()
		return
	end

	SetStatus("Copy FCAL...")
	UpdateStatus()
	I2CRead8(dev, 237, new_val)
	new_val[1] = (new_val[1] & 0x03) | 0x14
	I2CWrite8(dev, 47, new_val)

	I2CRead8(dev, 236, new_val)
	I2CWrite8(dev, 46, new_val)
	I2CRead8(dev, 235, new_val)
	I2CWrite8(dev, 45, new_val)

	SetStatus("Set PLL to use FCAL...")
	UpdateStatus()
	I2CRead8(dev, 49, curr_val)
	new_val[1] = curr_val[1] | 0x80 -- set bit 7
	I2CWrite8(dev, 49, new_val)

	SetStatus("Enable outputs...")
	UpdateStatus()
	I2CWrite8(dev, 230, {0})

	SetStatus("Done!")
	UpdateStatus()
end

-- STARTS - Defines the preamble bytes after which a start bit is
--      transmitted. For example, if STARTS=0x04, a start bit is
--      transmitted after the 3rd preamble byte.
-- STOPS - Defines the preamble bytes after which a stop bit is
--      transmitted. For example, if STOPS=0x04, a stop bit is
--      transmitted after the 3rd preamble byte.
--
-- Note: If there is a one in the same position for both STARTS and STOPS,
--       the stop takes precedence.
function I2CConfigure(starts, stops, preamble)
	if (#preamble > 7) then
		DebugLog("Preamble data too long")
	end

	local i

	I2CDataBuf = {}

	I2CDataBuf[1] = #preamble
	I2CDataBuf[2] = starts
	I2CDataBuf[3] = stops
	I2CDataBuf[4] = 0 -- Payload length will be provided later
	for i = 1, #preamble do
		I2CDataBuf[4+i] = preamble[i]
	end

	I2CDataStart = #I2CDataBuf
end

-- Receive data from I2C Core
function I2CReceive(dev, data, length)
	local i
	local j

	if (length >= I2CMAXBUFLEN) then
		DebugLog("Receive data length too long")
		return
	end

	I2CDataBuf[1] = I2CDataBuf[1] | 0x80
	I2CDataBuf[4] = length

	dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_RESET)
	for i = 1, I2CDataStart do
		dev:SetWireInValue(I2C_WIREIN_DATA, I2CDataBuf[i], 0x00FF)
		dev:UpdateWireIns()
		dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_WRITE)
	end

	dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_GO)

	for i = 1, (I2C_MAX_TIMEOUT_MS/10) do
		dev:UpdateTriggerOuts()
		if (dev:IsTriggered(I2C_TRIGOUT, (1 << I2C_TRIGOUT_DONE))) then
			-- Reset the memory pointer
			dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_RESET)
			for j = 1,length do
				dev:UpdateWireOuts()
				data[j] = dev:GetWireOutValue(I2C_WIREOUT_DATA)
				dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_READ)
			end
			return
		end
		OpalKelly.Sleep(10)
	end
end

-- Transmit data to I2C Core
function I2CTransmit(dev, data)
	local i

	if (#data == 0) then
		DebugLog("No Data provided to I2CTransmit")
		return
	end

	if ((I2CDataStart + #data) >= I2CMAXBUFLEN) then
		DebugLog("Transmit data too long")
		return
	end

	I2CDataBuf[4] = #data

	for i = 1, #data do
		I2CDataBuf[I2CDataStart + i] = data[i]
	end

	-- Reset memory and transfer buffer
	dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_RESET)
	for i = 1, (#data + I2CDataStart) do
		dev:SetWireInValue(I2C_WIREIN_DATA, I2CDataBuf[i], 0x00FF)
		dev:UpdateWireIns()
		dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_MEM_WRITE)
	end

	dev:ActivateTriggerIn(I2C_TRIGIN, I2C_TRIGIN_GO)

	for i = 1, I2C_MAX_TIMEOUT_MS/10 do
		dev:UpdateTriggerOuts()
		if (dev:IsTriggered(I2C_TRIGOUT, (1 << I2C_TRIGOUT_DONE))) then
			return
		end
		OpalKelly.Sleep(10)
	end

	DebugLog("Timeout when transmitting data")
end

-- Write a single byte of data to register addr
function I2CWrite8 (dev, addr, data)
	local preamble = {}
	preamble[1] = 0xE0 -- devAddr (write)
	preamble[2] = addr -- register address

	I2CConfigure(0x00, 0x00, preamble)
	I2CTransmit(dev, data)
end

-- Read a single byte of data from register at addr
function I2CRead8 (dev, addr, data)
	local preamble = {}
	preamble[1] = 0xE0 -- devAddr (write)
	preamble[2] = addr -- register address
	preamble[3] = 0xE1 -- devAddr (read)

	I2CConfigure(0x00, 0x02, preamble)
	I2CReceive(dev, data, 1)
end

-- CSV parser, modified from http://lua-users.org/wiki/LuaCsv
function ParseCSVLine (line,sep)
	local res = {}
	local pos = 1
	sep = sep or ','
	while true do
		local c = string.sub(line,pos,pos)
		if (c == "") then break end
		if (c == '#') then break end -- ignore comments

		-- Look for the first separator
		local startp,endp = string.find(line,sep,pos)
		if (startp) then
			table.insert(res,string.sub(line,pos,startp-1))
			pos = endp + 1
		else
			-- no separator found -> use rest of string and terminate
			table.insert(res,string.sub(line,pos))
			break
		end
	end
	return res
end

function SetStatus(str)
	StatusString = str
	DebugLog(str)
	UpdateStatus()
end

function UpdateStatus()
	local logControl = okUI:FindPanel("panel1"):FindControl("status")

	local status = "Status: " .. StatusString

	logControl:SetLabel(status)
end
