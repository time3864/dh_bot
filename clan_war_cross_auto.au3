#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

Default_Setting()

$logging = 0
$retries = 100
$players_file = "players_clan_war.txt"

$no_login = 0
$master_profile = 99
Main_Controller()

$allow_no_login = 1
$master_profile = 0
$master_mission = 500
$clan_war_city = 2
Main_Controller()


Exit