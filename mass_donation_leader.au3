#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

$logging = 0
$allow_no_login = 1
;$players_file = "players_donate.txt"
$players_file = "players_leader.txt"

$master_mission = 950
$fast_bot = 1
$retries = 1000
Main_Controller()

Exit