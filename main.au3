#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

$shutdown = 1
If @HOUR == 00 Then
$master_mission = 0
EndIf

If @HOUR == 12 Or @HOUR == 18 Or @HOUR == 13 Then
$shutdown = 0
$master_mission = 100
EndIf

Main_Controller()


Exit