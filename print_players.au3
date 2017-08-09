#include "bluestack.au3"
PC_SET_SCALE()

If 1 Then
;MsgBox($MB_SYSTEMMODAL, "Check 01:", "Do you able to see DH main screen now:" & Legend_General_Cleared() )
$players_file = "players_donate.txt"
$players_loopback = "loopback.txt"
FileDelete(@ScriptDir & "\" & $players_loopback)
$number_count = 1
PLAYER_INFO($number_count,7)
While ($player) And ($password) And ($server)
PLAYER_INFO_ONLY()
$number_count = $number_count + 1
PLAYER_INFO($number_count,7)
WEnd
EndIf