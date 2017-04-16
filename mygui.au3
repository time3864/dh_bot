#include <Constants.au3>
#include <GUIConstantsEx.au3>


#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>



Example()

Func Example()
    ;GUICreate("User", 320, 120, @DesktopWidth / 2 - 160, @DesktopHeight / 2 - 45, -1, $WS_EX_ACCEPTFILES)
	GUICreate("User", 500, 200)

	GUICtrlCreateLabel("Email", 10, 5, 50)
    Local $player = GUICtrlCreateInput("", 100, 5, 300, 20)
	GUICtrlCreateLabel("Passowrd", 10, 35, 50)
    Local $password = GUICtrlCreateInput("", 100, 35, 300, 20)
	GUICtrlCreateLabel("Server", 10, 65, 50)
	Local $server = GUICtrlCreateInput("", 100, 65, 300, 20)


    Local $idBtn = GUICtrlCreateButton("Ok", 40, 170, 60, 20)

    GUISetState(@SW_SHOW)

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
            Case $idBtn
                ExitLoop
        EndSwitch
    WEnd

    MsgBox($MB_SYSTEMMODAL, "drag drop file", GUICtrlRead($player))
EndFunc   ;==>Example