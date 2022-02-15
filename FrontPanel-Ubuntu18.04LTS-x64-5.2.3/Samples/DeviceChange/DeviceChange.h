#ifndef __DeviceChange_H__
#define __DeviceChange_H__

#include "wx/frame.h"
#include "okFrontPanel.h"

// An arbitrary setting.
#define MAX_NUM_DEVICES  5


class wxStaticText;
class wxComboBox;
class wxTimer;
class MainFrame
   : public wxFrame,
     public OpalKelly::FrontPanelManager
{
public:
	MainFrame(const wxString& title, const wxPoint& pos, const wxSize& size,
	          long style = wxDEFAULT_FRAME_STYLE | wxNO_FULL_REPAINT_ON_RESIZE );
	~MainFrame();

	void Initialize();
	void OnDeviceAdded(const char *serial);
	void OnDeviceRemoved(const char *serial);
	void OnRelease(wxCommandEvent& event);
	void OnQuit(wxCommandEvent& event);

private:
	void UpdateDeviceEntry(int i);
	void DisableDeviceEntry(int i);

	okCFrontPanel    *m_dev[MAX_NUM_DEVICES];
	wxStaticText     *m_txtSerialNumber[MAX_NUM_DEVICES];
	wxStaticText     *m_txtModel[MAX_NUM_DEVICES];
	wxStaticText     *m_txtDeviceID[MAX_NUM_DEVICES];
	wxButton         *m_btnRelease[MAX_NUM_DEVICES];

	DECLARE_EVENT_TABLE()
};


#endif // __DeviceChange_H__
