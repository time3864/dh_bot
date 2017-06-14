#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

$fast_bot = 1

$players_file = "players_donate.txt"
$players_loopback = "players_miss.txt"
FileDelete(@ScriptDir & "\" & $players_loopback)
$master_mission = 900
Main_Controller()

$players_file = $players_loopback
$master_mission = 900
Main_Controller()


Exit