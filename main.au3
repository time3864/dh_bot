#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")
While(@HOUR == 23) ;Or (@HOUR == 17) or (@HOUR == 11)
	Sleep(20000)
WEnd

$shutdown = 1

$master_mission = 0

If @HOUR == 12 Or @HOUR == 18 Then
$master_mission = 200
EndIf

Main_Controller()


Exit