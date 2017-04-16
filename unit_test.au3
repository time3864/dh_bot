#include "bluestack.au3"

;Sleep(2000)


Reset_DH_Scale()



Local $rr = 1
MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $rr)
Compute_X_Coordinate($rr)
MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $rr)
Compute_Y_Coordinate($rr)
MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $rr)

$dh_y_scale = 5
$dh_x_scale = 0.2
Compute_X_Coordinate($rr)
MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $rr)
Compute_Y_Coordinate($rr)
MsgBox($MB_SYSTEMMODAL, "Terminated!", ":" & $rr)
#CS $y = test()
;
; If IsArray($y) Then
; 	MsgBox($MB_SYSTEMMODAL, "Terminated!", $y[0] & ":" & $y[1])
; EndIf
;
; $y = test2()
;
; If IsArray($y) Then
; 	MsgBox($MB_SYSTEMMODAL, "Terminated!", "SA4 4")
; EndIf
;
; Func test()
; 	Local $x[2]
; 	$x[0] = 12
; 	$x[1] = 24
; 	Return $x
; EndFunc
;
; Func test2()
; 	Local $x
; 	$x = 12
; 	Return $x
; EndFunc
 #CE


Exit