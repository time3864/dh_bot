#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

;Delay_Time(20)
Default_Setting()

$retries = 10
$logging = 0
$allow_no_login = 1

$clan_donation_apple = 0
$clan_donation_internal_rewards = 1
$clan_donation_cross_rewards = 0
$clan_donation_accept = 2
Donation_Set()

$stop_min = 0
_FileWriteToLine("ad_hoc.txt", 1, $stop_min, True)

$players_file = "players_donate.txt"
$players_loopback = "players_miss.txt"
File_Backup_and_Delete($players_loopback)
$master_mission = 900
Main_Controller()

$players_file = $players_loopback
$players_loopback = "players_bad.txt"
File_Backup_and_Delete($players_loopback)
$master_mission = 900
Main_Controller()


Exit