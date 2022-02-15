//------------------------------------------------------------------------
// DeviceChange.cpp
//
// Copyright (c) 2004-2014 Opal Kelly Incorporated
// $Rev$ $Date$
//------------------------------------------------------------------------

#include "wx/wxprec.h"

#ifndef WX_PRECOMP
#include "wx/wx.h"
#endif

#include "wx/stattext.h"
#include "wx/button.h"
#include "wx/datetime.h"

#include "DeviceChange.h"


class SampleApp : public wxApp
{
public:
	virtual bool OnInit();
};

IMPLEMENT_APP(SampleApp)


bool
SampleApp::OnInit()
{
	MainFrame *frame = new MainFrame(_T("Opal Kelly - DeviceChange Sample"),
			wxDefaultPosition, wxSize(550,400));

	frame->Initialize();
	frame->Show(TRUE);
	return(TRUE);
}


//------------------------------------------------------------------------
// Main window
//------------------------------------------------------------------------
enum {
	IDC_TXT_SN0=100,
	IDC_TXT_MODEL0=200,
	IDC_TXT_DEVID0=300,
	IDC_BTN_RELEASE0=400
};

BEGIN_EVENT_TABLE(MainFrame, wxFrame)
END_EVENT_TABLE()


MainFrame::MainFrame(const wxString& title, const wxPoint& pos,
							 const wxSize& size, long style)
       : wxFrame(NULL, -1, title, pos, size, style),
		   OpalKelly::FrontPanelManager()
{
	for (int i=0; i<MAX_NUM_DEVICES; i++)
		m_dev[i] = NULL;
}


MainFrame::~MainFrame()
{
	for (int i=0; i<MAX_NUM_DEVICES; i++)
		if (NULL != m_dev[i])
			delete m_dev[i];
}


/*
 * This is called by FrontPanelManager when a new FrontPanel device has 
 * enumerated. For the purposes of this example, we fill the first available
 * slot with the new device's information.
 */
void
MainFrame::OnDeviceAdded(const char *serial)
{
	wxLogMessage(_("Device added: SN=%s"), wxString::FromUTF8(serial));
	
	// Find the first free slot.
	for (int i=0; i<MAX_NUM_DEVICES; i++) {
		if (!m_dev[i]) {
			m_dev[i] = Open(serial);
			if (!m_dev[i]) {
				wxLogError("Opening device \"%s\" failed.", serial);
				return;
			}
			UpdateDeviceEntry(i);
			wxLogMessage(
					"New device \"%s\" connected at slot #%d",
					serial, i + 1
				);
			return; // Skip the error below.
		}
	}

	// In this simple example we just complain about it, in a real life
	// application we would add more controls dynamically.
	wxLogError("Too many devices: can't display \"%s\"", serial);
}



/*
 * This is called by FrontPanelManager when a FrontPanel device has 
 * been removed. We look through our device slots for a matching serial
 * number and destroy the corresponding instance.
 */
void
MainFrame::OnDeviceRemoved(const char *serial)
{
	wxLogMessage(_("Device removed: SN=%s"), wxString::FromUTF8(serial));

	// Find the slot corresponding to the device with the given serial.
	for (int i=0; i<MAX_NUM_DEVICES; i++) {
		if (m_txtSerialNumber[i]->GetLabel() == serial) {
			DisableDeviceEntry(i);
			wxLogMessage(
					"Device \"%s\" in slot #%d disconnected.",
					serial, i + 1
				);
			return;
		}
	}

	// This can happen if we previously had too many devices, otherwise this is
	// really unexpected.
	wxLogWarning(
			"Disconnection notification for unknown device \"%s\" ignored.",
			serial
		);
}


void MainFrame::UpdateDeviceEntry(int i)
{
	okTDeviceInfo info;
	m_dev[i]->GetDeviceInfo(&info);
	m_txtSerialNumber[i]->SetLabel(wxString::FromUTF8(info.serialNumber));
	m_txtSerialNumber[i]->SetForegroundColour(wxColour(0,0,0));
	m_txtModel[i]->SetLabel(wxString::FromUTF8(info.productName));
	m_txtModel[i]->SetForegroundColour(wxColour(0,0,0));
	m_txtDeviceID[i]->SetLabel(wxString::FromUTF8(info.deviceID));
	m_txtDeviceID[i]->SetForegroundColour(wxColour(0,0,0));
	m_btnRelease[i]->Enable(true);
}


void MainFrame::DisableDeviceEntry(int i)
{
	delete m_dev[i];
	m_dev[i] = NULL;

	m_txtSerialNumber[i]->SetLabel(_("0000000000"));
	m_txtSerialNumber[i]->SetForegroundColour(wxColour(128,128,128));
	m_txtModel[i]->SetLabel(_("Model"));
	m_txtModel[i]->SetForegroundColour(wxColour(128,128,128));
	m_txtDeviceID[i]->SetLabel(_("Device ID String"));
	m_txtDeviceID[i]->SetForegroundColour(wxColour(128,128,128));
	m_btnRelease[i]->Enable(false);
}


// The RELEASE button simply deletes (de-allocates) the selected device.
void
MainFrame::OnRelease(wxCommandEvent &event)
{
	int i = event.GetId() - IDC_BTN_RELEASE0;

	DisableDeviceEntry(i);

	wxLogMessage(_("De-allocated device #%d"), i+1);
}



void
MainFrame::OnQuit(wxCommandEvent& WXUNUSED(event))
{
    // TRUE is to force the frame to close
    Close(TRUE);
}


void
MainFrame::Initialize()
{
	int i;


#if defined(_WIN32)
	SetIcon(wxICON(appicon));
#endif
	wxSizer *topSizer = new wxBoxSizer(wxVERTICAL);
	wxPanel *panel = new wxPanel(this, -1);

	// Pipe Test Controls
	wxStaticBoxSizer *sbs = new wxStaticBoxSizer(new wxStaticBox(panel, -1, _T("Device Instances")),
	                                             wxHORIZONTAL);

	wxFlexGridSizer *fgs = new wxFlexGridSizer(MAX_NUM_DEVICES, 7, 5, 5);
	fgs->SetFlexibleDirection(wxHORIZONTAL);
	for (i=0; i<MAX_NUM_DEVICES; i++) {
		m_txtModel[i] = new wxStaticText(panel, IDC_TXT_MODEL0+i, _T("Model"), wxDefaultPosition, wxSize(125,-1));
		m_txtModel[i]->SetForegroundColour(wxColour(128,128,128));
		fgs->Add(m_txtModel[i], 0, wxALIGN_LEFT | wxALIGN_CENTER_VERTICAL);
		fgs->AddSpacer(10);

		m_txtSerialNumber[i] = new wxStaticText(panel, IDC_TXT_SN0+i, _T("0000000000"));
		m_txtSerialNumber[i]->SetForegroundColour(wxColour(128,128,128));
		fgs->Add(m_txtSerialNumber[i], 0, wxALIGN_LEFT | wxALIGN_CENTER_VERTICAL);
		fgs->AddSpacer(10);

		m_txtDeviceID[i] = new wxStaticText(panel, IDC_TXT_DEVID0+i, _T("Device ID String"), wxDefaultPosition, wxSize(150,-1));
		m_txtDeviceID[i]->SetForegroundColour(wxColour(128,128,128));
		fgs->Add(m_txtDeviceID[i], 0, wxALIGN_LEFT | wxALIGN_CENTER_VERTICAL);
		fgs->AddSpacer(10);

		m_btnRelease[i] = new wxButton(panel, IDC_BTN_RELEASE0+i, _T("Release"));
		m_btnRelease[i]->Enable(false);
		fgs->Add(m_btnRelease[i], 0, wxALIGN_LEFT | wxALIGN_CENTER_VERTICAL);
	}
	fgs->AddGrowableCol(6);
	fgs->Layout();

	this->Connect(IDC_BTN_RELEASE0, IDC_BTN_RELEASE0 + MAX_NUM_DEVICES - 1,
	              wxEVT_COMMAND_BUTTON_CLICKED, wxCommandEventHandler(MainFrame::OnRelease));

	sbs->Add(fgs, 1, wxEXPAND);

	topSizer->Add(sbs, 0, wxALL | wxEXPAND, 5);

	// Status text
	wxTextCtrl* txtStatus = new wxTextCtrl(panel, -1, _T(""),
	                             wxDefaultPosition, wxDefaultSize,
	                             wxTE_MULTILINE | wxTE_READONLY);
	wxLog::SetActiveTarget(new wxLogTextCtrl(txtStatus));
	topSizer->Add(txtStatus, 1, wxEXPAND);

	panel->SetSizer(topSizer);
	topSizer->SetSizeHints(panel);

	// Load the FrontPanel DLL
	wxLogMessage(_("FrontPanel DLL version: %s"), okFrontPanel_GetAPIVersionString());

	// Have Windows notify us when a device is added/removed.
	StartMonitoring();
}

