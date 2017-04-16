#include <Constants.au3>
#include <GUIConstantsEx.au3>


#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>








#include <GUIConstantsEx.au3>

Example()

Func Example()
    GUICreate("My GUI") ; will create a dialog box that when displayed is centered

    GUISetHelp("notepad.exe") ; will run notepad if F1 is typed
    Local $iOldOpt = Opt("GUICoordMode", 2)

    Local $iWidthCell = 70
    GUICtrlCreateLabel("Line 1 Cell 1", 10, 30, $iWidthCell) ; first cell 70 width
    GUICtrlCreateLabel("Line 2 Cell 1", -1, 0) ; next line
    GUICtrlCreateLabel("Line 3 Cell 2", 0, 0) ; next line and next cell
    GUICtrlCreateLabel("Line 3 Cell 3", 0, -1) ; next cell same line
    GUICtrlCreateLabel("Line 4 Cell 1", -3 * $iWidthCell, 0) ; next line Cell1

    GUISetState(@SW_SHOW) ; will display an empty dialog box

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

        EndSwitch
    WEnd

    $iOldOpt = Opt("GUICoordMode", $iOldOpt)
EndFunc   ;==>Example





Func basic()
Local $hGUI = GUICreate("Hello World", 400, 200)
GUICtrlCreateLabel("Hello world! How are you?", 60, 10)
;Local $iOKButton = GUICtrlCreateButton("OK", 70, 50, 60)
Local $iOKButton = GUICtrlCreateButton("OK", 70, 50, 60)
Local $iCancelButton = GUICtrlCreateButton("Cancel", 150, 50, 60)
GUISetState(@SW_SHOW, $hGUI)
Local $iMsg = 0
While 1
    $iMsg = GUIGetMsg()
    Switch $iMsg
        Case $iOKButton
            MsgBox($MB_SYSTEMMODAL, "GUI Event", "You selected the OK button.")

        Case $GUI_EVENT_CLOSE
            MsgBox($MB_SYSTEMMODAL, "GUI Event", "You selected the Close button. Exiting...")
            ExitLoop
    EndSwitch
WEnd

GUIDelete($hGUI)
EndFunc



