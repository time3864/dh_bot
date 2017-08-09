#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

Default_Setting()

$allow_no_login = 1

$players_file = "players.txt"
$players_loopback = "players_miss.txt"

If @HOUR == "00" Then
Error_Log("12am")
$shutdown = 1
$master_mission = 0
EndIf

If @HOUR == 12 Or @HOUR == 18 Then
Error_Log("12pm/6pm")
$shutdown = 0
$logging = 0
$master_mission = 100
EndIf

If @HOUR == 18 Then
$reboot = 1
EndIf

If @HOUR == 23 Then
Error_Log("11pm")
$master_profile = 7
$logging = 0
$players_file = "players_owner.txt"
EndIf

If @HOUR == 13 Then
Error_Log("1pm")
$shutdown = 0
$logging = 0
$master_mission = 17
$players_file = "players_bless.txt"
EndIf

Main_Controller()


Exit