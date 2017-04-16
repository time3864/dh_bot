#include "bluestack.au3"

Global $shutdown = 0

Error_Log("----------------------------------------------------------------------")


;Sleep(60000)

$master_mission = 100


Main_Controller()

If $shutdown == 1 Then
Shutdown($SD_SHUTDOWN)
EndIf

Exit