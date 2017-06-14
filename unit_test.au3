#include "bluestack.au3"


PC_SET_SCALE()


;Mouse_Drag_Portable(1, 750, 911, 1150, 911)
;Sleep(1000)

Mystic_Legend_General()

If 0 Then
;MsgBox($MB_SYSTEMMODAL, "Check 01:", "Do you able to see DH main screen now:" & Legend_General_Cleared() )
$players_file = "players_donate.txt"
$players_loopback = "loopback.txt"
$number_count = 1
PLAYER_INFO($number_count)
While ($player) And ($password) And ($server)
PLAYER_INFO_LOOPBACK()
$number_count = $number_count + 1
PLAYER_INFO($number_count)
WEnd
EndIf