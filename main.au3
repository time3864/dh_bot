#include "bluestack.au3"

Global $shutdown = 0

Error_Log("----------------------------------------------------------------------")
While(@HOUR == 23) ;Or (@HOUR == 17) or (@HOUR == 11)
	Sleep(20000)
WEnd

If @HOUR == 18 Then
	$shutdown = 1
EndIf

;Sleep(60000)

$master_mission = 0

If @HOUR == 12 Or @HOUR == 18 Then
$master_mission = 200
EndIf

Main_Controller()

If $shutdown == 1 Then
Shutdown($SD_SHUTDOWN)
EndIf

Exit