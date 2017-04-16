#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>


Check_General()

Func Check_General()
Local $colour = 0x5A6671
;box 1
$B1 = Pixel_Search_Portable_XY(774, 602, 53, 38, $colour)
;box 2
$B2 = Pixel_Search_Portable_XY(915, 650, 53, 38, $colour)
;box 3
$B3 = Pixel_Search_Portable_XY(1059, 696, 53, 38, $colour)
;box 4
$B4 = Pixel_Search_Portable_XY(744, 722, 53, 38, $colour)
;box 5
$B5 = Pixel_Search_Portable_XY(870, 769, 53, 38, $colour)
;box 6
$B6 = Pixel_Search_Portable_XY(1011, 814, 53, 38, $colour)
;box 7
$B7 = Pixel_Search_Portable_XY(714, 841, 53, 38, $colour)
;box 8
$B8 = Pixel_Search_Portable_XY(833, 897, 53, 38, $colour)
;box 9
$B9 = Pixel_Search_Portable_XY(955, 934, 53, 38, $colour)

If IsArray($B1) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B1")
If IsArray($B2) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B2")
If IsArray($B3) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B3")
If IsArray($B4) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B4")
If IsArray($B5) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B5")
If IsArray($B6) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B6")
If IsArray($B7) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B7")
If IsArray($B8) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B8")
If IsArray($B9) Then MsgBox($MB_SYSTEMMODAL, "Found!", "B9")
EndFunc


Func Pixel_Search_Wrap($xx1, $yy1, $xx2, $yy2,$colour)
	Return PixelSearch($xx1, $yy1, $xx2, $yy2, $colour, 10)
EndFunc


Func Pixel_Search_Portable_XY($xx, $yy, $x_range, $y_range,$colour)
	Return PixelSearch($xx-$x_range, $yy-$y_range, $xx+$x_range, $yy+$y_range, $colour, 10)
EndFunc

;Global $check = Pixel_Checksum_Portable(774, 602, 40)
;MsgBox($MB_SYSTEMMODAL, "Found!", ":" & $check)
Func Pixel_Checksum_Portable($xx, $yy, $range)
	Return PixelChecksum($xx-$range, $yy-$range, $xx+$range, $yy+$range)
EndFunc


SIMAYI()
ZHAOYUN()
LUBU()
SUNQUAN()

Func SIMAYI()
	;detect main screen
	$FA = PixelSearch(821, 390, 823, 392, 0x1F1426, 10)
	$FB = PixelSearch(991, 612, 993, 614, 0xC6CEDE, 10)
	$FC = PixelSearch(991, 343, 993, 345, 0x0A0A0A, 10)
	$FD = PixelSearch(949, 452, 951, 454, 0xC4AD9E, 10)
	$FE = PixelSearch(775, 572, 777, 574, 0x58463C, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		MsgBox($MB_SYSTEMMODAL, "Terminated!", "Simayi")
		Return 1
	Else
		Return 0
	EndIf
EndFunc

Func ZHAOYUN()
	;detect main screen
	$FA = PixelSearch(910, 604, 912, 606, 0x1D4F91, 10)
	$FB = PixelSearch(723, 559, 725, 561, 0x9BA9A2, 10)
	$FC = PixelSearch(942, 378, 944, 280, 0x050B1C, 10)
	$FD = PixelSearch(1035, 598, 1037, 600, 0x161F27, 10)
	$FE = PixelSearch(915, 518, 917, 520, 0xE1CABE, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		MsgBox($MB_SYSTEMMODAL, "Terminated!", "Zhaoyun")
		Return 1
	Else
		Return 0
	EndIf
EndFunc



Func LUBU()
	;detect main screen
	$FA = PixelSearch(978, 317, 980, 319, 0xB72020, 10)
	$FB = PixelSearch(775, 543, 777, 545, 0x060E0E, 10)
	$FC = PixelSearch(785, 533, 787, 535, 0x0A1212, 10)
	$FD = PixelSearch(853, 621, 855, 623, 0x804938, 10)
	$FE = PixelSearch(944, 433, 946, 435, 0xB08976, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		MsgBox($MB_SYSTEMMODAL, "Terminated!", "Lubu")
		Return 1
	Else
		Return 0
	EndIf
EndFunc



Func SUNQUAN()
	;detect main screen
	$FA = PixelSearch(934, 399, 936, 401, 0xE9D0A9, 10)
	$FB = PixelSearch(846, 520, 848, 522, 0x89705F, 10)
	$FC = PixelSearch(1130, 602, 1132, 604, 0x966D2B, 10)
	$FD = PixelSearch(984, 497, 986, 499, 0x111111, 10)
	$FE = PixelSearch(954, 644, 956, 646, 0x1F2748, 10)
	IF IsArray($FA) And IsArray($FB) And IsArray($FC) And IsArray($FD) And IsArray($FE) Then
		MsgBox($MB_SYSTEMMODAL, "Terminated!", "Sunquan")
		Return 1
	Else
		Return 0
	EndIf
EndFunc






