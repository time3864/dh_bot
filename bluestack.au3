#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Inet.au3>

;#include "email.au3"

Global $current_mission
Global $status = 0
Global $player_count = 1

Global $players_file = "players.txt"

Global $master_mission = 0

Global $mission_run[101]
Global $player_hour[24]

Global $dh_x_base[2]
Global $dh_y_base[2]

Global $dh_x[2]
Global $dh_y[2]

Global $dh_x_scale
Global $dh_y_scale

;blue stack main configuration
Global $bluestack_setting = 0
Global $shutdown = 0

;configuration file
Global $player ; login id
Global $password ; password
Global $server ; server number
Global $player_active ; 0 mean no need bot for this player
Global $player_mission ; start mission
Global $player_mission_skip ; skip mission in format: 1,3,10
Global $player_hour_skip ; do not login player in these hours

;clan war settings
Global $clan_war_city = 0

;scan for image change
Global $screen_check[20]

;express login
Global $express_login

;mining scanning result
Global $mining_enemy[16]

;event dungeon map position
Global $event_dungeon_main[3][2]
;map ;stage ;position x and y
Global $event_dungeon[3][10][2]
Global $current_event_dungeon_map = 0
Global $current_event_dungeon_stage = 0
Global $event_dungeon_boss_count = 5
Global $event_dungeon_normal_count = 99

HotKeySet("^x", "_exit")
Func _exit()
	FileDelete(@ScriptDir & "\save.txt")
	Error_Log("Ctrl X")
	Exit
EndFunc   ;==>_exit

HotKeySet("^y", "_check")
Func _check()
	Local $hFile = FileOpen(@ScriptDir & "\save.txt", $FO_CREATEPATH & $FO_OVERWRITE )
	FileWrite($hFile, $player_count & @CRLF)
	FileWrite($hFile, $current_mission & @CRLF)
	FileClose($hFile)
	Error_Log("Mission saved!")
	Exit
EndFunc   ;==>_check

If 0 Then
	;Send_Email()
	Error_Log("----------------------------------------------------------------------")

	While(@HOUR == 23)
		Sleep(20000)
	WEnd

	Main_Controller()
	Exit
;Else

	;Clan_War_Attack()
	;Exit
EndIf


Func Main_Controller()

	PC_Check()
	Master_Settings()

	Local $current_mission_temp = 0

	;get parameters
	Local $input = $CmdLine[0]
	If $input == 1 Then
		$master_mission = $CmdLine[1]
	EndIf


	;check if previous saved session
	If FileExists (@ScriptDir & "\save.txt") Then
		Error_Log("Previous saved session!")

		Local $hFileOpen = FileOpen(@ScriptDir & "\save.txt", $FO_READ)
		$player_count = FileReadLine($hFileOpen, 1)
		$current_mission_temp = FileReadLine($hFileOpen, 2)
		FileClose($hFileOpen)

		;MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $player_count)
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $current_mission_temp)

		FileDelete(@ScriptDir & "\save.txt")

		PLAYER_INFO($player_count)
		$player_mission = $current_mission_temp
	Else
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $player_count)
		Error_Log("No previous saved session!")
		$player_count = 1
		PLAYER_INFO($player_count)
	EndIf

	;loop all players
	While ($player) And ($password) And ($server)
		;$master_mission will override master mission in player config file
		If $master_mission == 0 or $current_mission_temp <> 0 Then
			$current_mission = $player_mission
			$current_mission_temp = 0
		Else
			$current_mission = $master_mission
		EndIf
		If $player_active <> 0 And $player_hour[@HOUR] <> 0 Then
			For $i = 1 To 8
				$status = 0
				Open_DH()
				LOGIN()
				If $status == 0 Then
					All_Missions()
				EndIf
				Close_DH()
				;if no error, no need to restart
				If $status == 0 Then
					$i = 8
				EndIf
				If $i == 8 And $status == 0 Then
					Error_Log("Player mission completed!")
				Else
					Error_Log("Player mission failed!")
				EndIf
				Player_Control($player, $player_active)
				If $player_active == 0 Then
					$i = 8
					Error_Log("Player config abort mission!")
				EndIf
			Next ; For $i = 1 To 8
		EndIf ; If $$player_active <> 0 Then
		;read next player
		$player_count = $player_count + 1
		PLAYER_INFO($player_count)
	WEnd ;While ($player) And ($password) And ($server)

	Error_Log("No more player!")

	If $shutdown == 1 Then
		;shutdown after 20 minutes
		For $i = 1 to 20
			Sleep(60000)
		Next
		Shutdown($SD_SHUTDOWN)
	EndIf

EndFunc   ;==>Main_Controller


Func All_Missions()
	Error_Log("Start missions!")
	Switch $current_mission
		Case 1
			$current_mission = 1
			If ($mission_run[$current_mission]) Then Daily_Greeting()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 2
			$current_mission = 2
			If ($mission_run[$current_mission]) Then Flags()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 3
			$current_mission = 3
			If ($mission_run[$current_mission]) Then Tax_Collection()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 4
			$current_mission = 4
			If ($mission_run[$current_mission]) Then Awaken_Spin()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 5
			$current_mission = 5
			If ($mission_run[$current_mission]) Then Level_Up()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 6
			$current_mission = 6
			If ($mission_run[$current_mission]) Then Daily_Shop()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 7
			$current_mission = 7
			If ($mission_run[$current_mission]) Then Alliance_Mission()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 8
			$current_mission = 8
			If ($mission_run[$current_mission]) Then Souls_Battlefield()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 9
			$current_mission = 9
			If ($mission_run[$current_mission]) Then Rob_Mission(5)
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 10
			$current_mission = 10
			If ($mission_run[$current_mission]) Then War_Battle(1)
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 11
			$current_mission = 11
			If ($mission_run[$current_mission]) Then Arena_Mission()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 12
			$current_mission = 12
			If ($mission_run[$current_mission]) Then Arena_Rewards()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 13
			$current_mission = 13
			If ($mission_run[$current_mission]) Then Admire_crw()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 14
			$current_mission = 14
			If ($mission_run[$current_mission]) Then Legend_General()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 15
			$current_mission = 15
			;empty
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 16
			$current_mission = 16
			If ($mission_run[$current_mission]) Then General_Cultivate()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 17
			$current_mission = 17
			If ($mission_run[$current_mission]) Then Group_Battle(5)
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 18
			$current_mission = 18
			If ($mission_run[$current_mission]) Then Weapon_Refine()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 19
			$current_mission = 19
			If ($mission_run[$current_mission]) Then Altar_Spin()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 20
			$current_mission = 20
			If ($mission_run[$current_mission]) Then Onslaught_Mission()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 21
			$current_mission = 21
			If ($mission_run[$current_mission]) Then Collect_Gate_Rewards()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 22
			$current_mission = 22
			If ($mission_run[$current_mission]) Then
				If @WDAY == 4 or @WDAY == 2 Then
					Break_Weapon()
					Break_Soul()
				EndIf
			EndIf
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 23
			$current_mission = 23
			If ($mission_run[$current_mission]) Then Recruit_5_times()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 24
			$current_mission = 24
			If ($mission_run[$current_mission]) Then
				Spirit_Search()
				Spirit_Search_Gold()
			EndIf
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 25
			$current_mission = 25
			;empty
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 26
			$current_mission = 26
			If ($mission_run[$current_mission]) Then Borrow_Arrow()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 27
			$current_mission = 27
			If ($mission_run[$current_mission]) Then Tomb_Raid()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 28
			$current_mission = 28
			If ($mission_run[$current_mission]) Then Friend_Blessing()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 29
			$current_mission = 29
			If ($mission_run[$current_mission]) Then Mystic_Legend_General()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 30
			$current_mission = 30
			If ($mission_run[$current_mission]) Then Elite_Mode(1090) ;hard mode
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 100 ; mainly for collection
			$current_mission = 100
			Collect_Daily_Pack()
			Collect_Weekly_Rewards()
			Tax_Collection()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 101
			$current_mission = 101
			Extra_Return()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 102
			$current_mission = 102
			Collect_Rewards()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 103
			$current_mission = 103
			Collect_Monthly()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 104
			$current_mission = 104
			Collect_Token()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 105
			$current_mission = 105
			Free_Recruit()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 106
			$current_mission = 106
			Mission_Rewards()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 107
			$current_mission = 107
			Tax_Collection()
			Collect_Token()
			Clear_Token()
			If $status == 0 Then
				ContinueCase
			EndIf
		case 108
			$current_mission = 108
			If @WDAY == 1 Then
				Alliance_Dungeon_Rewards()
			EndIf
			If $status == 0 Then
				ContinueCase
			EndIf
		case 109
			$current_mission = 109
			If @WDAY == 6 Then
				Clan_War_Cross_Boost()
			EndIf
			If $status == 0 Then
				ContinueCase
			EndIf
		case 110
			$current_mission = 110
			If @WDAY == 3 Then
				Combine_Equipment()
				Combine_General()
			EndIf
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 199 ; collection end
			$current_mission = 199
			If $status == 0 Then
				FileDelete(@ScriptDir & "\save.txt")
				Error_Log("##### All mission completed! #####")
			EndIf ;finish all mission, quit
		Case 200
			$current_mission = 200
			Scheduled_Task()
			Collect_Rewards()
			If $status == 0 Then
				FileDelete(@ScriptDir & "\save.txt")
				Error_Log("##### All mission completed! #####")
			EndIf ;finish all mission, quit
		Case 300
			$current_mission = 300
			Weekly_Task()
			If $status == 0 Then
				ContinueCase
			EndIf
		Case 500
			$current_mission = 500
			Clan_War_Cross()
		Case 600
			$current_mission = 600
			Clan_War_Internal()
		Case 650
			$current_mission = 650
			Clan_War_Internal_Random()
		case 700
			$current_mission = 700
			Mining_Scan()
		case 1000
			$current_mission = 1000
			Dungeon_Bot()
	EndSwitch

EndFunc   ;==>All_Missions

Func STOP_SCRIPT()
	Exit
EndFunc   ;==>STOP_SCRIPT

Func Mouse_Click_Portable($xx, $yy)
	Compute_X_Coordinate($xx)
	Compute_Y_Coordinate($yy)
	MouseClick($MOUSE_CLICK_LEFT, $xx, $yy, 1)
EndFunc   ;==>Mouse_Click_Portable

Func Pixel_Search_Portable($xx, $yy, $range, $colour)
	Compute_X_Coordinate($xx)
	Compute_Y_Coordinate($yy)
	Return PixelSearch($xx-$range, $yy-$range, $xx+$range, $yy+$range, $colour, 10)
EndFunc

Func Pixel_Search_Portable_XY($xx, $yy, $range_x, $range_y, $colour)
	Compute_X_Coordinate($xx)
	Compute_Y_Coordinate($yy)
	Return PixelSearch($xx-$range_x, $yy-$range_y, $xx+$range_x, $yy+$range_y, $colour, 10)
EndFunc

Func Pixel_Read_Portable($xx, $yy)
	Compute_X_Coordinate($xx)
	Compute_Y_Coordinate($yy)
	Return PixelGetColor($xx, $yy)
EndFunc

Func Mouse_Drag_Portable($xx, $yy, $xx_drag, $yy_drag)
	Compute_X_Coordinate($xx)
	Compute_Y_Coordinate($yy)
	MouseClickDrag($MOUSE_CLICK_LEFT, $xx, $yy, $xx_drag, $yy_drag)
EndFunc

Func Compute_X_Coordinate(ByRef $x)
	$x = $dh_x[0] + ($x - $dh_x_base[0]) * $dh_x_scale
EndFunc

Func Compute_Y_Coordinate(ByRef $y)
	$y = $dh_y[0] + ($y - $dh_y_base[0]) * $dh_y_scale
EndFunc

Func Error_Log($log)
	Local $hFile = FileOpen(@ScriptDir & "\alog.txt", $FO_CREATEPATH & $FO_APPEND)

	_FileWriteLog($hFile, "Player: " & $player & " Current mission: " & $current_mission & " Reason: " & $log & @CRLF) ; Write to the logfile passing the filehandle returned by FileOpen.
	FileClose($hFile) ; Close the filehandle to release the file.
EndFunc   ;==>Error_Log


Func PC_Check()
	If @DesktopHeight <> 1080 Or @DesktopWidth <> 1920 Then
		MsgBox($MB_SYSTEMMODAL, "Aborted!", "Support only screen resolution of 1920x1080!")
		Exit
	EndIf
	;scale cannot be activated before it is calculated
	Reset_DH_Scale()
EndFunc

Func Compute_DH_Scale()
	;refer to master
	$dh_x_base[0] = 671
	$dh_x_base[1] = 1247
	$dh_y_base[0] = 52
	$dh_y_base[1] = 1079
	;check current pc edge
	DH_Border_Check()

	;compute scale
	DH_Scale_Calculate()
EndFunc

Func Reset_DH_Scale()
	$dh_x_scale = 1
	$dh_y_scale = 1
	$dh_x[0] = 0
	$dh_x[1] = 0
	$dh_y[0] = 0
	$dh_y[1] = 0
	$dh_x_base[0] = 0
	$dh_x_base[1] = 0
	$dh_y_base[0] = 0
	$dh_y_base[1] = 0
EndFunc

Func Master_Settings()

	Local $hFileOpen = FileOpen("settings.txt", $FO_READ)
	If $hFileOpen == -1 Then
		Error_Log("Settings failed!")
	Else
		Error_Log("Settings OK!")
		Local $sFileRead = FileReadLine($hFileOpen, 1)
		$bluestack_setting = $sFileRead
		;MsgBox($MB_SYSTEMMODAL, "", "File read: " & $bluestack_setting)
		FileClose($hFileOpen)
	EndIf

EndFunc   ;==>Master_Command

Func Detect_Main_Screen()
	;detect main screen
	$FA = Pixel_Search_Portable(1116,83,1,0xEAB70E)
	$FB = Pixel_Search_Portable(780,845,1,0x891010)
	$FC = Pixel_Search_Portable(1174,848,1,0x800A0A)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>Detect_Main_Screen

Func BACK_TO_MAIN_SCREEN()
	;press x
	For $i = 1 To 5
		Mouse_Click_Portable(1202, 1038)
		Sleep(3000)
		If Detect_Main_Screen() Then
			Return
		EndIf
	Next
	Error_Log("Mission failed!")
	;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Main screen failed! Current mission: " & $current_mission)
	;STOP_SCRIPT()
	$status = 1
EndFunc   ;==>BACK_TO_MAIN_SCREEN

Func Save_Screen()
	$screen_check[0] = Pixel_Read_Portable(729,345)
	$screen_check[1] = Pixel_Read_Portable(736,965)
	$screen_check[2] = Pixel_Read_Portable(1177,1017)
	$screen_check[3] = Pixel_Read_Portable(856,87)
	$screen_check[4] = Pixel_Read_Portable(1160,86)
	$screen_check[5] = Pixel_Read_Portable(1024,1021)
	$screen_check[6] = Pixel_Read_Portable(1116,790)
	$screen_check[7] = Pixel_Read_Portable(1078,155)
	$screen_check[8] = Pixel_Read_Portable(688,813)
	$screen_check[9] = Pixel_Read_Portable(1231,797)
	$screen_check[10] = Pixel_Read_Portable(697,323)
	$screen_check[11] = Pixel_Read_Portable(893,144)
	$screen_check[12] = Pixel_Read_Portable(843,931)
	$screen_check[13] = Pixel_Read_Portable(694,983)
	$screen_check[14] = Pixel_Read_Portable(1212,912)
	$screen_check[15] = Pixel_Read_Portable(972,555)
	$screen_check[16] = Pixel_Read_Portable(904,962)
	$screen_check[17] = Pixel_Read_Portable(679,247)
	$screen_check[18] = Pixel_Read_Portable(1225,795)
	$screen_check[19] = Pixel_Read_Portable(952,65)
EndFunc

Func Check_Screen()
	Local $compare = 0

	If $screen_check[0] == Pixel_Read_Portable(729,345) Then $compare = $compare + 1
	If $screen_check[1] == Pixel_Read_Portable(736,965) Then $compare = $compare + 1
	If $screen_check[2] == Pixel_Read_Portable(1177,1017) Then $compare = $compare + 1
	If $screen_check[3] == Pixel_Read_Portable(856,87) Then $compare = $compare + 1
	If $screen_check[4] == Pixel_Read_Portable(1160,86) Then $compare = $compare + 1
	If $screen_check[5] == Pixel_Read_Portable(1024,1021) Then $compare = $compare + 1
	If $screen_check[6] == Pixel_Read_Portable(1116,790) Then $compare = $compare + 1
	If $screen_check[7] == Pixel_Read_Portable(1078,155) Then $compare = $compare + 1
	If $screen_check[8] == Pixel_Read_Portable(688,813) Then $compare = $compare + 1
	If $screen_check[9] == Pixel_Read_Portable(1231,797) Then $compare = $compare + 1
	If $screen_check[10] = Pixel_Read_Portable(697,323) Then $compare = $compare + 1
	If $screen_check[11] = Pixel_Read_Portable(893,144) Then $compare = $compare + 1
	If $screen_check[12] = Pixel_Read_Portable(843,931) Then $compare = $compare + 1
	If $screen_check[13] = Pixel_Read_Portable(694,983) Then $compare = $compare + 1
	If $screen_check[14] = Pixel_Read_Portable(1212,912) Then $compare = $compare + 1
	If $screen_check[15] = Pixel_Read_Portable(972,555) Then $compare = $compare + 1
	If $screen_check[16] = Pixel_Read_Portable(904,962) Then $compare = $compare + 1
	If $screen_check[17] = Pixel_Read_Portable(679,247) Then $compare = $compare + 1
	If $screen_check[18] = Pixel_Read_Portable(1225,795) Then $compare = $compare + 1
	If $screen_check[19] = Pixel_Read_Portable(952,65) Then $compare = $compare + 1

	Return $compare
EndFunc

Func PLAYER_INFO($number)

	$player = 0
	$password = 0
	$server = 0

	Local $sFileRead
	Local $hFileOpen = FileOpen($players_file, $FO_READ)
	If $hFileOpen == -1 Then
		Error_Log("Players list failed!")
	Else
		$sFileRead = FileReadLine($hFileOpen, 1 + ($number - 1) * 7)
		If $sFileRead Then
			$player = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 2 + ($number - 1) * 7)
		If $sFileRead Then
			$password = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 3 + ($number - 1) * 7)
		If $sFileRead Then
			$server = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 4 + ($number - 1) * 7)
		If $sFileRead Then
			$player_active = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 5 + ($number - 1) * 7)
		If $sFileRead Then
			$player_mission = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 6 + ($number - 1) * 7)
		If $sFileRead Then
			$player_mission_skip = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 7 + ($number - 1) * 7)
		If $sFileRead Then
			$player_hour_skip = $sFileRead
		EndIf
		FileClose($hFileOpen)

		If $player_active <> 0 Then
		Player_Control($player, $player_active)
		EndIf
		Exclude_Mission()
		Exclude_Hour()

		Error_Log("Reading players!")
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: " & $player & ":" & $password & ":" & $server & ":" & $player_active)
	EndIf

EndFunc   ;==>PLAYER_INFO

Func Player_Control($player_email, ByRef $enable)

	If FileExists (@ScriptDir & "\players_control_panel\" & $player_email & ".txt") Then

		Local $sFileRead
		Local $hFileOpen = FileOpen(@ScriptDir & "\players_control_panel\" & $player_email & ".txt", $FO_READ)

		If $hFileOpen == -1 Then

		Else
			$sFileRead = FileReadLine($hFileOpen, 1)
			If $sFileRead Then
				$enable = $sFileRead
			EndIf
		EndIf
	EndIf

EndFunc

Func LOGIN_PLAYER()
	;click server
	Mouse_Click_Portable(1124, 82)
	Sleep(5000)
	;drag up
	Mouse_Drag_Portable(938, 888, 938, 505)
	Sleep(1000)
	Mouse_Drag_Portable(938, 888, 938, 505)
	Sleep(1000)
	;choose server
	If $server == 4 Then
		Mouse_Click_Portable(1119, 724)
		Sleep(2000)
	ElseIf $server == 6 Then
		Mouse_Click_Portable(1119, 645)
		Sleep(2000)
	ElseIf $server == 5 Then
		Mouse_Click_Portable(820, 725)
		Sleep(2000)
	Else
		Mouse_Click_Portable(814, 886)
		Sleep(2000)
	EndIf
	;user login
	Mouse_Click_Portable(814, 84)
	Sleep(2000)
	;email
	Mouse_Click_Portable(950, 690)
	Sleep(2000)
	;click account
	Mouse_Click_Portable(994, 442)
	Sleep(2000)
	Mouse_Click_Portable(994, 442)
	Sleep(2000)
	Send($player)
	Send("{Enter}")
	Sleep(1000)
	;click password
	Mouse_Click_Portable(994, 515)
	Sleep(2000)
	Mouse_Click_Portable(994, 515)
	Sleep(2000)
	Send($password)
	Send("{Enter}")
	Sleep(1000)
	;click login
	Mouse_Click_Portable(944, 676)
	Sleep(10000)
EndFunc   ;==>LOGIN_PLAYER


Func Exclude_Mission()
	For $i = 1 To 100
		$mission_run[$i] = 1
	Next

	Local $missions
	If $player_mission_skip <> 0 Then ;if not 0, mean have missions need to skip
		;split mission list
		$missions = StringSplit($player_mission_skip, ",")
		If IsArray($missions) Then
			For $i = 1 To $missions[0]
				If $missions[$i] < 100 Then
				$mission_run[$missions[$i]] = 0
				EndIf
			Next
		EndIf
	EndIf

	;For $i = 1 To 100
	;MsgBox($MB_SYSTEMMODAL, "Mission Check", $i & ":" & $mission_run[$i])
	;Next
EndFunc   ;==>Exclude_Mission

Func Exclude_Hour()
	For $i = 0 To 23
		$player_hour[$i] = 1
	Next

	Local $hour
	If $player_hour_skip <> 25 Then ;if not 0, mean have missions need to skip
		;split mission list
		$hour = StringSplit($player_hour_skip, ",")
		If IsArray($hour) Then
			For $i = 1 To $hour[0]
				If $hour[$i] < 23 Then
				$player_hour[$hour[$i]] = 0
				EndIf
			Next
		EndIf
	EndIf

	;For $i = 1 To 100
	;MsgBox($MB_SYSTEMMODAL, "Mission Check", $i & ":" & $mission_run[$i])
	;Next
EndFunc

Func Clan_War_City_Read()

	Local $sFileRead
	Local $hFileOpen = FileOpen("war_city.txt", $FO_READ)
	If $hFileOpen == -1 Then
		Error_Log("City list failed!")
	Else
		$sFileRead = FileReadLine($hFileOpen, 1)
		If $sFileRead And $sFileRead <> 0 Then
			$clan_war_city = $sFileRead
		EndIf
		FileClose($hFileOpen)

		Error_Log("Reading city!")
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: " & $player & ":" & $password & ":" & $server)
	EndIf

EndFunc   ;==>Clan_War_City_Read

Func Border_Detection($xx, $yy, $xx_d, $yy_d, $colour)
	While ($xx < 1920) & ($yy < 1080) & ($xx > 0) & ($yy > 0)
		$xx += $xx_d
		$yy += $yy_d
		If PixelGetColor($xx, $yy) <> $colour Then
			Local $found[2]
			$found[0] = $xx
			$found[1] = $yy
			Return $found
		EndIf
	WEnd
	Return 0
EndFunc

Func DH_Border_Check()
	;Local $xx
	;Local $yy
	Local $FF
	$FF = Border_Detection(0,200,10,0,0x000000)
	If IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$FF = Border_Detection($FF[0]-10,200,1,0,0x000000)
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$dh_x[0] = $FF[0]
	EndIf
	$FF = Border_Detection(1919,200,-10,0,0x000000)
	If IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$FF = Border_Detection($FF[0]+10,200,-1,0,0x000000)
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$dh_x[1] = $FF[0]
	EndIf

	;use dh_x trying to find dh_y
	$FF = Border_Detection($dh_x[1]+1,540,0,-10,0x000000)
	If IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$FF = Border_Detection($dh_x[1]+1,$FF[1]+10,0,-1,0x000000)
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$dh_y[0] = $FF[1]
	EndIf
	$FF = Border_Detection($dh_x[1]+1,540,0,10,0x000000)
	If IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$FF = Border_Detection($dh_x[1]+1,$FF[1]-10,0,1,0x000000)
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", $FF[0] & ":" & $FF[1])
		$dh_y[1] = $FF[1]
	EndIf

	Error_Log($dh_x[0] & ":" & $dh_x[1] & ":" & $dh_y[0] & ":" & $dh_y[1])
EndFunc

Func DH_Scale_Calculate()
	$dh_x_scale = ($dh_x[1] - $dh_x[0]) / ($dh_x_base[1] - $dh_x_base[0])
	$dh_y_scale = ($dh_y[1] - $dh_y[0]) / ($dh_y_base[1] - $dh_y_base[0])
	Error_Log($dh_x_scale & ":" & $dh_y_scale)
EndFunc

Func Maximize_Bluestack($handler)
	Local $aPos = WinGetPos($handler)

	If IsArray($aPos) Then
		Local $xpos = $aPos[0]
		Local $ypos = $aPos[1]
		Local $width = $aPos[2]
		Local $height = $aPos[3]
		If $xpos <> 0 and $ypos <> 0 Then
			Mouse_Click_Portable($xpos + $width - 100, $ypos + 20)
			Error_Log("Maximize needed!")
			Sleep(5000)
		EndIf
	Else
		Error_Log("WinGetPos failed!")
	EndIf
EndFunc

Func Open_DH()
	Reset_DH_Scale()
	;Open Blue Stack
	;Run("C:\ProgramData\BlueStacksGameManager\BlueStacks.exe")
	;Global $hWnd_bluestack = WinWait("[CLASS:BlueStacksApp]", "", 10)
	;WinActivate($hWnd_bluestack)
	Run("C:\ProgramData\BlueStacksGameManager\BlueStacks.exe")
	Sleep(10000)
	Global $hWnd_bluestack = WinGetHandle("[TITLE:Bluestacks App Player]")
	Sleep(5000)
	WinActivate($hWnd_bluestack)
	WinWaitActive($hWnd_bluestack, "", 30)
	;need to check if Blue stack maximized ;;todo
	If $bluestack_setting <> 0 Then
		Maximize_Bluestack($hWnd_bluestack)
	EndIf
	;go to "Android tab"
	Mouse_Click_Portable(320, 30)
	Sleep(20000)
	;click back to main page
	Mouse_Click_Portable(34, 31)
	Sleep(5000)
	;drag up
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(1000)
	;open all apps
	Mouse_Click_Portable(1799, 213)
	Sleep(15000)
	;Open game
	Mouse_Click_Portable(702, 223)
	;Mouse_Click_Portable(329, 219)
	Sleep(20000)
	;check if Blue Stack ads opened ;;todo
	$FA = Pixel_Search_Portable(495,715,5,0xACD75F)
	$FB = Pixel_Search_Portable(1315,711,5,0x5DB6D4)
	$FC = Pixel_Search_Portable(955,171,5,0x65A020)
	$FD = Pixel_Search_Portable(945,531,5,0x5D6C71)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Error_Log("Advertisement!")
		Mouse_Click_Portable(1402, 717)
		Sleep(15000)
		$status = 1
		Return
	EndIf
	Compute_DH_Scale()
	;Check for front page
	$FA = Pixel_Search_Portable(1001,369,1,0xFFFFFF)
	$FB = Pixel_Search_Portable(750,910,1,0xFFE075)
	$FC = Pixel_Search_Portable(927,245,1,0x393931)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Error_Log("DH opened!")
	EndIf
EndFunc

Func LOGIN()
	LOGIN_PLAYER()
	Sleep(15000)

	;Check for robbed
	$FA = Pixel_Search_Portable(837,884,1,0x01B429)
	$FB = Pixel_Search_Portable(1069,883,1,0X9E1212)
	$FC = Pixel_Search_Portable(974,624,1,0x403b37)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Mouse_Click_Portable(841, 893)
	EndIf
	Sleep(10000)

	If Detect_Main_Screen() == 1 Then
		Mouse_Click_Portable(944, 532)
		Error_Log("Account opened!")
	Else
		$status = 1
		Error_Log("Program failed!")
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Main screen failed!")
		;STOP_SCRIPT()
	EndIf
	Sleep(10000)
EndFunc   ;==>Open_DH

Func Open_DH_Express()
	;Open Blue Stack
	Run("C:\ProgramData\BlueStacksGameManager\BlueStacks.exe")
	Local $hWnd = WinWait("[CLASS:BlueStacksApp]", "", 5)
	WinActivate($hWnd)
	;need to check if Blue stack maximized ;;todo

	;go to "Android tab"
	Mouse_Click_Portable(386, 30)
	Sleep(3000)
	;click back to main page
	Mouse_Click_Portable(34, 31)
	Sleep(3000)
	;drag up
	For $i = 1 to 3
	Mouse_Drag_Portable(938, 474, 938, 888)
	Sleep(500)
	Next
	;open all apps
	Mouse_Click_Portable(1799, 213)
	Sleep(3000)
	;Open game
	Mouse_Click_Portable(702, 223)
	Sleep(10000)
	;check if Blue Stack ads opened ;;todo
	$FA = Pixel_Search_Portable(495,715,5,0xACD75F)
	$FB = Pixel_Search_Portable(1315,711,5,0x5DB6D4)
	$FC = Pixel_Search_Portable(955,171,5,0x65A020)
	$FD = Pixel_Search_Portable(945,531,5,0x5D6C71)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Mouse_Click_Portable(1402, 717)
		Sleep(8000)
	EndIf
	;Check for front page
	$FA = Pixel_Search_Portable(1001,369,1,0xFFFFFF)
	$FB = Pixel_Search_Portable(750,910,1,0xFFE075)
	$FC = Pixel_Search_Portable(927,245,1,0x393931)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Error_Log("DH opened!")
	EndIf

	Mouse_Click_Portable(997, 546)
	Sleep(10000)

	If Detect_Main_Screen() == 1 Then
		Mouse_Click_Portable(944, 532)
		Error_Log("Account opened!")
	Else
		$status = 1
		Error_Log("Program failed!")
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Main screen failed!")
		;STOP_SCRIPT()
	EndIf
EndFunc

Func Close_DH()
	Reset_DH_Scale()
	For $i = 1 to 5
	Mouse_Click_Portable(745, 26)
	Sleep(2000)
	Mouse_Click_Portable(542, 22)
	Sleep(2000)
	Next
	Error_Log("DH closed!")
EndFunc   ;==>Close_DH


Func Battle_Start()
	;start battle
	Mouse_Click_Portable(953, 1032)
	Sleep(5000)
	;check if ask for use token?

	;check if auto on
	$FA = Pixel_Search_Portable(1212,1056,1,0x7D7D7D)
	$FB = Pixel_Search_Portable(1221,1024,1,0x222222)
	$FC = Pixel_Search_Portable(1192,1057,1,0x090909)
	If IsArray($FA) Or IsArray($FB) Or IsArray($FC) Then
		Mouse_Click_Portable(1191, 1056)
		Sleep(1000)
	EndIf
	;hard to judge if x2 is on, just click for alternate x1 and x2
	Sleep(3000)
	Mouse_Click_Portable(781, 1029)
	Sleep(1000)

EndFunc   ;==>Battle_Start

Func Battle_End()
	;wait until battle finish
	Local $i = 0
	Local $timeout = 300
	Do
		$FA = Pixel_Search_Portable(942,868,1,0x06B706)
		$FB = Pixel_Search_Portable(953,913,1,0X0FC40E)
		$FC = Pixel_Search_Portable(947,871,1,0X15B515)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			$i = 1
		Else
			$timeout = $timeout - 1
			If $timeout > 0 Then
				$i = 0 ; continue running if not timeout
			Else
				$i = 1 ; discontinued if timeout
			EndIf
			Sleep(1000)
		EndIf
	Until $i = 1
	Mouse_Click_Portable(951, 886)
	Sleep(1000)
	Mouse_Click_Portable(951, 886)
	Sleep(1000)

EndFunc   ;==>Battle_End


Func Rob_End()
	;if token finish
	$FA = Pixel_Search_Portable_XY(833,708,35,21,0x01BA31)
	$FB = Pixel_Search_Portable_XY(1082,711,35,21,0x00B12D)
	If IsArray($FA) And IsArray($FB) Then
		Mouse_Click_Portable(1181, 426)
		Sleep(1000)
		Return
	EndIf
	Local $timeout = 90
	;wait until battle finish
	Local $i = 0
	Do
		$FA = Pixel_Search_Portable(938,905,4,0x10BA1E)
		$FB = Pixel_Search_Portable(958,952,4,0X19BB10)
		$FC = Pixel_Search_Portable(988,912,4,0X0A9F0F)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			$i = 1
		Else
			Sleep(1000)
		EndIf
		$FA = Pixel_Search_Portable(941,911,4,0xB40B0B)
		$FB = Pixel_Search_Portable(942,915,4,0XC40F0F)
		$FC = Pixel_Search_Portable(985,912,4,0X9C0E06)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			$i = 1
		Else
			Sleep(1000)
		EndIf
		$timeout = $timeout - 1
		If $timeout > 0 Then
		Else
			$i = 1 ; discontinued if timeout
		EndIf
	Until $i = 1
	Mouse_Click_Portable(957, 927)
	Sleep(1000)

EndFunc   ;==>Rob_End


Func Mystic_Battle_End()
Local $timeout = 300
Local $end = 0
Do
;battle lose
$FA = Pixel_Search_Portable(937,872,2,0x07B307)
$FB = Pixel_Search_Portable(979,208,2,0xD60303)
$FC = Pixel_Search_Portable(852,308,2,0x99A2AA)
If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
	;give up
	Mouse_Click_Portable(963, 881)
	Sleep(1000)
	Mouse_Click_Portable(963, 881)
	Sleep(1000)
	Mouse_Click_Portable(1194, 263)
	Sleep(1000)
	$end = 1
EndIf
;partial success
$FA = Pixel_Search_Portable(846,865,2,0xC30E0E)
$FB = Pixel_Search_Portable(1043,869,2,0x0FB90F)
$FC = Pixel_Search_Portable(888,176,2,0xCE0808)
If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
	;claim rewards
	Mouse_Click_Portable(1059, 880)
	Sleep(2000)
	Mouse_Click_Portable(841, 240)
	Sleep(8000)
	Mouse_Click_Portable(1194, 263)
	Sleep(1000)
	$end = 1
EndIf
;full success
$FA = Pixel_Search_Portable(949,864,2,0x10BD10)
$FB = Pixel_Search_Portable(834,565,2,0xCB50F4)
$FC = Pixel_Search_Portable(1094,585,2,0xC79560)
If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
	;claim rewards
	Mouse_Click_Portable(962, 880)
	Sleep(2000)
	Mouse_Click_Portable(841, 240)
	Sleep(8000)
	Mouse_Click_Portable(1194, 263)
	Sleep(1000)
	$end = 1
EndIf
Sleep(1000)
$timeout = $timeout - 1
If $timeout > 0 Then
Else
	$end = 1 ; discontinued if timeout
EndIf
Until $end = 1

EndFunc


Func Auto_Battle()
	For $i=1 to 10

	Next
EndFunc


;;daily greeting
Func Daily_Greeting()
	Mouse_Click_Portable(941, 882)
	Sleep(1000)
	Mouse_Click_Portable(806, 952)
	Sleep(1000)
	Send("hi{Enter}")
	Sleep(2000)
	Mouse_Click_Portable(952, 1038)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Daily_Greeting

;;Flags
Func Flags()
	Mouse_Click_Portable(723, 1018)
	Sleep(1000)
	Mouse_Click_Portable(950, 321)
	Sleep(1000)
	Mouse_Click_Portable(961, 1024)
	Sleep(2000)
	;press x
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Flags

;;Coin
Func Tax_Collection()
	Mouse_Click_Portable(1098, 291)
	Sleep(1000)
	Mouse_Click_Portable(948, 1035)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Tax_Collection


;;Awaken spin
Func Awaken_Spin()
	Mouse_Click_Portable(723, 1018)
	Sleep(1000)
	Mouse_Click_Portable(1146, 691)
	Sleep(1000)
	Mouse_Click_Portable(750, 124)
	Sleep(1000)
	Mouse_Click_Portable(792, 836)
	Sleep(5000)
	;return
	Mouse_Click_Portable(834, 1001)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Awaken_Spin

;;level up
Func Level_Up()
	Mouse_Click_Portable(815, 1016)
	Sleep(1000)
	Mouse_Click_Portable(953, 234)
	Sleep(1000)
	Mouse_Click_Portable(956, 459)
	Sleep(1000)
	Mouse_Click_Portable(888, 940)
	Sleep(1000)
	For $i = 1 To 10
		;auto-add
		Mouse_Click_Portable(956, 837)
		Sleep(500)
		;remove general
		$FA = Pixel_Search_Portable(940,700,2,0xD83602)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
		EndIf
		;remove general
		$FA = Pixel_Search_Portable(1076,702,2,0xDC3504)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
		EndIf
		;remove general
		$FA = Pixel_Search_Portable(1216,704,2,0xDC3801)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
		EndIf
		;remove general
		$FA = Pixel_Search_Portable(800,830,2,0xDD3701)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
		EndIf
		;remove general
		$FA = Pixel_Search_Portable(1214,830,2,0xDF3802)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
		EndIf

		Mouse_Click_Portable(947, 1034)
		Sleep(500)
	Next

	For $i = 1 To 20
		;auto-add
		Mouse_Click_Portable(956, 837)
		Sleep(500)
		Mouse_Click_Portable(947, 1034)
		Sleep(500)
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Level_Up

;;Shop
Func Daily_Shop()
	Mouse_Click_Portable(1105, 1017)
	Sleep(1000)
	;co
	Mouse_Click_Portable(1159, 718)
	Sleep(1000)
	;+10
	Mouse_Click_Portable(1101, 710)
	Sleep(1000)
	;purchase
	Mouse_Click_Portable(957, 879)
	Sleep(1000)
	Mouse_Click_Portable(1202, 1038)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Daily_Shop


Func Alliance_Page()
	$FA = Pixel_Search_Portable(784, 275, 3, 0x0A4C0A)
	$FB = Pixel_Search_Portable(1134, 354, 3, 0x635A5A)
	$FC = Pixel_Search_Portable(693, 354, 3, 0xEAD550)
	$FD = Pixel_Search_Portable(757, 821, 3, 0x100E0E)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc


Func Alliance_Mission()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;todo check for alliance page
	If Alliance_Page() <> 1 Then
		BACK_TO_MAIN_SCREEN()
		Return
	EndIf
	;construction
	Mouse_Click_Portable(963, 416)
	Sleep(1000)
	Mouse_Click_Portable(840, 949)
	Sleep(1000)
	Mouse_Click_Portable(840, 949)
	Sleep(1000)
	Mouse_Click_Portable(840, 949)
	Sleep(1000)
	Mouse_Click_Portable(840, 949)
	Sleep(1000)
	Mouse_Click_Portable(840, 949)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)
	;temple worship
	Mouse_Click_Portable(959, 610)
	Sleep(1000)
	For $i = 1 To 5
		Mouse_Click_Portable(960, 1002)
		Sleep(1000)
		Mouse_Click_Portable(823, 645)
		Sleep(1000)
		Mouse_Click_Portable(958, 691)
		Sleep(1000)
	Next
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)

	If 0 Then
	;drag to alliance shop
	;drag
	Mouse_Drag_Portable(938, 517, 938, 322)
	Sleep(1000)
	;click alliance shop
	Mouse_Click_Portable(958, 825)
	Sleep(1000)
	;drag once
	Mouse_Drag_Portable(938, 918, 938, 386)
	Sleep(1000)
	Mouse_Drag_Portable(938, 918, 938, 386)
	Sleep(1000)
	;buy bahuang stone
	Mouse_Click_Portable(1133, 373)
	Sleep(1000)
	Mouse_Click_Portable(1100, 707)
	Sleep(1000)
	Mouse_Click_Portable(960, 886)
	Sleep(1000)
	Mouse_Click_Portable(1052, 205)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)
	EndIf

	;internal server war rewards
	;drag to top
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;;war page collect rewards
	Mouse_Click_Portable(972, 837)
	Sleep(5000)
	Mouse_Click_Portable(1190, 115)
	Sleep(1000)
	Mouse_Click_Portable(950, 1030)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)

	;cross server war rewards
	;drag to top
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	Mouse_Drag_Portable(938, 474, 938, 828)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;;war page collect rewards
	Mouse_Click_Portable(967, 622)
	Sleep(5000)
	Mouse_Click_Portable(1190, 115)
	Sleep(1000)
	Mouse_Click_Portable(950, 1030)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)
	;return to alliance main page
	Mouse_Click_Portable(709, 1041)
	Sleep(1000)

	;drag to bottom
	Mouse_Drag_Portable(938, 882, 938, 474)
	Sleep(1000)
	Mouse_Drag_Portable(938, 882, 938, 474)
	Sleep(1000)
	Mouse_Drag_Portable(938, 882, 938, 474)
	Sleep(1000)
	;;alliance dungeon
	;;todo need to check for war
	Mouse_Click_Portable(954, 571)
	Sleep(2000)
	Save_Screen()
	For $i = 1 To 3
		Mouse_Click_Portable(954, 306)
		Sleep(5000)
		If Check_Screen() < 10 Then
		Mouse_Click_Portable(954, 1032)
		Sleep(8000)
		Mouse_Click_Portable(1215, 1036)
		Sleep(5000)
		Mouse_Click_Portable(960, 823)
		Sleep(5000)
		EndIf
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Alliance_Mission


;;arena
Func Arena_Mission()
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	Mouse_Click_Portable(959, 520)
	Sleep(1000)
	For $i = 1 To 5
		;drag to bottom
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(1000)
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(1000)
		Mouse_Click_Portable(1165, 899)
		Sleep(10000)
		Mouse_Click_Portable(1213, 1042)
		Sleep(10000)
		Mouse_Click_Portable(960, 884)
		Sleep(10000)
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Arena_Mission

Func Arena_Rewards()
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	Mouse_Click_Portable(959, 520)
	Sleep(1000)
	;;arena collection
	;enter reward page
	Mouse_Click_Portable(866, 1008)
	Sleep(1000)
	;collect
	Mouse_Click_Portable(1172, 390)
	Sleep(1000)
	Mouse_Click_Portable(1172, 569)
	Sleep(1000)
	Mouse_Click_Portable(1172, 750)
	Sleep(1000)
	Mouse_Click_Portable(1172, 928)
	Sleep(1000)
	;5th reward
	;slight drag
	Mouse_Drag_Portable(949, 845, 949, 312)
	Sleep(1000)
	Mouse_Click_Portable(1172, 390)
	Sleep(1000)
	Mouse_Click_Portable(1172, 569)
	Sleep(1000)
	Mouse_Click_Portable(1172, 750)
	Sleep(1000)
	Mouse_Click_Portable(1172, 928)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Arena_Rewards
;;




;;Cross-realm war
Func Admire_crw()
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;click page
	Mouse_Click_Portable(948, 358)
	Sleep(1000)
	;click admire
	Mouse_Click_Portable(788, 917)
	Sleep(1000)
	;gold admire
	Mouse_Click_Portable(876, 1025)
	Sleep(1000)
	Mouse_Click_Portable(876, 1025)
	Sleep(1000)
	Mouse_Click_Portable(876, 1025)
	Sleep(1000)
	;coin admire
	Mouse_Click_Portable(1043, 1024)
	Sleep(1000)
	Mouse_Click_Portable(1043, 1024)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Admire_crw

Func Borrow_Arrow()
	If @HOUR == 0 Or @HOUR == 23 Then
		Return
	EndIf
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	;click borrow arrow
	Mouse_Click_Portable(951, 293)
	Sleep(1000)
	;click appointment
	Mouse_Click_Portable(779, 937)
	Sleep(1000)
	;click appoint
	Mouse_Click_Portable(958, 884)
	Sleep(1000)
	;click confirm
	Mouse_Click_Portable(959, 642)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Borrow_Arrow

Func Souls_Battlefield()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	;click page
	Mouse_Click_Portable(945, 729)
	Sleep(1000)
	;go to battle
	Mouse_Click_Portable(1152, 707)
	Sleep(1000)

	;drag to bottom
	For $i = 1 To 15
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;check last box colour, if it is green, sweep
	Local $error = 0
	Do
		$FA = Pixel_Search_Portable(1058,912,34,0x00B831)
		If IsArray($FA) == 0 Then
			Mouse_Drag_Portable(954, 801, 954, 900)
			Sleep(500)
		EndIf
		$error = $error + 1
	Until IsArray($FA) Or ($error == 100)

	If $error == 100 Then

	Else
		For $i = 1 To 3
			;click the green button
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(1000)
			;;should check for triumph
			;click triumph
			Mouse_Click_Portable(959, 884)
			Sleep(1000)
		Next
	EndIf

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Souls_Battlefield

Func Legend_General()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;drag up 3 boxes
	Mouse_Drag_Portable(953, 183, 953, 943)
	Sleep(1000)
	;click legends page
	Mouse_Click_Portable(950, 390)
	Sleep(1000)
	If Legend_General_Page() == 1 Then
	;click zhang jiao
	Mouse_Click_Portable(1155, 919)
	Sleep(1000)
	;click middle
	Mouse_Click_Portable(943, 549)
	Sleep(1000)
	For $i = 1 To 5
		Save_Screen()
		;click Cao Cao
		Mouse_Click_Portable(987, 344)
		Sleep(1000)
		;click battle
		Mouse_Click_Portable(957, 866)
		Sleep(1000)
		;click start
		Mouse_Click_Portable(964, 1036)
		Sleep(2000)
		If Check_Screen() < 10 Then
			Battle_Start()
			Battle_End()
		Else
			$i = 5
		EndIf
	Next
	EndIf
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Legend_General




Func Mystic_Legend_General()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;drag up 3 boxes
	Mouse_Drag_Portable(953, 183, 953, 943)
	Sleep(1000)
	;click legends page
	Mouse_Click_Portable(950, 390)
	Sleep(1000)
	;click luxun
	Mouse_Click_Portable(762, 919)
	Sleep(1500)
	;click mystic
	Mouse_Click_Portable(1161, 768)
	Sleep(2000)
	;click battle
	Mouse_Click_Portable(955, 863)
	Sleep(1000)
	;click battle start
	Mouse_Click_Portable(962, 1039)
	Sleep(1000)

	Battle_Start()
	Mystic_Battle_End()

	BACK_TO_MAIN_SCREEN()
EndFunc


Func Legend_General_Page()

	$FA = Pixel_Search_Portable(968,852,2,0x65542B)
	$FB = Pixel_Search_Portable(993,667,2,0xBA0000)
	$FC = Pixel_Search_Portable(700,696,2,0x5C4C2B)
	$FD = Pixel_Search_Portable(1201,376,2,0x221A11)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func Free_Spin_Altar()

EndFunc   ;==>Free_Spin_Altar


Func General_Cultivate()
	;click general
	Mouse_Click_Portable(816, 1015)
	Sleep(1000)
	;click last general
	Mouse_Click_Portable(1190, 238)
	Sleep(1000)
	;click change general
	Mouse_Click_Portable(726, 1026)
	Sleep(1000)
	;click first general in queue
	Mouse_Click_Portable(1165, 321)
	Sleep(1000)
	;click general image
	Mouse_Click_Portable(940, 486)
	Sleep(1000)
	;click cultivate
	Mouse_Click_Portable(1161, 938)
	Sleep(2000)
	;click cultivate
	Mouse_Click_Portable(960, 1036)
	Sleep(2000)
	;click back
	Mouse_Click_Portable(710, 1033)
	Sleep(1000)
	;click change general
	Mouse_Click_Portable(726, 1026)
	Sleep(1000)
	;click first general in queue
	Mouse_Click_Portable(1165, 321)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>General_Cultivate

Func Group_Battle($round)
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;click group battle dungeon
	Mouse_Click_Portable(941, 588)
	Sleep(1000)
	For $i = 1 to $round
	;click create
	Mouse_Click_Portable(1156, 219)
	Sleep(1000)
	;select last dungeon
	Mouse_Click_Portable(1163, 773)
	Sleep(1000)
	;click confirm
	Mouse_Click_Portable(961, 725)
	Sleep(1000)
	;close room
	Mouse_Click_Portable(1088, 199)
	Sleep(1000)
	;click enter
	Mouse_Click_Portable(960, 1036)
	Sleep(2000)
	;click start
	Mouse_Click_Portable(960, 1036)
	Sleep(1000)
	;click back
	Mouse_Click_Portable(710, 1033)
	Sleep(1000)
	;click confirm
	Mouse_Click_Portable(810, 645)
	Sleep(1000)
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Group_Battle

Func Weapon_Refine()
	;click general
	Mouse_Click_Portable(816, 1015)
	Sleep(1000)
	;select Machao
	Mouse_Click_Portable(846, 236)
	Sleep(1000)
	;select Machao horse
	Mouse_Click_Portable(746, 685)
	Sleep(1000)
	;click refine
	Mouse_Click_Portable(1164, 931)
	Sleep(1000)
	;click coin refine
	Mouse_Click_Portable(710, 713)
	Sleep(1000)
	;refine 5 times
	For $i = 1 To 5
		Mouse_Click_Portable(1142, 901)
		Sleep(1000)
		$FA = Pixel_Search_Portable_XY(1098,378,139,106,0xCC0C0C)
		$FB = Pixel_Search_Portable_XY(1098,378,139,106,0xFD0101)
		$FC = Pixel_Search_Portable_XY(1098,378,139,106,0xEC0404)
		If IsArray($FA) Or IsArray($FB) Or IsArray($FC) Then
			;cancel if see any red
			Mouse_Click_Portable(1084, 895)
			Sleep(1000)
		Else
			;click save if not seen any red
			Mouse_Click_Portable(827, 895)
			Sleep(1000)
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Weapon_Refine

Func Altar_Spin()
	;click recruit
	Mouse_Click_Portable(914, 1024)
	Sleep(2000)
	$FA = Pixel_Search_Portable(1092,911,2,0x04EF05)
	$FB = Pixel_Search_Portable(1135,953,2,0x09C115)
	If IsArray($FA) And IsArray($FB) Then
	;click altar
	Mouse_Click_Portable(950, 879)
	Sleep(1500)
	;click spin
	Mouse_Click_Portable(858, 1038)
	Sleep(1500)
	Else

	EndIf

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Altar_Spin


Func Rob_Mission($count)
	;click rob
	Mouse_Click_Portable(749, 879)
	Sleep(1000)
	For $i = 1 To $count
		;click search
		Mouse_Click_Portable(1174, 885)
		Sleep(3000)
		Battle_Start()
		Sleep(2000)
		Rob_End()
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Rob_5_times



Func Collect_Gate_Rewards()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	;drag up 3 boxes
	Mouse_Drag_Portable(953, 183, 953, 943)
	Sleep(1000)
	;click gates page
	Mouse_Click_Portable(977, 634)
	Sleep(1000)
	;click rewards
	Mouse_Click_Portable(1156, 934)
	Sleep(1000)
	For $i = 1 To 60
		Mouse_Click_Portable(1180, 261)
		Sleep(500)
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Collect_Gate_Rewards


Func Combine_Equipment()

;click equipment
Mouse_Click_Portable(882, 416)
Sleep(1500)
;click fragment
Mouse_Click_Portable(1088, 209)
Sleep(1000)
;click obtain
Mouse_Click_Portable(1154, 420)
Sleep(5000)
$FA = Pixel_Search_Portable(840,798,2,0x0FC40F)
$FB = Pixel_Search_Portable(1045,802,2,0x11BE11)
If IsArray($FA) And IsArray($FB) Then
	;click return
	Mouse_Click_Portable(1060, 813)
	Sleep(1000)
EndIf
BACK_TO_MAIN_SCREEN()

EndFunc

Func Combine_General()

;click general
Mouse_Click_Portable(915, 615)
Sleep(1500)
;click fragment
Mouse_Click_Portable(962,211)
Sleep(1000)
;click obtain
Mouse_Click_Portable(1154, 420)
Sleep(5000)
$FA = Pixel_Search_Portable(840,798,2,0x0FC40F)
$FB = Pixel_Search_Portable(1045,802,2,0x11BE11)
If IsArray($FA) And IsArray($FB) Then
	;click return
	Mouse_Click_Portable(1060, 813)
	Sleep(1000)
EndIf
BACK_TO_MAIN_SCREEN()

EndFunc

Func Break_Weapon()

;click equipment
Mouse_Click_Portable(882, 416)
Sleep(1500)
;click breakdown
Mouse_Click_Portable(961, 1038)
Sleep(1500)
For $i = 1 to 20
;add equipment
Mouse_Click_Portable(1128, 933)
Sleep(1500)
;click breakdown
Mouse_Click_Portable(964, 1039)
Sleep(1500)
$FA = Pixel_Search_Portable(935,870,2,0x0AB10A)
$FB = Pixel_Search_Portable(986,865,2,0x029E0A)
If IsArray($FA) And IsArray($FB) Then
	Mouse_Click_Portable(959, 881)
	Sleep(1000)
EndIf
Next
BACK_TO_MAIN_SCREEN()

EndFunc   ;==>Break_Weapon

Func Break_Soul()

;click equipment
Mouse_Click_Portable(882, 416)
Sleep(1500)
;click breakdown
Mouse_Click_Portable(961, 1038)
Sleep(1500)
For $i = 1 to 10
;add equipment
Mouse_Click_Portable(791, 933)
Sleep(1500)
;click breakdown
Mouse_Click_Portable(964, 1039)
Sleep(1500)
$FA = Pixel_Search_Portable(807,628,2,0x0FBA0F)
$FB = Pixel_Search_Portable(1114,632,2,0xAC0D0D)
If IsArray($FA) And IsArray($FB) Then
	Mouse_Click_Portable(818, 642)
	Sleep(1000)
EndIf
$FA = Pixel_Search_Portable(935,870,2,0x0AB10A)
$FB = Pixel_Search_Portable(986,865,2,0x029E0A)
If IsArray($FA) And IsArray($FB) Then
	Mouse_Click_Portable(959, 881)
	Sleep(1000)
EndIf
Next
BACK_TO_MAIN_SCREEN()

EndFunc   ;==>Break_Soul

Func Free_Recruit()
	;click recruit
	Mouse_Click_Portable(908, 1021)
	Sleep(1000)

	$FA = Pixel_Search_Portable(1096,722,2,0x03EF0B)
	If IsArray($FA) Then
		Mouse_Click_Portable(953, 696)
		Sleep(1000)
		Mouse_Click_Portable(849, 579)
		Sleep(20000)
	EndIf
	BACK_TO_MAIN_SCREEN()

	;click recruit
	Mouse_Click_Portable(908, 1021)
	Sleep(1000)
	$FA = Pixel_Search_Portable(1092,531,2,0x02EC05)
	If IsArray($FA) Then
		Mouse_Click_Portable(933, 506)
		Sleep(20000)
	EndIf
	BACK_TO_MAIN_SCREEN()

EndFunc   ;==>Free_Recruit

Func Recruit_5_times()
	;click recruit
	Mouse_Click_Portable(908, 1021)
	Sleep(1000)

	Local $total_recruit = 5
	$FA = Pixel_Search_Portable(1096,722,2,0x03EF0B)
	If IsArray($FA) Then
		Mouse_Click_Portable(953, 696)
		Sleep(1000)
		Mouse_Click_Portable(849, 579)
		Sleep(20000)
		$total_recruit = $total_recruit - 1
	EndIf
	BACK_TO_MAIN_SCREEN()

	;click recruit
	Mouse_Click_Portable(908, 1021)
	Sleep(1000)
	$FA = Pixel_Search_Portable(1092,531,2,0x02EC05)
	If IsArray($FA) Then
		Mouse_Click_Portable(933, 506)
		Sleep(20000)
		$total_recruit = $total_recruit - 1
	EndIf
	BACK_TO_MAIN_SCREEN()

	;click recruit
	For $i = 1 To $total_recruit
		Mouse_Click_Portable(908, 1021)
		Sleep(1000)
		Mouse_Click_Portable(946, 309)
		Sleep(20000)
		BACK_TO_MAIN_SCREEN()
	Next

EndFunc   ;==>Recruit_5_times

Func Spirit_Search()
	;click upgrade
	Mouse_Click_Portable(723, 1018)
	Sleep(1000)
	;soul search
	Mouse_Click_Portable(1151, 316)
	Sleep(1000)
	;coin search
	Mouse_Click_Portable(766, 941)
	Sleep(1000)
	;1 time
	Mouse_Click_Portable(767, 514)
	Sleep(5000)
	For $i = 1 To 100
		Mouse_Click_Portable(957, 1031)
		Sleep(1500)
		$FA = Pixel_Search_Portable(1193,174,2,0x7E5D2B)
		$FB = Pixel_Search_Portable(1157,159,2,0x504027)
		If IsArray($FA) And IsArray($FB) Then
		Else
			$i = 100
		EndIf
	Next
	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)
	;batch operation
	Mouse_Click_Portable(1123, 256)
	Sleep(1000)
	;1-3
	Mouse_Click_Portable(1104, 934)
	Sleep(1000)
	;4
	Mouse_Click_Portable(902, 937)
	Sleep(1000)
	;break down
	Mouse_Click_Portable(1048, 1042)
	Sleep(5000)
	;5
	Mouse_Click_Portable(696, 933)
	Sleep(1000)
	;save to inventory
	Mouse_Click_Portable(879, 1034)
	Sleep(1000)
	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)
	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Spirit_Search

Func Spirit_Search_Gold()
	;click upgrade
	Mouse_Click_Portable(723, 1018)
	Sleep(1000)
	;soul search
	Mouse_Click_Portable(1151, 316)
	Sleep(1000)
	$FA = Pixel_Search_Portable(1048,926,2,0xCB0615)
	$FB = Pixel_Search_Portable(1069,959,2,0xBF0917)
	If IsArray($FA) And IsArray($FB) Then
	;Gold search
	Mouse_Click_Portable(1153, 941)
	Sleep(1000)
	;1 time
	Mouse_Click_Portable(862, 569)
	Sleep(5000)

	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)
	;batch operation
	Mouse_Click_Portable(1123, 256)
	Sleep(1000)
	;1-3
	Mouse_Click_Portable(1104, 934)
	Sleep(1000)
	;4
	Mouse_Click_Portable(902, 937)
	Sleep(1000)
	;break down
	Mouse_Click_Portable(1048, 1042)
	Sleep(5000)
	;5
	Mouse_Click_Portable(696, 933)
	Sleep(1000)
	;save to inventory
	Mouse_Click_Portable(879, 1034)
	Sleep(1000)
	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)
	EndIf
	;click back
	Mouse_Click_Portable(701, 1047)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Spirit_Search



Func Breakdown_Equip()
	For $i = 1 To 20
		Mouse_Click_Portable(1130, 930)
		Sleep(500)
		Mouse_Click_Portable(967, 1035)
		Sleep(1000)
		Mouse_Click_Portable(966, 880)
		Sleep(1000)
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Breakdown_Equip



Func Onslaught_Mission()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	;onslaught mode
	Mouse_Click_Portable(984, 511)
	Sleep(1000)
	Save_Screen()
	;3 star sweep
	For $i = 1 To 20
		If Check_Screen() > 10 Then
		;3 stars sweep
		Mouse_Click_Portable(1148, 721)
		Sleep(1000)
		;check if last stage
		$FA = Pixel_Search_Portable(940,632,1,0x0BB80B)
		$FB = Pixel_Search_Portable(955,673,1,0x13D510)
		If IsArray($FA) And IsArray($FB) Then
			;not last stage
		Else
			;last stage
			Redeem_Stars()
			;;click reset
			Mouse_Click_Portable(950, 1044)
			Sleep(1000)
			;if gold reset now
			$FA = Pixel_Search_Portable(803,628,2,0x10C410)
			$FB = Pixel_Search_Portable(837,632,2,0x0EAD0E)
			$FC = Pixel_Search_Portable(1086,634,2,0xB31616)
			$FD = Pixel_Search_Portable(1087,635,2,0xB61913)
			If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
				;gold reset now, cancel
				;MsgBox($MB_SYSTEMMODAL, "Found!", "gold reset!")
				Mouse_Click_Portable(1102, 644)
				Sleep(1000)
				BACK_TO_MAIN_SCREEN()
				Return
			Else
				;ok to reset
				;MsgBox($MB_SYSTEMMODAL, "Found!", "free reset!")
				Mouse_Click_Portable(956, 639)
				Sleep(1000)
				;3 stars sweep
				Mouse_Click_Portable(1148, 721)
				Sleep(1000)
			EndIf
		EndIf
		;sweep
		Mouse_Click_Portable(956, 638)
		Sleep(3000)
		;triumph
		Mouse_Click_Portable(956, 885)
		Sleep(1500)
		$FA = Pixel_Search_Portable(830,814,1,0x08AB08)
		$FB = Pixel_Search_Portable(835,818,1,0x10A510)
		$FC = Pixel_Search_Portable(1084,814,1,0x129612)
		$FD = Pixel_Search_Portable(1067,816,1,0x11BF11)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
			;gates mission
			;MsgBox($MB_SYSTEMMODAL, "Found!", "gate!")
			If 1 Then
				Mouse_Click_Portable(1080, 819)
				Sleep(3000)
				Enemy_Gates()
			Else
				Mouse_Click_Portable(813, 819)
				Sleep(1000)
			EndIf
		Else
			;MsgBox($MB_SYSTEMMODAL, "Found!", "no gate!")
		EndIf
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Onslaught_Mission

Func Enemy_Gates()
	;check front page
	$FA = Pixel_Search_Portable(905,901,5,0x4C1717)
	$FB = Pixel_Search_Portable(765,921,5,0xD7B65B)
	$FC = Pixel_Search_Portable(705,229,5,0xC82A22)
	$FD = Pixel_Search_Portable(1225,905,5,0x120A0A)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then

	EndIf
	;click enemy
	Mouse_Click_Portable(740, 537)
	Sleep(2000)
	;x2 hit
	Mouse_Click_Portable(1078, 843)
	Sleep(1000)

	If Enemy_Gates_Battle() == 1 Then
		;click enemy
		Mouse_Click_Portable(740, 537)
		Sleep(2000)
		;x1 hit
		Mouse_Click_Portable(836, 843)
		Sleep(1000)
		Enemy_Gates_Battle()
	EndIf

	;back to onslaught mode
	Mouse_Click_Portable(927, 1034)
	Sleep(3000)
EndFunc   ;==>Enemy_Gates

Func Enemy_Gates_Battle()
	;return 1, mean need to hit again
	;return 0, mean no need to hit again

	Local $battle = 0
	;check if entered battle
	Sleep(5000)
	;check front page
	$FA = Pixel_Search_Portable(905,901,5,0x4C1717)
	$FB = Pixel_Search_Portable(765,921,5,0xD7B65B)
	$FC = Pixel_Search_Portable(705,229,5,0xC82A22)
	$FD = Pixel_Search_Portable(1225,905,5,0x120A0A)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		;front page
		$battle = 0
	Else
		;battle page
		$battle = 1
	EndIf

	If $battle == 1 Then
		Sleep(5000)
		;entered battle, press skip
		Mouse_Click_Portable(1210, 1045)
		Sleep(5000)
		;click confirm after battle
		Mouse_Click_Portable(951, 816)
		Sleep(3000)
		;check if not killed
		$FA = Pixel_Search_Portable(805,635,5,0x12B712)
		$FB = Pixel_Search_Portable(1115,635,5,0xAF1212)
		If IsArray($FA) And IsArray($FB) Then
			;click ok
			Mouse_Click_Portable(813, 646)
			Sleep(1000)
			;MsgBox($MB_SYSTEMMODAL, "Found!", "enemy not death!")
			Return 1
		Else
			;MsgBox($MB_SYSTEMMODAL, "Found!", "no enemy!")
			Return 0
		EndIf
	Else
		Return 0
	EndIf

EndFunc   ;==>Enemy_Gates_Battle

Func War_Battle($sweep)
	Local $sweep_count = 0
	Local $scroll = 30
	;click war
	Mouse_Click_Portable(1158, 875)
	Sleep(1000)

	Do
		;enter chapter
		Mouse_Click_Portable(949, 462)
		Sleep(1000)
		;search pixel for stars
		$FA = Pixel_Search_Portable_XY(1118,299,75,65,0xFEF281)
		If IsArray($FA) Then
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(2000)
		EndIf
		;search pixel for battle screen
		$FA = Pixel_Search_Portable(1028,666,2,0x01BC31)
		$FB = Pixel_Search_Portable(1046,808,2,0x00AD29)
		$FC = Pixel_Search_Portable(1054,946,2,0x01B529)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			$sweep_count = $sweep_count + 1
			Mouse_Click_Portable(1040, 963)
			Sleep(2000)
			;if token finish, will appear use token screen
			$FD = Pixel_Search_Portable(824,698,2,0x01BD31)
			$FE = Pixel_Search_Portable(1104,706,2,0x03BA2C)
			If IsArray($FD) And IsArray($FE) Then
				;token finish
				Mouse_Click_Portable(1186, 425)
				Sleep(2000)
				;last scroll
				$scroll = 1
			Else
				Mouse_Click_Portable(958, 884)
				Sleep(15000) ;need to wait longer for general screen disappear
				;lower than vip 6 account, secret merchant will appear
				Mouse_Click_Portable(908, 246)
				Sleep(2000)
			EndIf
		EndIf
		;click X
		Mouse_Click_Portable(1217, 207)
		Sleep(2000)
		;return
		Mouse_Click_Portable(704, 1040)
		Sleep(2000)
		;scroll next chapter
		Mouse_Drag_Portable(957, 538, 957, 443)
		Sleep(1000)
		$scroll = $scroll - 1
	Until $scroll == 0 Or $sweep_count == $sweep

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>War_Battle


Func Elite_Mode($mode)
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;click elite mode
	Mouse_Click_Portable(962, 281)
	Sleep(1000)
	;click hard
	Mouse_Click_Portable($mode, 189)
	Sleep(1000)
	;;sweep from bottom
	;drag to bottom
	For $i = 1 To 10
		Mouse_Drag_Portable(938, 882, 938, 474)
		Sleep(500)
	Next
	For $i = 1 To 30
		;check if can be sweep
		$FA = Pixel_Search_Portable_XY(1033,891,55,68,0x01AD28)
		If IsArray($FA) Then
			;sweep
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(2000)
			;check for triumph button
			$FA = Pixel_Search_Portable(959,874,2,0x129612)
			If IsArray($FA) Then
				Mouse_Click_Portable(957, 886)
				Sleep(1000)
			EndIf
		EndIf
		Mouse_Drag_Portable(937, 790, 937, 975)
		Sleep(1000)
	Next
	;;sweep from top
	For $i = 1 To 4
		;check if can be sweep
		$FA = Pixel_Search_Portable_XY(1033,383+($i-1)*160,55,79,0x01AD28)
		If IsArray($FA) Then
			;sweep
			Mouse_Click_Portable($FA[0], $FA[1])
			Sleep(2000)
			;check for triumph button
			$FA = Pixel_Search_Portable(959,874,2,0x129612)
			If IsArray($FA) Then
				Mouse_Click_Portable(957, 886)
				Sleep(1000)
			EndIf
		EndIf
	Next
	;elite mode need to have more time as the "general combine" screen will appear
	Sleep(20000)
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Elite_Mode

Func Tomb_Raid()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(1000)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(1000)
	;click tomb raid
	Mouse_Click_Portable(963, 267)
	Sleep(1000)
	;click 4 directions
	Mouse_Click_Portable(870, 472)
	Sleep(1000)
	Check_Tomb_Raid()
	Mouse_Click_Portable(870, 659)
	Sleep(1000)
	Check_Tomb_Raid()
	Mouse_Click_Portable(1054, 659)
	Sleep(1000)
	Check_Tomb_Raid()
	Mouse_Click_Portable(1054, 472)
	Sleep(1000)
	Check_Tomb_Raid()

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Tomb_Raid

Func Check_Tomb_Raid()
	For $i = 1 To 3
		$FA = Pixel_Search_Portable(716,392,2,0x000000)
		$FB = Pixel_Search_Portable(752,684,2,0x000000)
		$FC = Pixel_Search_Portable(1164,372,2,0x000000)
		$FD = Pixel_Search_Portable(1180,792,2,0x000000)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
			;still in dark
		Else
			Mouse_Click_Portable(1140, 335)
			Sleep(1000)
			;entered battle
			Battle_Start()
			Battle_End()
		EndIf
		Sleep(1000)
	Next
EndFunc   ;==>Check_Tomb_Raid

Func Friend_Blessing()
	;click social
	Mouse_Click_Portable(1012, 1016)
	Sleep(1000)
	;click friends
	Mouse_Click_Portable(770, 301)
	Sleep(1000)
	;click list
	Mouse_Click_Portable(739, 213)
	Sleep(1000)
	;one tab bless
	Mouse_Click_Portable(1051, 1048)
	Sleep(1000)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Friend_Blessing

Func Collect_Rewards()
	Sleep(1000)
	;click reward
	Mouse_Click_Portable(1188, 230)
	Sleep(3000)
	;click daily
	Mouse_Click_Portable(943, 197)
	Sleep(3000)
	Local $i = 0
	Do
		$FA = Pixel_Search_Portable(1166,374,1,0x01AD28)
		$FB = Pixel_Search_Portable(1151,377,1,0X00A425)
		$FC = Pixel_Search_Portable(1174,411,1,0X1AAB1A)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			Mouse_Click_Portable(1174, 388)
			Sleep(2000)
		Else
			$i = 1
		EndIf
	Until $i = 1

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Collect_Rewards

Func Redeem_Stars()
	;redeem star
	Mouse_Click_Portable(1156, 933)
	Sleep(1000)
	;;g3 gem pack redeem
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	Mouse_Click_Portable(1156, 933)
	Sleep(1000)
	For $i = 1 To 35
		Mouse_Click_Portable(955, 883)
		Sleep(300)
	Next
	Mouse_Click_Portable(971, 185)
	Sleep(1000)
	;g3 gem pack redeem end

	;;g1 gem pack redeem
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	Mouse_Click_Portable(1156, 653)
	Sleep(1000)
	For $i = 1 To 10
		Mouse_Click_Portable(955, 883)
		Sleep(300)
	Next
	Mouse_Click_Portable(971, 185)
	Sleep(1000)
	;g2 gem pack redeem end

	;click back
	Mouse_Click_Portable(707, 1039)
	Sleep(1000)
EndFunc   ;==>Redeem_Stars

Func Collect_Weekly_Rewards()
	If @WDAY == 1 Then

	BACK_TO_MAIN_SCREEN()
	EndIf
EndFunc   ;==>Collect_Weekly_Rewards

Func Collect_Daily_Pack()
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 50
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		$FA = Pixel_Search_Portable(712,410,2,0xFDFB90)
		$FB = Pixel_Search_Portable(796,426,2,0xFFC833)
		$FC = Pixel_Search_Portable(1070,464,2,0xFFFFB7)
		$FD = Pixel_Search_Portable(1174,426,2,0xFDE5D4)
		$FE = Pixel_Search_Portable(820,692,2,0xFFFFFF)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(1182, 694)
			Sleep(1000)
			$i = 50
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 838, 235)
			Sleep(1000)
		EndIf
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Collect_Daily_Pack


Func Collect_Token()
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 30
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		$FA = Pixel_Search_Portable(974,748,2,0xFAE19F)
		$FB = Pixel_Search_Portable(924,610,2,0xC49258)
		$FC = Pixel_Search_Portable(1180,650,2,0xFFFFFF)
		$FD = Pixel_Search_Portable(1194,512,2,0x5E1F1F)
		$FE = Pixel_Search_Portable(968,404,2,0x070707)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(959, 1036)
			Sleep(1000)
			BACK_TO_MAIN_SCREEN()
			Return
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 850, 235)
			Sleep(1000)
		EndIf
	Next

	For $i = 1 To 30
		;click last logo
		Mouse_Click_Portable(1143, 242)
		Sleep(1000)
		$FA = Pixel_Search_Portable(974,748,2,0xFAE19F)
		$FB = Pixel_Search_Portable(924,610,2,0xC49258)
		$FC = Pixel_Search_Portable(1180,650,2,0xFFFFFF)
		$FD = Pixel_Search_Portable(1194,512,2,0x5E1F1F)
		$FE = Pixel_Search_Portable(968,404,2,0x070707)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(959, 1036)
			Sleep(1000)
			BACK_TO_MAIN_SCREEN()
			Return
		Else
			;not found
			Mouse_Drag_Portable(973, 236, 1101, 236)
			Sleep(1000)
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Collect_Token


Func Extra_Return()
	;collect token at 12pm and 6pm
	;If @HOUR == 12 Or @HOUR == 18 Then
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 30
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		$FA = Pixel_Search_Portable(810,514,2,0xB58429)
		$FB = Pixel_Search_Portable(1010,610,2,0x31190F)
		$FC = Pixel_Search_Portable(1218,454,2,0xB697B2)
		$FD = Pixel_Search_Portable(1156,522,2,0xAB711F)
		$FE = Pixel_Search_Portable(1102,388,2,0xE0E0E0)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(959, 1036)
			Sleep(1000)
			;Mouse_Click_Portable(959, 1036)
			;Sleep(1000)
			Mouse_Click_Portable(957, 850)
			Sleep(1000)
			Mouse_Click_Portable(1198, 176)
			Sleep(1000)
			BACK_TO_MAIN_SCREEN()
			Return
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 850, 235)
			Sleep(1000)
		EndIf
	Next

	For $i = 1 To 30
		;click last logo
		Mouse_Click_Portable(1143, 242)
		Sleep(1000)
		$FA = Pixel_Search_Portable(810,514,2,0xB58429)
		$FB = Pixel_Search_Portable(1010,610,2,0x31190F)
		$FC = Pixel_Search_Portable(1218,454,2,0xB697B2)
		$FD = Pixel_Search_Portable(1156,522,2,0xAB711F)
		$FE = Pixel_Search_Portable(1102,388,2,0xE0E0E0)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(959, 1036)
			Sleep(1000)
			Mouse_Click_Portable(959, 1036)
			Sleep(1000)
			Mouse_Click_Portable(957, 850)
			Sleep(1000)
			Mouse_Click_Portable(1198, 176)
			Sleep(1000)
			BACK_TO_MAIN_SCREEN()
			Return
		Else
			;not found
			Mouse_Drag_Portable(973, 236, 1101, 236)
			Sleep(1000)
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()
	;EndIf ;If @HOUR == 12 Or @HOUR == 18 Then
EndFunc   ;==>Extra_Return


Func Collect_Weekly_Login()
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 30
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		$FA = Pixel_Search_Portable(712,410,2,0xFDFB90)
		$FB = Pixel_Search_Portable(796,426,2,0xFFC833)
		$FC = Pixel_Search_Portable(1070,464,2,0xFFFFB7)
		$FD = Pixel_Search_Portable(1174,426,2,0xFDE5D4)
		$FE = Pixel_Search_Portable(820,692,2,0xFFFFFF)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Mouse_Click_Portable(1182, 694)
			Sleep(1000)
			$i = 30
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 838, 235)
			Sleep(1000)
		EndIf
	Next
	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Collect_Weekly_Login


Func Collect_Monthly()
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	;drag to left most
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 30
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		$FA = Pixel_Search_Portable(735,961,5,0x162F40)
		$FB = Pixel_Search_Portable(1207,925,5,0x252525)
		$FC = Pixel_Search_Portable(997,863,5,0x141817)
		$FD = Pixel_Search_Portable(746,944,2,0x173041)
		$FE = Pixel_Search_Portable(914,952,2,0x254E5E)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
			;found
			Local $date = @MDAY
			If $date > 16 Then
				;drag to down
				Mouse_Drag_Portable(977, 708, 977, 421)
				Sleep(1000)
				Mouse_Drag_Portable(977, 708, 977, 421)
				Sleep(1000)
				$start_x = 752
				;If @MON == 02 Then
				;$start_y = 534
				;Else
				$start_y = 415
				;EndIf
				$offset_day = 16
			Else
				;drag to above
				Mouse_Drag_Portable(977, 421, 977, 708)
				Sleep(1000)
				Mouse_Drag_Portable(977, 421, 977, 708)
				Sleep(1000)
				$start_x = 752
				$start_y = 358
				$offset_day = 0
			EndIf

			$offset_x = Mod($date - $offset_day - 1, 4)
			$offset_y = Floor(($date - $offset_day - 1) / 4)

			$start_y = $start_y + $offset_y * 120
			$start_x = $start_x + $offset_x * 140
			;click day
			Mouse_Click_Portable($start_x, $start_y)
			Sleep(1000)
			$i = 30
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 850, 235)
			Sleep(1000)
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()

EndFunc   ;==>Collect_Monthly

Func Alliance_Dungeon_Rewards()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;drag to bottom
	For $i = 1 to 4
	Mouse_Drag_Portable(938, 882, 938, 474)
	Sleep(1000)
	Next
	;;alliance dungeon
	Mouse_Click_Portable(954, 571)
	Sleep(2000)
	;drag to bottom
	For $i = 1 to 10
	Mouse_Drag_Portable(938, 882, 938, 300)
	Sleep(1000)
	Next
	;collect rewards from bottom
	For $i = 1 to 50
	;check for rewards box
	$FA = Pixel_Search_Portable(1178,889,80,0xE0605C)
	If IsArray($FA) Then
		Mouse_Click_Portable($FA[0], $FA[1])
		Sleep(1000)
		$FA = Pixel_Search_Portable(804,653,5,0x1C1C13)
		$FB = Pixel_Search_Portable(1165,636,5,0x12120A)
		;check if the rewards page opened
		If IsArray($FA) And IsArray($FB) Then
			$FA = Pixel_Search_Portable(945,705,3,0x0DC20D)
			$FB = Pixel_Search_Portable(998,714,3,0x159115)
			;check if green button appears
			If IsArray($FA) And IsArray($FB) Then
				Mouse_Click_Portable(956, 720)
				Sleep(1000)
			Else
				Mouse_Click_Portable(1210, 434)
				Sleep(1000)
			EndIf
		EndIf
	EndIf
	Mouse_Drag_Portable(959, 804, 959, 940)
	Sleep(1000)
	Next
	;collect rewards from top
	Local $reward_y[4] = [286, 480, 669, 856]
	For $i = 0 to 3
		Mouse_Click_Portable(1182, $reward_y[$i])
		Sleep(1000)
		$FA = Pixel_Search_Portable(804,653,5,0x1C1C13)
		$FB = Pixel_Search_Portable(1165,636,5,0x12120A)
		;check if the rewards page opened
		If IsArray($FA) And IsArray($FB) Then
			$FA = Pixel_Search_Portable(945,705,3,0x0DC20D)
			$FB = Pixel_Search_Portable(998,714,3,0x159115)
			;check if green button appears
			If IsArray($FA) And IsArray($FB) Then
				Mouse_Click_Portable(956, 720)
				Sleep(1000)
			Else
				Mouse_Click_Portable(1210, 434)
				Sleep(1000)
			EndIf
		EndIf
	Next

	BACK_TO_MAIN_SCREEN()
EndFunc


Func Mission_Rewards()
	;daily
	Mouse_Click_Portable(1184, 327)
	Sleep(1000)

	;;arena rewards
	;$FA = PixelSearch(742, 498, 750, 506, 0x552020, 10)
	;$FB = PixelSearch(771, 523, 779, 531, 0x3A1512, 10)
	$FA = Pixel_Search_Portable(746,502,4,0x552020)
	$FB = Pixel_Search_Portable(775,527,4,0x3A1512)
	If IsArray($FA) And IsArray($FB) Then
		Mouse_Click_Portable(763, 513)
		Sleep(1000)
		Mouse_Click_Portable(951, 719)
		Sleep(1000)
	EndIf

	;;enemy at the gates
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	;drag one page
	Mouse_Drag_Portable(965, 940, 956, 210)
	Sleep(500)
	;;arena rewards
	;$FA = PixelSearch(743, 714, 751, 722, 0x592020, 10)
	;$FB = PixelSearch(771, 707, 779, 715, 0xA2795D, 10)
	$FA = Pixel_Search_Portable(747,718,4,0x592020)
	$FB = Pixel_Search_Portable(775,711,4,0xA2795D)
	If IsArray($FA) And IsArray($FB) Then
		Mouse_Click_Portable(769, 724)
		Sleep(1000)
	EndIf
	BACK_TO_MAIN_SCREEN()

	;;alliance worship
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;temple worship
	Mouse_Click_Portable(959, 610)
	Sleep(1000)
	Mouse_Click_Portable(960, 1002)
	Sleep(1000)
	Mouse_Click_Portable(823, 645)
	Sleep(1000)
	Mouse_Click_Portable(969, 728)
	Sleep(1000)
	BACK_TO_MAIN_SCREEN()

EndFunc   ;==>Mission_Rewards


Func Weekly_Task()
Combine_Equipment()
Combine_General()
Break_Weapon()
Break_Soul()
EndFunc   ;==>Weekly_Task


Func Scheduled_Task()

Clear_Token()

Free_Recruit()

EndFunc   ;==>Scheduled_Task

Func Clear_Token()
	;If $status == 0 Then Rob_5_times()
	;If $status == 0 Then Rob_5_times()

	;get free token first
	If $status == 0 Then Collect_Token()
	;normal mode
	If $status == 0 Then Elite_Mode(817)
	;war
	If $status == 0 Then War_Battle(8)
	;flags
	If $status == 0 Then Flags()
	;spirit
	If $status == 0 Then Spirit_Search()
EndFunc   ;==>Clear_Token


Func Clan_War_Cross()
	Local $x_war = 0
	Local $y_war = 0

	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;cross server battle
	Mouse_Click_Portable(963, 644)
	Sleep(5000)

	;boost power for all
	Mouse_Click_Portable(1157, 571)
	Sleep(1500)
	Mouse_Click_Portable(1086, 895)
	Sleep(1500)
	Mouse_Click_Portable(1237, 210)
	Sleep(2500)

	Clan_War_City_Enter()
	;Save_Screen()

	While (1)
		Clan_War_Attack()
	WEnd
EndFunc   ;==>Clan_War_Cross


Func Clan_War_Cross_Boost()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;todo check for alliance page
	If Alliance_Page() <> 1 Then
		BACK_TO_MAIN_SCREEN()
		Return
	EndIf
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;cross server battle
	Mouse_Click_Portable(963, 644)
	Sleep(5000)

	;boost power for all
	Mouse_Click_Portable(1155, 333)
	Sleep(1500)
	Mouse_Click_Portable(1092, 895)
	Sleep(1500)
	Mouse_Click_Portable(1235, 211)
	Sleep(2500)

	BACK_TO_MAIN_SCREEN()
EndFunc   ;==>Clan_War_Cross


Func Clan_War_Internal()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;;war page
	Mouse_Click_Portable(972, 837)
	Sleep(3000)

	If Clan_War_Internal_Map() == 1 Then
		Clan_War_City_Enter()
		Sleep(5000)
		Clan_War_Attack() ; infinite loop, return if failed
		$status = 1
		Return
	Else
		$status = 1
		Return
	EndIf
EndFunc   ;==>Clan_War_Internal


Func Clan_War_Internal_Random()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;;war page
	Mouse_Click_Portable(972, 837)
	Sleep(3000)

	If Clan_War_Internal_Map() == 1 Then
		$clan_war_city = 1
		While(1)
			Clan_War_City_Enter()
			Sleep(5000)
			For $i = 1 To 30
				Clan_War_Attack_Tower()
			Next
			Clan_War_Exit_City()
			$clan_war_city = $clan_war_city + 1
			If $clan_war_city == 11 Then $clan_war_city = 1
		WEnd
	Else
		$status = 1
		Return
	EndIf
EndFunc



Func Clan_War_City_Enter()
	Local $x_war = 0
	Local $y_war = 0
	Local $drag_first = 0
	Local $drag_last = 0

	If $clan_war_city == 0 Then
		Clan_War_City_Read()
	EndIf

	Switch $clan_war_city
		Case 1 ;changan
			$x_war = 1062
			$y_war = 413
			$drag_first = 730
			$drag_last = 1200
		Case 2 ;jianye
			$x_war = 986
			$y_war = 509
			$drag_first = 1200
			$drag_last = 730
		case 3 ;chengdu
			$x_war = 761
			$y_war = 583
			$drag_first = 730
			$drag_last = 1200
		case 4 ;hanzhong
			$x_war = 888
			$y_war = 484
			$drag_first = 730
			$drag_last = 1200
		Case Else ;default go jianye
			$x_war = 986
			$y_war = 509
			$drag_first = 1200
			$drag_last = 730
	EndSwitch

	For $i = 1 To 3
		Mouse_Drag_Portable($drag_first, 359, $drag_last, 359)
		Sleep(500)
	Next
	;click city
	Mouse_Click_Portable($x_war, $y_war)
	Sleep(1000)
	;enter city
	Mouse_Click_Portable(961, 800)
	Sleep(1000)

EndFunc   ;==>Clan_War_City_Enter

Func Clan_War_Attack()
	Local $error = 10

	Save_Screen()
	While($error)
		Clan_War_Attack_Tower()
		If Check_Screen() < 10 Then
			$error = $error - 1
		Else
			$error = 10
		EndIf
	WEnd
	Return
EndFunc   ;==>Clan_War_Attack


Func Clan_War_Attack_Tower()
	;towers
	Mouse_Click_Portable(1093, 397)
	Sleep(500)
	Mouse_Click_Portable(800, 643)
	Sleep(500)
	Mouse_Click_Portable(1120, 830)
	Sleep(500)
	;ok
	Mouse_Click_Portable(951, 874)
	Sleep(1000)
EndFunc


Func Clan_War_Exit_City()
	;click back
	Mouse_Click_Portable(726, 1011)
	Sleep(1000)
	;$FA = PixelSearch(838, 624, 848, 634, 0x029508, 10)
	;$FB = PixelSearch(1084, 626, 1094, 636, 0xA51010, 10)
	$FA = Pixel_Search_Portable(843,629,5,0x029508)
	$FB = Pixel_Search_Portable(1089,631,5,0xA51010)
	If IsArray($FA) And IsArray($FB) Then
		;click ok
		Mouse_Click_Portable(841, 628)
		Sleep(1000)
	EndIf
EndFunc   ;==>Clan_War_Exit_City


Func Clan_War_Internal_Map()
	For $i = 1 To 3
		Mouse_Drag_Portable(800, 359, 1200, 359)
		Sleep(500)
	Next

	$FA = Pixel_Search_Portable(745, 283, 3, 0xD0953B)
	$FB = Pixel_Search_Portable(1186, 607, 3, 0xA0A539)
	$FC = Pixel_Search_Portable(982, 948, 3, 0x5EB190)
	$FD = Pixel_Search_Portable(730, 685, 3, 0x495132)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>Clan_War_Internal_Map

Func Clan_War_Cross_Map()
	For $i = 1 To 4
		Mouse_Drag_Portable(800, 359, 1200, 359)
		Sleep(500)
	Next

	$FA = Pixel_Search_Portable(911, 288, 3, 0xC3A475)
	$FB = Pixel_Search_Portable(749, 331, 3, 0xA08168)
	$FC = Pixel_Search_Portable(1187, 773, 3, 0x886F5B)
	$FD = Pixel_Search_Portable(969, 342, 3, 0xB2A18A)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>Clan_War_Cross_Map



Func Dungeon_Event_Enter()
	;click event
	Mouse_Click_Portable(1211, 541)
	Sleep(2000)
	Mouse_Drag_Portable(884, 232, 1085, 232)
	Sleep(500)
	For $i = 1 To 30
		;click first logo
		Mouse_Click_Portable(780, 234)
		Sleep(1000)
		If Activity_Dungeon_Map() == 1 Then
			;found
			Mouse_Click_Portable(957, 550)
			Sleep(2000)
			Return 1
		Else
			;not found
			Mouse_Drag_Portable(905, 230, 850, 235)
			Sleep(1000)
		EndIf
	Next

	For $i = 1 To 30
		;click last logo
		Mouse_Click_Portable(1143, 242)
		Sleep(1000)
		If Activity_Dungeon_Map() == 1 Then
			Mouse_Click_Portable(957, 550)
			Sleep(2000)
			Return 1
		Else
			;not found
			Mouse_Drag_Portable(973, 236, 1101, 236)
			Sleep(1000)
		EndIf
	Next

	Return 0

EndFunc


Func Dungeon_Bot()
	Event_Dungeon_Init()
	;$current_event_dungeon_map = 1
	For $map = $current_event_dungeon_map to 2 ; 3 maps
	If Dungeon_Event_Enter() == 1 Then
		Dungeon_Event_Map_Enter($map)

		If $status == 1 Then
			Return
		Else
			$current_event_dungeon_stage = 0
			BACK_TO_MAIN_SCREEN()
		EndIf
	EndIf
	Next
EndFunc

Func Dungeon_Event_Map_Enter($map)
	Local $drag_first = 0
	Local $drag_last = 0

	;enter map
	Mouse_Click_Portable($event_dungeon_main[$map][0], $event_dungeon_main[$map][1])
	Sleep(3000)
	For $stage = $current_event_dungeon_stage to 9
		;scroll up or down
		If $stage <= 4 Then
			$drag_first = 888
			$drag_last = 474
		Else
			$drag_first = 474
			$drag_last = 888
		EndIf
		For $j = 1 To 4
		Mouse_Drag_Portable(938, $drag_first, 938, $drag_last)
		Sleep(500)
		Next ; $j 1-4

		Error_Log("Event Dungeon: " & $map & ":" & $stage)
		Dungeon_Battle($event_dungeon[$map][$stage][0], $event_dungeon[$map][$stage][1], $stage)

		If $status == 1 Then Return
	Next ; $i 0-9
EndFunc


Func Event_Dungeon_Init()
	$current_event_dungeon_map = 0
	$current_event_dungeon_stage = 0


	$event_dungeon_main[0][0]  = 956
	$event_dungeon_main[0][1]  = 624
	$event_dungeon_main[1][0]  = 956
	$event_dungeon_main[1][1]  = 453
	$event_dungeon_main[2][0]  = 956
	$event_dungeon_main[2][1]  = 283
	;first map
	$event_dungeon[0][0][0] = 801
	$event_dungeon[0][0][1] = 846
	$event_dungeon[0][1][0] = 1041
	$event_dungeon[0][1][1] = 788
	$event_dungeon[0][2][0] = 1023
	$event_dungeon[0][2][1] = 539
	$event_dungeon[0][3][0] = 745
	$event_dungeon[0][3][1] = 548
	$event_dungeon[0][4][0] = 901
	$event_dungeon[0][4][1] = 330
	$event_dungeon[0][5][0] = 1160
	$event_dungeon[0][5][1] = 734
	$event_dungeon[0][6][0] = 751
	$event_dungeon[0][6][1] = 591
	$event_dungeon[0][7][0] = 764
	$event_dungeon[0][7][1] = 370
	$event_dungeon[0][8][0] = 1166
	$event_dungeon[0][8][1] = 451
	$event_dungeon[0][9][0] = 1000
	$event_dungeon[0][9][1] = 299
	;second map
	$event_dungeon[1][0][0] = 1126
	$event_dungeon[1][0][1] = 887
	$event_dungeon[1][1][0] = 819
	$event_dungeon[1][1][1] = 807
	$event_dungeon[1][2][0] = 1197
	$event_dungeon[1][2][1] = 633
	$event_dungeon[1][3][0] = 1026
	$event_dungeon[1][3][1] = 464
	$event_dungeon[1][4][0] = 774
	$event_dungeon[1][4][1] = 421
	$event_dungeon[1][5][0] = 500
	$event_dungeon[1][5][1] = 680
	$event_dungeon[1][6][0] = 727
	$event_dungeon[1][6][1] = 438
	$event_dungeon[1][7][0] = 925
	$event_dungeon[1][7][1] = 331
	$event_dungeon[1][8][0] = 1158
	$event_dungeon[1][8][1] = 572
	$event_dungeon[1][9][0] = 1150
	$event_dungeon[1][9][1] = 301
	;third map
	$event_dungeon[2][0][0] = 801
	$event_dungeon[2][0][1] = 838
	$event_dungeon[2][1][0] = 1045
	$event_dungeon[2][1][1] = 782
	$event_dungeon[2][2][0] = 1022
	$event_dungeon[2][2][1] = 537
	$event_dungeon[2][3][0] = 749
	$event_dungeon[2][3][1] = 530
	$event_dungeon[2][4][0] = 902
	$event_dungeon[2][4][1] = 330
	$event_dungeon[2][5][0] = 1167
	$event_dungeon[2][5][1] = 728
	$event_dungeon[2][6][0] = 751
	$event_dungeon[2][6][1] = 589
	$event_dungeon[2][7][0] = 761
	$event_dungeon[2][7][1] = 368
	$event_dungeon[2][8][0] = 1167
	$event_dungeon[2][8][1] = 448
	$event_dungeon[2][9][0] = 997
	$event_dungeon[2][9][1] = 295
EndFunc


;Dungeon_Battle()
Func Dungeon_Battle($x_coord, $y_coord, $current_stage)
	;boss stage vs normal stage
	$count = $event_dungeon_normal_count
	If $current_stage == 9 or $current_stage == 2 or $current_stage == 5 or $current_stage == 7 Then
		$count = $event_dungeon_boss_count
	EndIf

	For $i = 1 to $count
		Mouse_Click_Portable($x_coord, $y_coord)
		Sleep(1000)
		If Check_Troop_Full() == 1 Then
			;click again
			Mouse_Click_Portable($x_coord, $y_coord)
			Sleep(1000)
		EndIf
		;check for battle page
		If Battle_Fight_Page() == 1 Then
			;click battle difficult
			Mouse_Click_Portable(1158, 967)
			Sleep(1000)
			If Check_Challenge_Finish() == 1 Then
				$i = $count
			Else
				If Check_Token_Finish() == 1 Then
					;click battle difficult
					Mouse_Click_Portable(1158, 967)
					Sleep(2000)
					;second check, if still not ok, mean token finish
					If Check_Token_Finish() == 1 Then
						;click X
						Mouse_Click_Portable(1217, 207)
						Sleep(2000)
						Return
					EndIf
				EndIf
				Battle_Start()
				Dungeon_Battle_End()
			EndIf
		EndIf ;Battle_Fight()
	Next
EndFunc

Func Activity_Dungeon_Map()
	$FA = Pixel_Search_Portable(1138,362,1,0xE7C7B7)
	$FB = Pixel_Search_Portable(939,538,1,0x01AD01)
	$FC = Pixel_Search_Portable(757,565,1,0x7D2312)
	$FD = Pixel_Search_Portable(1133,859,1,0x6C1A11)
	$FE = Pixel_Search_Portable(882,542,1,0x09AB09)
	$FF = Pixel_Search_Portable(934,604,1,0xA15F36)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) And IsArray($FF) Then
		Return 1
	Else
		return 0
	EndIf
EndFunc


Func Battle_Fight_Page()
	Sleep(500)
	$FA = Pixel_Search_Portable(737,688,2,0xE3E3E3)
	$FB = Pixel_Search_Portable(736,830,2,0xE5E5E5)
	$FC = Pixel_Search_Portable(735,975,2,0xDCDCDC)
	$FD = Pixel_Search_Portable(1147,947,2,0xB81601)
	$FE = Pixel_Search_Portable(1143,668,2,0xBE1902)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		Return 1
	Else
		return 0
	EndIf
EndFunc

Func Check_Troop_Full()
	$FA = Pixel_Search_Portable(800,632,2,0x0EBF0E)
	$FB = Pixel_Search_Portable(852,630,2,0x08990F)
	$FC = Pixel_Search_Portable(1081,630,2,0xBB0E0E)
	$FD = Pixel_Search_Portable(1117,631,2,0xAB0B0B)
	$FE = Pixel_Search_Portable(1188,347,2,0xDAD9CD)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		;click go
		Mouse_Click_Portable(813, 645)
		Sleep(2000)
		;click first general
		Mouse_Click_Portable(1039, 450)
		Sleep(2000)
		For $i = 1 To 20
			;auto-add
			Mouse_Click_Portable(956, 837)
			Sleep(500)
			Mouse_Click_Portable(947, 1034)
			Sleep(500)
		Next
		;click back
		Mouse_Click_Portable(716, 1038)
		Sleep(2000)
		Mouse_Click_Portable(716, 1038)
		Sleep(2000)
		Return 1
	Else
		Return 0
	EndIf
EndFunc



Func Check_Token_Finish()
	;$FA = PixelSearch(822, 696, 826, 700, 0x01BD31, 10)
	;$FB = PixelSearch(1102, 704, 1056, 708, 0x03BA2C, 10)
	$FA = Pixel_Search_Portable(824,698,2,0x01BD31)
	$FB = Pixel_Search_Portable(1076,554,2,0xEDCC79)

	$FC = Pixel_Search_Portable(1104,706,2,0x03BA2C)
	$FD = Pixel_Search_Portable(1086,698,2,0xBC1801)

	If IsArray($FA) And IsArray($FB) Then
		If IsArray($FC) Or IsArray($FD) Then
		;use token
		Mouse_Click_Portable(1084, 710)
		Sleep(1000)
		;press x
		Mouse_Click_Portable(1183, 425)
		Sleep(1000)
		Return 1
		EndIf
	EndIf

	Return 0
EndFunc


Func Check_Challenge_Finish()
	$FA = Pixel_Search_Portable(810,634,2,0x17B117)
	$FB = Pixel_Search_Portable(1116,635,2,0xB2150F)
	$FC = Pixel_Search_Portable(879,555,2,0x0F0F0F)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		;no more tips
		;Mouse_Click_Portable(881, 555)
		;Sleep(1000)
		;confirm
		;Mouse_Click_Portable(818, 647)
		;Sleep(1000)
		;press x
		Mouse_Click_Portable(1100, 647)
		Sleep(2000)
		;click X
		Mouse_Click_Portable(1217, 207)
		Sleep(2000)
		Return 1
	Else
		Return 0
	EndIf

EndFunc



Func Dungeon_Battle_End()
	;wait until battle finish
	Local $i = 0
	Local $timeout = 100
	Do
		$FA = Pixel_Search_Portable(942,868,1,0x06B706)
		$FB = Pixel_Search_Portable(953,913,1,0X0FC40E)
		$FC = Pixel_Search_Portable(947,871,1,0X15B515)
		If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
			$i = 1
		Else
			$timeout = $timeout - 1
			If $timeout > 0 Then
				$i = 0 ; continue running if not timeout
			Else
				$i = 1 ; discontinued if timeout
				$status = 1
			EndIf
			Sleep(1000)
		EndIf
	Until $i = 1
	Mouse_Click_Portable(951, 886)
	Sleep(1000)
	Mouse_Click_Portable(951, 886)
	Sleep(1000)

EndFunc   ;==>Battle_End


Func SA4_Detection()
	Local $detected = 0

;1st
	$FA = Pixel_Search_Portable(880,418,1,0x706C51)
	$FB = Pixel_Search_Portable(890,417,1,0x938F6B)
	$FC = Pixel_Search_Portable(895,416,1,0x767355)
	$FD = Pixel_Search_Portable(914,421,1,0xC9C392)
	$FE = Pixel_Search_Portable(925,418,1,0x767356)
	$FF = Pixel_Search_Portable(935,416,1,0x7C795B)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) And IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "SA4 1")
		$detected = 1
	EndIf

;2nd
	$FA = Pixel_Search_Portable(1018,510,1,0x837F5F)
	$FB = Pixel_Search_Portable(1025,507,1,0x928E6A)
	$FC = Pixel_Search_Portable(1030,507,1,0x66644A)
	$FD = Pixel_Search_Portable(1040,511,1,0x97936D)
	$FE = Pixel_Search_Portable(1060,508,1,0x8A8765)
	$FF = Pixel_Search_Portable(1071,506,1,0x777456)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) And IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "SA4 2")
		$detected = 1
	EndIf

;3rd
	$FA = Pixel_Search_Portable(880,598,1,0x716E52)
	$FB = Pixel_Search_Portable(882,573,1,0x898564)
	$FC = Pixel_Search_Portable(895,597,1,0x7B7759)
	$FD = Pixel_Search_Portable(914,600,1,0xCDC896)
	$FE = Pixel_Search_Portable(925,598,1,0x757356)
	$FF = Pixel_Search_Portable(935,597,1,0x7D7A5B)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) And IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "SA4 3")
		$detected = 1
	EndIf


;4th
	$FA = Pixel_Search_Portable(1015,689,1,0x67654B)
	$FB = Pixel_Search_Portable(1025,687,1,0xAAA57C)
	$FC = Pixel_Search_Portable(1031,687,1,0x83805F)
	$FD = Pixel_Search_Portable(1060,688,1,0x7E7B5C)
	$FE = Pixel_Search_Portable(1071,687,1,0xAAA67C)
	$FF = Pixel_Search_Portable(1071,687,1,0xAAA67C)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) And IsArray($FF) Then
		;MsgBox($MB_SYSTEMMODAL, "Terminated!", "SA4 4")
		$detected = 2
	EndIf

	Return $detected
EndFunc


Func Mining_Scan()
	;;alliance
	Mouse_Click_Portable(1005, 1013)
	Sleep(1000)
	Mouse_Click_Portable(1146, 315)
	Sleep(1000)
	;drag one page down
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	Mouse_Drag_Portable(938, 721, 938, 309)
	Sleep(1000)
	;click mine page
	Mouse_Click_Portable(955, 815)
	Sleep(2000)
	While(Mining_Page() == 1)
		For $i = 1 to 15
			$mining_enemy[$i] = 0
		Next
		;go to first page
		Mouse_Click_Portable(1057, 839)
		Sleep(1500)
		Mouse_Click_Portable(953, 729)
		Sleep(1500)
		For $page = 1 to 15
			If SA4_Detection() <> 0 Then
				$mining_enemy[$page] = 1
			EndIf
			;click next, last page skip
			If $page <> 15 Then
				$FA = Pixel_Search_Portable(1208,585,2,0xD1C6B5)
				$FB = Pixel_Search_Portable(1196,596,2,0xEEDECD)
				If IsArray($FA) And IsArray($FB) Then
					Mouse_Click_Portable(1203, 593)
					Sleep(1500)
				EndIf
			EndIf
		Next
		Mining_Report()
		Mining_Broadcast()
		For $time = 1 to 10
			Sleep(30000)
		Next
	WEnd
	$status = 1
EndFunc

Func Mining_Page()
	$FA = Pixel_Search_Portable(693,554,2,0x5D8636)
	$FB = Pixel_Search_Portable(1041,801,2,0x436B29)
	$FC = Pixel_Search_Portable(938,448,2,0x5E7731)
	$FD = Pixel_Search_Portable(1149,289,2,0x517A28)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func Mining_Report()
	Local $hFile = FileOpen(@ScriptDir & "\mining\sa4.txt", $FO_CREATEPATH & $FO_APPEND)
	_FileWriteLog($hFile, "SA4: ") ; Write to the logfile passing the filehandle returned by FileOpen.
	For $i = 1 to 15
		If $mining_enemy[$i] == 1 Then
			FileWrite($hFile, $i & " ")
		EndIf
	Next
	FileWrite($hFile, @CRLF)
	FileClose($hFile) ; Close the filehandle to release the file.
EndFunc

Func Mining_Broadcast()

WinActivate("[CLASS:IEFrame]")

Mouse_Click_Portable(893, 909)
Sleep(1500)

Send("SA4: " & @HOUR & ":" &@MIN & " : ")
For $i = 1 to 15
	If $mining_enemy[$i] == 1 Then
		Send($i & " ")
	EndIf
Next
Send("{Enter}")

Sleep(2000)

$hWnd_bluestack = WinWait("[TITLE:Bluestacks App Player]", "", 10)
WinActivate($hWnd_bluestack)

EndFunc