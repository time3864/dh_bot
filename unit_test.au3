#include "bluestack.au3"

Reset_DH_Scale()

;Occupy(779,248)
;Sleep(2000)
;Mining_Collection()

Mystic_Legend_General()


;MsgBox($MB_SYSTEMMODAL, "Check 05:", "Admire. \nNote: Only support English version")


;Onslaught_Mission()

Func Check_Mine_01()
	$FA = Pixel_Search_Portable(972,350,1,0x262625)
	If IsArray($FA) Then
		MsgBox($MB_SYSTEMMODAL, "Found!", "gold reset!")
	EndIf
EndFunc


Func Occupy($x, $y)
	Mouse_Click_Portable($x, $y)
	Sleep(1000)

	$FA = Pixel_Search_Portable(947,706,1,0x0FC30F)
	$FB = Pixel_Search_Portable(990,708,1,0x039D09)
	;free to occupy
	If IsArray($FA) And IsArray($FB) Then
		;MsgBox($MB_SYSTEMMODAL, "Found!", "gold reset!")
		Mouse_Click_Portable(966, 722)
		Sleep(1000)
	EndIf
EndFunc


Func Mining_Collection()

	$FA = Pixel_Search_Portable(1021,1010,2,0xCC0627)
	$FB = Pixel_Search_Portable(948,1015,2,0x0EBF0E)
	$FC = Pixel_Search_Portable(732,834,2,0xBE0222)
	If IsArray($FA) And IsArray($FB) And IsArray($FC) Then
		Mouse_Click_Portable(952, 1029)
		Sleep(1000)
		Return 1
	Else
		Return 0
	EndIf

EndFunc