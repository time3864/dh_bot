#include "bluestack.au3"


PC_SET_SCALE()
Teamviewer_Auto_Close()



DH_Express_Unified(0)


;Alliance_Dungeon_Rewards_Last()

;Spirit_Search()
;World_Boss()

If 1 Then
If Android_Front_Screen() <> 0 Then
MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: ")
EndIf
EndIf

;Maximize_Bluestack($hWnd_bluestack)



;Mouse_Recorder_Spam()

;Run("C:\ProgramData\BlueStacksGameManager\BlueStacks.exe")

;Sleep(10000)

;$hWnd_bluestack = WinGetHandle("[TITLE:Bluestacks App Player]")
;WinKill($hWnd_bluestack)


;Mouse_Recorder_Spam()

;Test_Mouse_Speed()

;Spam_World_Boss()

;Break_General()
;Break_Weapon()

;Array_Pixel_Check_Test()


;$log_file = "blog.txt"
;Error_Log("test")

;Encrypt_File("alog.txt", "alog_crypt.txt")
;Decrypt_File("alog_crypt.txt","alog.txt")

;Clan_War_City_Folder("war_city")

;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: " & Clan_War_City_Folder("war_city"))




If 0 Then
Send("{PRINTSCREEN}")
Run("mspaint")
WinWaitActive("Untitled - Paint")
Send("^v")
EndIf

;$my_string = "111333;"
;Remove_Comments($my_string)



;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: ")




;Onslaught_Mission()

;Redeem_Stars()

;Sleep(2000)

;Leader_Approve()


Exit


;#include "bluestack.au3"

Error_Log("----------------------------------------------------------------------")

$shutdown = 1
If @HOUR == 00 Then
$master_mission = 0
EndIf


Main_Controller()


Exit



















;New_Story()
;IGN_Create()
;Stage_01()

;Leader_Approve()
;Open_DH()

;Stage_02()
;Noob_Level_Up()

;$current_mission = 1
;All_Missions_Create()

;Noob_Level_Up()
;Formation_Unlock()

;Friend_Blessing_Noob()

If Noob_Up_Level() == 1 Then
MsgBox($MB_SYSTEMMODAL, "Check 01:", "lvl up")
EndIf



If Alliance_Page() == 1 Then
MsgBox($MB_SYSTEMMODAL, "Check 01:", "zDo you able to see DH main screen now:")
EndIf

;Mouse_Drag_Portable(1, 750, 911, 1150, 911)
;Sleep(1000)

;Mystic_Legend_General()

If 0 Then
;MsgBox($MB_SYSTEMMODAL, "Check 01:", "Do you able to see DH main screen now:" & Legend_General_Cleared() )
$players_file = "players_donate.txt"
$players_loopback = "loopback.txt"
$number_count = 1
PLAYER_INFO($number_count,7)
While ($player) And ($password) And ($server)
PLAYER_INFO_LOOPBACK()
$number_count = $number_count + 1
PLAYER_INFO($number_count,7)
WEnd
EndIf