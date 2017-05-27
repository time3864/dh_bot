#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")
While(@HOUR == 23) Or (@HOUR == 22) or (@HOUR == 21) or (@HOUR == 20) or (@HOUR == 19)
	Sleep(20000)
WEnd

;While (@HOUR == 17) or (@HOUR == 11)
	Sleep(20000)
;WEnd

$shutdown = 1

$master_mission = 0

If @HOUR == 12 Or @HOUR == 18 Then
;$master_mission = 200
;$shutdown = 0
EndIf

Main_Controller()


Exit