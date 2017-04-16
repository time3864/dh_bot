#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include "ImageSearch.au3"
#include <File.au3>

Global $current_mission
Global $status = 0
Global $master = 1

Global $player
Global $password
Global $server

HotKeySet("^x", "_exit")
Func _exit()
	Error_Log("Ctrl X")
    Exit
EndFunc

HotKeySet("^y", "_check")
Func _check()
	Error_Log("Mission checking!")
	;MsgBox($MB_SYSTEMMODAL, "", "Current mission: " & $current_mission, 2)
EndFunc


IF 1 Then

$current_mission = 1
Main_Controller()

Else

$current_mission = 19
$status = 0
All_Missions()

EndIf


Func Main_Controller()

For $i = 1 To 5
$status = 0
Open_DH()
If $status == 0 Then
All_Missions()
Else
Close_DH()
EndIf
;if no error, no need to restart
If $status == 0 Then
$i = 5
EndIf

Next

EndFunc


Func All_Missions()

Switch $current_mission
case 1
	$current_mission = 1
	Daily_Greeting()
	If $status == 0 Then
	ContinueCase
	EndIf
case 2
	$current_mission = 2
	Flags()
	If $status == 0 Then
	ContinueCase
	EndIf
case 3
	$current_mission = 3
	Tax_Collection()
	If $status == 0 Then
	ContinueCase
	EndIf
case 4
	$current_mission = 4
	Awaken_Spin()
	If $status == 0 Then
	ContinueCase
	EndIf
case 5
	$current_mission = 5
	Level_Up()
	If $status == 0 Then
	ContinueCase
	EndIf
case 6
	$current_mission = 6
	Daily_Shop()
	If $status == 0 Then
	ContinueCase
	EndIf
case 7
	$current_mission = 7
	Alliance_Mission()
	If $status == 0 Then
	ContinueCase
	EndIf
case 8
	$current_mission = 8
	Rob_5_times()
	If $status == 0 Then
	ContinueCase
	EndIf
case 9
	$current_mission = 9
	;normal mode
	Elite_Mode(817)
	;hard mode
	Elite_Mode(1090)
	If $status == 0 Then
	ContinueCase
	EndIf
case 10
	$current_mission = 10
	Arena_Mission()
	If $status == 0 Then
	ContinueCase
	EndIf
case 11
	$current_mission = 11
	Arena_Rewards()
	If $status == 0 Then
	ContinueCase
	EndIf
case 12
	$current_mission = 12
	Admire_crw()
	If $status == 0 Then
	ContinueCase
	EndIf
case 13
	$current_mission = 13
	Souls_Battlefield()
	If $status == 0 Then
	ContinueCase
	EndIf
case 14
	$current_mission = 14
	Legend_General()
	If $status == 0 Then
	ContinueCase
	EndIf
case 15
	$current_mission = 15
	Free_Spin_Altar()
	If $status == 0 Then
	ContinueCase
	EndIf
case 16
	$current_mission = 16
	General_Cultivate()
	If $status == 0 Then
	ContinueCase
	EndIf
case 17
	$current_mission = 17
	Group_Battle()
	If $status == 0 Then
	ContinueCase
	EndIf
case 18
	$current_mission = 18
	Weapon_Refine()
	If $status == 0 Then
	ContinueCase
	EndIf
case 19
	$current_mission = 19
	Altar_Spin()
	If $status == 0 Then
	ContinueCase
	EndIf
case 20
	$current_mission = 20
	Onslaught_Mission()
	If $status == 0 Then
	ContinueCase
	EndIf
case 21
	$current_mission = 21
	Collect_Gate_Rewards()
	If $status == 0 Then
	ContinueCase
	EndIf
case 22
	$current_mission = 22
	Break_Weapon()
	If $status == 0 Then
	ContinueCase
	EndIf
case 23
	$current_mission = 23
	Recruit_5_times()
	If $status == 0 Then
	ContinueCase
	EndIf
case 24
	$current_mission = 24
	Spirit_Search()
	If $status == 0 Then
	ContinueCase
	EndIf
case 25
	$current_mission = 25
	;Breakdown_Equip()
	If $status == 0 Then
	ContinueCase
	EndIf
case 26
	$current_mission = 26
	Borrow_Arrow()
	If $status == 0 Then
	ContinueCase
	EndIf
case 27
	$current_mission = 27
	;Tomb_Raid()
	If $status == 0 Then
	ContinueCase
	EndIf
case 100
	$current_mission = 100
	Collect_Rewards()
	Collect_Weekly_Rewards()
	If $status == 0 Then
	Error_Log("All mission completed!")
	ContinueCase
	EndIf
EndSwitch

EndFunc

Func STOP_SCRIPT()
    Exit
EndFunc

Func Error_Log($log)
Local $hFile = FileOpen(@ScriptDir & "\log.txt", 1)

_FileWriteLog($hFile, "Current mission: " & $current_mission & " Reason: " & $log) ; Write to the logfile passing the filehandle returned by FileOpen.
FileClose($hFile) ; Close the filehandle to release the file.
EndFunc

Func Master_Command()

Local $hFileOpen = FileOpen("settings.txt", $FO_READ)
If $hFileOpen == -1 Then
        Error_Log("Settings failed!")
Else
		;Error_Log("Settings OK!")
		Local $sFileRead = FileReadLine($hFileOpen, 1)
		;MsgBox($MB_SYSTEMMODAL, "", "File read: " & $sFileRead)
		$master = $sFileRead
		FileClose($hFileOpen)
EndIf

EndFunc

Func Detect_Main_Screen()
	;detect main screen
	$FA = PixelSearch(1115, 82, 1117, 84, 0xEAB70E, 10)
	$FB = PixelSearch(779, 844, 781, 846, 0x891010, 10)
	$FC = PixelSearch(1173, 847, 1175, 849, 0x800A0A, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func BACK_TO_MAIN_SCREEN()
    ;press x
	For $i = 1 To 5
		MouseClick($MOUSE_CLICK_LEFT, 1202, 1038, 1)
		Sleep(3000)
		IF Detect_Main_Screen() Then
			Return
		EndIf
	Next
    Error_Log("Mission failed!")
	;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Main screen failed! Current mission: " & $current_mission)
	;STOP_SCRIPT()
	$status = 1
EndFunc

Func LOGIN_PLAYER($number)

$player = 0
$password = 0
$server = 0

Local $sFileRead
Local $hFileOpen = FileOpen("players.txt", $FO_READ)
If $hFileOpen == -1 Then
        Error_Log("Players list failed!")
Else
		Error_Log("Read players!")
		$sFileRead = FileReadLine($hFileOpen, 1 + ($number - 1)*3)
		If $sFileRead Then
		$player = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 2 + ($number - 1)*3)
		If $sFileRead Then
		$password = $sFileRead
		EndIf
		$sFileRead = FileReadLine($hFileOpen, 3 + ($number - 1)*3)
		If $sFileRead Then
		$server = $sFileRead
		Endif
		FileClose($hFileOpen)
		MsgBox($MB_SYSTEMMODAL, "Terminated!", "Info: " & $player & ":" & $password & ":" & $server)
EndIf

EndFunc

Func Open_DH()
;Open Blue Stack
Run("C:\ProgramData\BlueStacksGameManager\BlueStacks.exe")
Local $hWnd = WinWait("[CLASS:BlueStacksApp]", "", 10)
WinActivate($hWnd)

;go to "Android tab"
MouseClick($MOUSE_CLICK_LEFT, 386, 30, 1)
Sleep(5000)
;click back to main page
MouseClick($MOUSE_CLICK_LEFT, 34, 31, 1)
Sleep(5000)
;drag up
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 888)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 888)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 888)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 888)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 888)
Sleep(1000)
;open all apps
MouseClick($MOUSE_CLICK_LEFT, 1799, 213, 1)
Sleep(15000)
;Open game
MouseClick($MOUSE_CLICK_LEFT, 702, 223, 1)
;MouseClick($MOUSE_CLICK_LEFT, 329, 219, 1)
Sleep(20000)

;Check for front page
$FA = PixelSearch(1000, 368, 1002, 370, 0xFFFFFF, 10)
$FB = PixelSearch(749, 909, 751, 909, 0xFFE075, 10)
$FC = PixelSearch(926, 244, 928, 246, 0x393931, 10)

LOGIN_PLAYER(1)

IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
    MouseClick($MOUSE_CLICK_LEFT, 944, 532, 1)
	Error_Log("DH started!")
Else
	$status = 1
	Error_Log("Program failed!")
	;MsgBox($MB_SYSTEMMODAL, "Terminated!", "Main screen failed!")
    ;STOP_SCRIPT()
EndIf
Sleep(10000)

;Check for robbed
$FA = PixelSearch(836, 883, 838, 885, 0x01B429, 10)
$FB = PixelSearch(1068, 882, 1070, 884, 0X9E1212, 10)
$FB = PixelSearch(973, 623, 975, 625, 0x403b37, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
    MouseClick($MOUSE_CLICK_LEFT, 841, 893, 1)
EndIf
Sleep(10000)
EndFunc

Func Close_DH()
MouseClick($MOUSE_CLICK_LEFT, 745, 26, 1)
Sleep(2000)
MouseClick($MOUSE_CLICK_LEFT, 745, 26, 1)
Sleep(2000)
MouseClick($MOUSE_CLICK_LEFT, 745, 26, 1)
Sleep(2000)
EndFunc


;DH_Image_Search()
Func DH_Image_Search()
global $y = 0, $x = 0

;local $search = _ImageSearchArea('google.bmp', 1, 800, 40, 900, 80, $dh_x, $dh_y, 0)
Local $search = _ImageSearch('google.bmp', 0, $x, $y, 0)
If $search = 1 Then
	MsgBox($MB_SYSTEMMODAL, "Found!", "Google found!")
MouseMove($x, $y, 10)
Else
	MsgBox($MB_SYSTEMMODAL, "Found!", "Google NOT found!")
EndIf

EndFunc

Func Battle_Start()
;start battle
MouseClick($MOUSE_CLICK_LEFT, 953, 1032, 1)
Sleep(5000)
;check if ask for use token?

;check if auto on
$FA = PixelSearch(1211, 1055, 1213, 1057, 0x7D7D7D, 10)
$FB = PixelSearch(1220, 1023, 1222, 1025, 0x222222, 10)
$FC = PixelSearch(1191, 1056, 1193, 1058, 0x090909, 10)
IF IsArray($FA) Or IsArray($FB) Or IsArray($FC) Then
    MouseClick($MOUSE_CLICK_LEFT, 1191, 1056, 1)
	Sleep(1000)
EndIf
;hard to judge if x2 is on, just click for alternate x1 and x2
Sleep(3000)
MouseClick($MOUSE_CLICK_LEFT, 781, 1029, 1)
Sleep(1000)

EndFunc

Func Battle_End()
;wait until battle finish
Local $i = 0
Local $timeout = 300
Do
$FA = PixelSearch(941, 867, 943, 869, 0x06B706, 10)
$FB = PixelSearch(952, 912, 954, 914, 0X0FC40E, 10)
$FC = PixelSearch(946, 870, 948, 872, 0X15B515, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
    $i = 1
Else
	$timeout = $timeout - 1
	If $timeout > 0 Then
		$i = 0  ; continue running if not timeout
	Else
		$i = 1  ; discontinued if timeout
	EndIf
	Sleep(1000)
EndIf
Until $i = 1
MouseClick($MOUSE_CLICK_LEFT, 951, 886, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 951, 886, 1)
Sleep(1000)

EndFunc


Func Rob_End()
;wait until battle finish
Local $i = 0
Do
$FA = PixelSearch(937, 904, 939, 906, 0x10BA1E, 10)
$FB = PixelSearch(957, 951, 959, 953, 0X19BB10, 10)
$FC = PixelSearch(987, 911, 989, 913, 0X0A9F0F, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
    $i = 1
Else
	Sleep(1000)
EndIf
$FA = PixelSearch(940, 910, 942, 912, 0xB40B0B, 10)
$FB = PixelSearch(941, 914, 943, 916, 0XC40F0F, 10)
$FC = PixelSearch(984, 911, 986, 913, 0X9C0E06, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
    $i = 1
Else
	Sleep(1000)
EndIf
Until $i = 1
MouseClick($MOUSE_CLICK_LEFT, 957, 927, 1)
Sleep(1000)

EndFunc

;;daily greeting
Func Daily_Greeting()
MouseClick($MOUSE_CLICK_LEFT, 941, 882, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 806, 952, 1)
Sleep(1000)
Send("hi{Enter}")
Sleep(2000)
MouseClick($MOUSE_CLICK_LEFT, 952, 1038, 1)
Sleep(1000)
BACK_TO_MAIN_SCREEN()
EndFunc

;;Flags
Func Flags()
MouseClick($MOUSE_CLICK_LEFT, 723, 1018, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 950, 321, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 961, 1024, 1)
Sleep(2000)
;press x
BACK_TO_MAIN_SCREEN()
EndFunc

;;Coin
Func Tax_Collection()
MouseClick($MOUSE_CLICK_LEFT, 1098, 291, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 948, 1035, 1)
Sleep(1000)
BACK_TO_MAIN_SCREEN()
EndFunc


;;Awaken spin
Func Awaken_Spin()
MouseClick($MOUSE_CLICK_LEFT, 723, 1018, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1146, 691, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 750, 124, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 792, 836, 1)
Sleep(5000)
;return
MouseClick($MOUSE_CLICK_LEFT, 834, 1001, 1)
Sleep(1000)
BACK_TO_MAIN_SCREEN()
EndFunc

;;level up
Func Level_Up()
MouseClick($MOUSE_CLICK_LEFT, 815, 1016, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 953, 234, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 956, 459, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 888, 940, 1)
Sleep(1000)
For $i = 1 To 20
;auto-add
MouseClick($MOUSE_CLICK_LEFT, 956, 837, 1)
Sleep(500)
MouseClick($MOUSE_CLICK_LEFT, 947, 1034, 1)
Sleep(500)
Next
BACK_TO_MAIN_SCREEN()
EndFunc

;;Shop
Func Daily_Shop()
MouseClick($MOUSE_CLICK_LEFT, 1105, 1017, 1)
Sleep(1000)
;co
MouseClick($MOUSE_CLICK_LEFT, 1159, 718, 1)
Sleep(1000)
;+10
MouseClick($MOUSE_CLICK_LEFT, 1101, 710, 1)
Sleep(1000)
;purchase
MouseClick($MOUSE_CLICK_LEFT, 957, 836, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1202, 1038, 1)
Sleep(1000)
BACK_TO_MAIN_SCREEN()
EndFunc



Func Alliance_Mission()
;;alliance
MouseClick($MOUSE_CLICK_LEFT, 1005, 1013, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1146, 315, 1)
Sleep(1000)
;construction
MouseClick($MOUSE_CLICK_LEFT, 963, 416, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 840, 949, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 840, 949, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 840, 949, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 840, 949, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 840, 949, 1)
Sleep(1000)
;return to alliance main page
MouseClick($MOUSE_CLICK_LEFT, 709, 1041, 1)
Sleep(1000)
;temple worship
MouseClick($MOUSE_CLICK_LEFT, 959, 610, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 960, 1002, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 823, 645, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 958, 691, 1)
Sleep(1000)
;return to alliance main page
MouseClick($MOUSE_CLICK_LEFT, 709, 1041, 1)
Sleep(1000)
;drag to alliance shop
;drag
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 474, 938, 330)
Sleep(1000)
;click alliance shop
MouseClick($MOUSE_CLICK_LEFT, 958, 872, 1)
Sleep(1000)
;drag to bottom
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
;buy bahuang stone
MouseClick($MOUSE_CLICK_LEFT, 1141, 382, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1100, 707, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 960, 841, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1052, 205, 1)
Sleep(1000)
;return to alliance main page
MouseClick($MOUSE_CLICK_LEFT, 709, 1041, 1)
Sleep(1000)

;drag to bottom
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)

;;war page collect rewards
MouseClick($MOUSE_CLICK_LEFT, 954, 384, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1190, 115, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 950, 1030, 1)
Sleep(1000)
;return to alliance main page
MouseClick($MOUSE_CLICK_LEFT, 709, 1041, 1)
Sleep(1000)
;return to alliance main page
MouseClick($MOUSE_CLICK_LEFT, 709, 1041, 1)
Sleep(1000)


;drag to bottom
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
;;alliance dungeon
MouseClick($MOUSE_CLICK_LEFT, 954, 571, 1)
Sleep(2000)
For $i = 1 To 3
MouseClick($MOUSE_CLICK_LEFT, 954, 306, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 954, 1032, 1)
Sleep(8000)
MouseClick($MOUSE_CLICK_LEFT, 1215, 1036, 1)
Sleep(5000)
MouseClick($MOUSE_CLICK_LEFT, 960, 823, 1)
Sleep(1000)
Next
BACK_TO_MAIN_SCREEN()
EndFunc


;;arena
Func Arena_Mission()
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 959, 520, 1)
Sleep(1000)
For $i = 1 To 5
;drag to bottom
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1165, 899, 1)
Sleep(8000)
MouseClick($MOUSE_CLICK_LEFT, 1213, 1042, 1)
Sleep(5000)
MouseClick($MOUSE_CLICK_LEFT, 960, 884, 1)
Sleep(3000)
Next
BACK_TO_MAIN_SCREEN()
EndFunc

Func Arena_Rewards()
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 959, 520, 1)
Sleep(1000)
;;arena collection
;enter reward page
MouseClick($MOUSE_CLICK_LEFT, 866, 1008, 1)
Sleep(1000)
;collect
MouseClick($MOUSE_CLICK_LEFT, 1172, 390, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 569, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 750, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 928, 1)
Sleep(1000)
;5th reward
;slight drag
MouseClickDrag($MOUSE_CLICK_LEFT, 949, 845, 949, 312)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 390, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 569, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 750, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1172, 928, 1)
Sleep(1000)
BACK_TO_MAIN_SCREEN()
EndFunc
;;




;;Cross-realm war
Func Admire_crw()
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag to bottom
For $i = 1 To 10
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
;click page
MouseClick($MOUSE_CLICK_LEFT, 948, 358, 1)
Sleep(1000)
;click admire
MouseClick($MOUSE_CLICK_LEFT, 788, 917, 1)
Sleep(1000)
;gold admire
MouseClick($MOUSE_CLICK_LEFT, 876, 1025, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 876, 1025, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 876, 1025, 1)
Sleep(1000)
;coin admire
MouseClick($MOUSE_CLICK_LEFT, 1043, 1024, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1043, 1024, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Borrow_Arrow()
If @HOUR == 0 or @HOUR == 23 Then
Return
EndIf
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(500)
;click borrow arrow
MouseClick($MOUSE_CLICK_LEFT, 951, 293, 1)
Sleep(1000)
;click appointment
MouseClick($MOUSE_CLICK_LEFT, 779, 937, 1)
Sleep(1000)
;click appoint
MouseClick($MOUSE_CLICK_LEFT, 958, 884, 1)
Sleep(1000)
;click confirm
MouseClick($MOUSE_CLICK_LEFT, 959, 642, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Souls_Battlefield()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(500)
;click page
MouseClick($MOUSE_CLICK_LEFT, 945, 729, 1)
Sleep(1000)
;go to battle
MouseClick($MOUSE_CLICK_LEFT, 1152, 707, 1)
Sleep(1000)

;drag to bottom
For $i = 1 To 15
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
;check last box colour, if it is green, sweep
Local $error = 0
Do
$FA = PixelSearch(1024, 894, 1091, 931, 0x00B831, 10)
if IsArray($FA) == 0 Then
MouseClickDrag($MOUSE_CLICK_LEFT, 954, 801, 954, 900)
Sleep(500)
EndIf
$error = $error + 1
Until IsArray($FA) Or ($error == 100)

If $error == 100 Then

Else
For $i = 1 To 3
;click the green button
MouseClick($MOUSE_CLICK_LEFT, $FA[0], $FA[1], 1)
Sleep(1000)
;;should check for triumph
;click triumph
MouseClick($MOUSE_CLICK_LEFT, 959, 884, 1)
Sleep(1000)
Next
EndIf

BACK_TO_MAIN_SCREEN()
EndFunc

Func Legend_General()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag to bottom
For $i = 1 To 10
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
;drag up 3 boxes
MouseClickDrag($MOUSE_CLICK_LEFT, 953, 183, 953, 943)
Sleep(1000)
;click legends page
MouseClick($MOUSE_CLICK_LEFT, 950, 390, 1)
Sleep(1000)
;click zhang jiao
MouseClick($MOUSE_CLICK_LEFT, 1155, 919, 1)
Sleep(1000)
;click middle
MouseClick($MOUSE_CLICK_LEFT, 943, 549, 1)
Sleep(1000)
For $i = 1 To 5
;click Cao Cao
MouseClick($MOUSE_CLICK_LEFT, 987, 344, 1)
Sleep(1000)
;click battle
MouseClick($MOUSE_CLICK_LEFT, 957, 866, 1)
Sleep(1000)
Battle_Start()
Battle_End()
Next

BACK_TO_MAIN_SCREEN()
EndFunc

Func Free_Spin_Altar()

EndFunc


Func General_Cultivate()
;click general
MouseClick($MOUSE_CLICK_LEFT, 816, 1015, 1)
Sleep(1000)
;click last general
MouseClick($MOUSE_CLICK_LEFT, 1190, 238, 1)
Sleep(1000)
;click change general
MouseClick($MOUSE_CLICK_LEFT, 726, 1026, 1)
Sleep(1000)
;click first general in queue
MouseClick($MOUSE_CLICK_LEFT, 1165, 321, 1)
Sleep(1000)
;click general image
MouseClick($MOUSE_CLICK_LEFT, 940, 486, 1)
Sleep(1000)
;click cultivate
MouseClick($MOUSE_CLICK_LEFT, 1161, 938, 1)
Sleep(2000)
;click cultivate
MouseClick($MOUSE_CLICK_LEFT, 960, 1036, 1)
Sleep(2000)
;click back
MouseClick($MOUSE_CLICK_LEFT, 710, 1033, 1)
Sleep(1000)
;click change general
MouseClick($MOUSE_CLICK_LEFT, 726, 1026, 1)
Sleep(1000)
;click first general in queue
MouseClick($MOUSE_CLICK_LEFT, 1165, 321, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Group_Battle()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag to bottom
For $i = 1 To 10
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
;click group battle dungeon
MouseClick($MOUSE_CLICK_LEFT, 941, 588, 1)
Sleep(1000)
;click create
MouseClick($MOUSE_CLICK_LEFT, 1156, 219, 1)
Sleep(1000)
;select last dungeon
MouseClick($MOUSE_CLICK_LEFT, 1163, 773, 1)
Sleep(1000)
;click confirm
MouseClick($MOUSE_CLICK_LEFT, 961, 725, 1)
Sleep(1000)
;close room
MouseClick($MOUSE_CLICK_LEFT, 1088, 199, 1)
Sleep(1000)
;click enter
MouseClick($MOUSE_CLICK_LEFT, 960, 1036, 1)
Sleep(1000)
;click start
MouseClick($MOUSE_CLICK_LEFT, 960, 1036, 1)
Sleep(1000)
;click back
MouseClick($MOUSE_CLICK_LEFT, 710, 1033, 1)
Sleep(1000)
;click confirm
MouseClick($MOUSE_CLICK_LEFT, 810, 645, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Weapon_Refine()
;click general
MouseClick($MOUSE_CLICK_LEFT, 816, 1015, 1)
Sleep(1000)
;select Machao
MouseClick($MOUSE_CLICK_LEFT, 846, 236, 1)
Sleep(1000)
;select Machao horse
MouseClick($MOUSE_CLICK_LEFT, 746, 685, 1)
Sleep(1000)
;click refine
MouseClick($MOUSE_CLICK_LEFT, 1164, 931, 1)
Sleep(1000)
;click coin refine
MouseClick($MOUSE_CLICK_LEFT, 710, 713, 1)
Sleep(1000)
;refine 5 times
For $i = 1 To 5
MouseClick($MOUSE_CLICK_LEFT, 1142, 901, 1)
Sleep(1000)
$FA = PixelSearch(960, 273, 1237, 484, 0xCC0C0C, 10)
$FB = PixelSearch(960, 273, 1237, 484, 0xFD0101, 10)
$FC = PixelSearch(960, 273, 1237, 484, 0xEC0404, 10)
IF IsArray($FA) Or IsArray($FB) Or IsArray($FC) Then
;cancel if see any red
MouseClick($MOUSE_CLICK_LEFT, 1084, 895, 1)
Sleep(1000)
Else
;click save if not seen any red
MouseClick($MOUSE_CLICK_LEFT, 827, 895, 1)
Sleep(1000)
EndIf
Next

BACK_TO_MAIN_SCREEN()
EndFunc

Func Altar_Spin()
;click recruit
MouseClick($MOUSE_CLICK_LEFT, 914, 1024, 1)
Sleep(1000)
;click altar
MouseClick($MOUSE_CLICK_LEFT, 950, 879, 1)
Sleep(1000)
;click spin
MouseClick($MOUSE_CLICK_LEFT, 858, 1038, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc


Func Rob_5_times()
;click rob
MouseClick($MOUSE_CLICK_LEFT, 749, 879, 1)
Sleep(1000)
For $i = 1 To 5
;click search
MouseClick($MOUSE_CLICK_LEFT, 1174, 885, 1)
Sleep(3000)
Battle_Start()
Rob_End()
Next

BACK_TO_MAIN_SCREEN()
EndFunc



Func Collect_Gate_Rewards()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag to bottom
For $i = 1 To 10
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
;drag up 3 boxes
MouseClickDrag($MOUSE_CLICK_LEFT, 953, 183, 953, 943)
Sleep(1000)
;click gates page
MouseClick($MOUSE_CLICK_LEFT, 977, 634, 1)
Sleep(1000)
;click rewards
MouseClick($MOUSE_CLICK_LEFT, 1156, 934, 1)
Sleep(1000)
For $i = 1 To 60
MouseClick($MOUSE_CLICK_LEFT, 1180, 261, 1)
Sleep(500)
Next

BACK_TO_MAIN_SCREEN()
EndFunc


Func Break_Weapon()
If @WDAY == 2 Then

EndIf
EndFunc


Func Recruit_5_times()
;click recruit
MouseClick($MOUSE_CLICK_LEFT, 908, 1021, 1)
Sleep(1000)

Local $total_recruit = 5
$FA = PixelSearch(1094, 720, 1098, 724, 0x03EF0B, 10)
If IsArray($FA) Then
MouseClick($MOUSE_CLICK_LEFT, 953, 696, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 849, 579, 1)
Sleep(20000)
$total_recruit = $total_recruit - 1
EndIf
BACK_TO_MAIN_SCREEN()

;click recruit
MouseClick($MOUSE_CLICK_LEFT, 908, 1021, 1)
Sleep(1000)
$FA = PixelSearch(1090, 529, 1094, 533, 0x02EC05, 10)
If IsArray($FA) Then
MouseClick($MOUSE_CLICK_LEFT, 933, 506, 1)
Sleep(20000)
$total_recruit = $total_recruit - 1
EndIf
BACK_TO_MAIN_SCREEN()

;click recruit
For $i = 1 To $total_recruit
MouseClick($MOUSE_CLICK_LEFT, 908, 1021, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 946, 309, 1)
Sleep(20000)
BACK_TO_MAIN_SCREEN()
Next

EndFunc

Func Spirit_Search()
;click upgrade
MouseClick($MOUSE_CLICK_LEFT, 723, 1018, 1)
Sleep(1000)
;soul search
MouseClick($MOUSE_CLICK_LEFT, 1151, 316, 1)
Sleep(1000)
;coin search
MouseClick($MOUSE_CLICK_LEFT, 766, 941, 1)
Sleep(1000)
;1 time
MouseClick($MOUSE_CLICK_LEFT, 767, 514, 1)
Sleep(5000)
For $i = 1 To 5
MouseClick($MOUSE_CLICK_LEFT, 957, 1031, 1)
Sleep(1500)
Next
;click back
MouseClick($MOUSE_CLICK_LEFT, 701, 1047, 1)
Sleep(1000)
;batch operation
MouseClick($MOUSE_CLICK_LEFT, 1123, 256, 1)
Sleep(1000)
;1-3
MouseClick($MOUSE_CLICK_LEFT, 1104, 934, 1)
Sleep(1000)
;4
MouseClick($MOUSE_CLICK_LEFT, 902, 937, 1)
Sleep(1000)
;break down
MouseClick($MOUSE_CLICK_LEFT, 1048, 1042, 1)
Sleep(5000)
;5
MouseClick($MOUSE_CLICK_LEFT, 696, 933, 1)
Sleep(1000)
;save to inventory
MouseClick($MOUSE_CLICK_LEFT, 879, 1034, 1)
Sleep(1000)
;click back
MouseClick($MOUSE_CLICK_LEFT, 701, 1047, 1)
Sleep(1000)
;click back
MouseClick($MOUSE_CLICK_LEFT, 701, 1047, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Breakdown_Equip()
For $i = 1 To 20
MouseClick($MOUSE_CLICK_LEFT, 1130, 930, 1)
Sleep(500)
MouseClick($MOUSE_CLICK_LEFT, 967, 1035, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 966, 880, 1)
Sleep(1000)
Next
BACK_TO_MAIN_SCREEN()
EndFunc



Func Onslaught_Mission()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(500)
;onslaught mode
MouseClick($MOUSE_CLICK_LEFT, 984, 511, 1)
Sleep(1000)

;3 star sweep
For $i = 1 to 20
;3 stars sweep
MouseClick($MOUSE_CLICK_LEFT, 1148, 721, 1)
Sleep(1000)
;check if last stage
$FA = PixelSearch(939, 631, 941, 633, 0x0BB80B, 10)
$FB = PixelSearch(954, 672, 956, 674, 0x13D510, 10)
IF IsArray($FA) And IsArray($FB) Then
	;not last stage
Else
	;last stage
	Redeem_Stars()
	;;click reset
	MouseClick($MOUSE_CLICK_LEFT, 950, 1044, 1)
	Sleep(1000)
	;if gold reset now
	$FA = PixelSearch(803, 627, 805, 629, 0x10C510, 10)
	$FB = PixelSearch(859, 635, 861, 637, 0x169216, 10)
	$FC = PixelSearch(1090, 638, 1092, 640, 0xBC2218, 10)
	$FD = PixelSearch(1079, 633, 1081, 635, 0xC21010, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
		;gold reset now, cancel
		;MsgBox($MB_SYSTEMMODAL, "Found!", "gold reset!")
		MouseClick($MOUSE_CLICK_LEFT, 1102, 644, 1)
		Sleep(1000)
		BACK_TO_MAIN_SCREEN()
		Return
	Else
		;ok to reset
		;MsgBox($MB_SYSTEMMODAL, "Found!", "free reset!")
		MouseClick($MOUSE_CLICK_LEFT, 956, 639, 1)
		Sleep(1000)
		;3 stars sweep
		MouseClick($MOUSE_CLICK_LEFT, 1148, 721, 1)
		Sleep(1000)
	EndIf
EndIf
;sweep
MouseClick($MOUSE_CLICK_LEFT, 956, 638, 1)
Sleep(1000)
;triumph
MouseClick($MOUSE_CLICK_LEFT, 956, 885, 1)
Sleep(1000)
$FA = PixelSearch(829, 813, 831, 815, 0x08AB08, 10)
$FB = PixelSearch(834, 817, 836, 819, 0x10A510, 10)
$FC = PixelSearch(1083, 813, 1085, 815, 0x129612, 10)
$FD = PixelSearch(1066, 815, 1068, 817, 0x11BF11, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) Then
	;gates mission
	;MsgBox($MB_SYSTEMMODAL, "Found!", "gate!")
	MouseClick($MOUSE_CLICK_LEFT, 813, 819, 1)
	Sleep(1000)
Else
	;MsgBox($MB_SYSTEMMODAL, "Found!", "no gate!")
EndIf
Next

EndFunc

Func Elite_Mode($mode)
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;click elite mode
MouseClick($MOUSE_CLICK_LEFT, 962, 281, 1)
Sleep(1000)
;click hard
MouseClick($MOUSE_CLICK_LEFT, $mode, 189, 1)
Sleep(1000)
;;sweep from bottom
;drag to bottom
For $i = 1 To 10
MouseClickDrag($MOUSE_CLICK_LEFT, 938, 882, 938, 474)
Sleep(500)
Next
For $i = 1 To 30
;check if can be sweep
$FA = PixelSearch(978, 823, 1088, 959, 0x01AD28, 10)
If IsArray($FA) Then
;sweep
MouseClick($MOUSE_CLICK_LEFT, $FA[0], $FA[1], 1)
Sleep(2000)
;check for triumph button
$FA = PixelSearch(957, 872, 961, 876, 0x129612, 10)
If IsArray($FA) Then
MouseClick($MOUSE_CLICK_LEFT, 957, 886, 1)
Sleep(1000)
EndIf
EndIf
MouseClickDrag($MOUSE_CLICK_LEFT, 937, 790, 937, 975)
Sleep(1000)
Next
;;sweep from top
For $i = 1 To 4
;check if can be sweep
$FA = PixelSearch(978, 304 + ($i -1)*160, 1088, 462 + ($i -1)*160, 0x01AD28, 10)
If IsArray($FA) Then
;sweep
MouseClick($MOUSE_CLICK_LEFT, $FA[0], $FA[1], 1)
Sleep(2000)
;check for triumph button
$FA = PixelSearch(957, 872, 961, 876, 0x129612, 10)
If IsArray($FA) Then
MouseClick($MOUSE_CLICK_LEFT, 957, 886, 1)
Sleep(1000)
EndIf
EndIf
Next
;elite mode need to have more time as the "general combine" screen will appear
sleep(20000)
BACK_TO_MAIN_SCREEN()
EndFunc

Func Tomb_Raid()
;daily
MouseClick($MOUSE_CLICK_LEFT, 1184, 327, 1)
Sleep(1000)
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(1000)
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(1000)
;click tomb raid
MouseClick($MOUSE_CLICK_LEFT, 963, 267, 1)
Sleep(1000)
;click 4 directions
MouseClick($MOUSE_CLICK_LEFT, 870, 472, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 870, 659, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1054, 659, 1)
Sleep(1000)
MouseClick($MOUSE_CLICK_LEFT, 1054, 472, 1)
Sleep(1000)
;click surrender
MouseClick($MOUSE_CLICK_LEFT, 742, 173, 1)
Sleep(1000)
;click ok
MouseClick($MOUSE_CLICK_LEFT, 1054, 659, 1)
Sleep(1000)

BACK_TO_MAIN_SCREEN()
EndFunc

Func Collect_Rewards()
;click reward
MouseClick($MOUSE_CLICK_LEFT, 1188, 230, 1)
Sleep(1000)
;click daily
MouseClick($MOUSE_CLICK_LEFT, 943, 197, 1)
Sleep(1000)
Local $i = 0
Do
$FA = PixelSearch(1165, 373, 1167, 375, 0x01AD28, 10)
$FB = PixelSearch(1150, 376, 1152, 378, 0X00A425, 10)
$FC = PixelSearch(1173, 410, 1175, 412, 0X1AAB1A, 10)
IF IsArray($FA) And IsArray($FB) And IsArray($FC) Then
	MouseClick($MOUSE_CLICK_LEFT, 1174, 388, 1)
	Sleep(1500)
Else
    $i = 1
EndIf
Until $i = 1

BACK_TO_MAIN_SCREEN()
EndFunc

Func Redeem_Stars()
;redeem star
MouseClick($MOUSE_CLICK_LEFT, 1156, 933, 1)
Sleep(1000)
;;g3 gem pack redeem
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(500)
MouseClick($MOUSE_CLICK_LEFT, 1156, 933, 1)
Sleep(1000)
For $i = 1 to 35
MouseClick($MOUSE_CLICK_LEFT, 955, 838, 1)
Sleep(300)
Next
MouseClick($MOUSE_CLICK_LEFT, 971, 185, 1)
Sleep(1000)
;g3 gem pack redeem end

;;g1 gem pack redeem
;drag one page
MouseClickDrag($MOUSE_CLICK_LEFT, 965, 940, 956, 210)
Sleep(500)
MouseClick($MOUSE_CLICK_LEFT, 1156, 653, 1)
Sleep(1000)
For $i = 1 to 10
MouseClick($MOUSE_CLICK_LEFT, 955, 838, 1)
Sleep(300)
Next
MouseClick($MOUSE_CLICK_LEFT, 971, 185, 1)
Sleep(1000)
;g2 gem pack redeem end

;click back
MouseClick($MOUSE_CLICK_LEFT, 707, 1039, 1)
Sleep(1000)
EndFunc

Func Collect_Weekly_Rewards()
If @WDAY == 1 Then

EndIf

BACK_TO_MAIN_SCREEN()
EndFunc