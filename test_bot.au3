#include "bluestack.au3"

PC_Check()
Configure_BlueStack()


MsgBox($MB_SYSTEMMODAL, "Environment Check!", "Please let the bot run from starting BlueStack until it turns off the program!")
Master_Settings()
MsgBox($MB_SYSTEMMODAL, "Tips:", "Press Ctrl + X anytime to stop the bot!")

ToolTip('This box shows bot still running.',500,500)

Open_DH()
MsgBox($MB_SYSTEMMODAL, "Check 01:", "Do you able to see DH main screen now?")

PLAYER_INFO(1)
LOGIN()
MsgBox($MB_SYSTEMMODAL, "Check 02:", "Your account successfully login?")

MsgBox($MB_SYSTEMMODAL, "Check 03:", "Say Hi!")
Daily_Greeting()
MsgBox($MB_SYSTEMMODAL, "Check 04:", "Collect tax!")
Tax_Collection()
MsgBox($MB_SYSTEMMODAL, "Check 05:", "Admire. Note: Only support English version")
Admire_crw()

MsgBox($MB_SYSTEMMODAL, "Check 06:", "Close DH now.")
Close_DH()

MsgBox($MB_SYSTEMMODAL, "Finish", "Basic checking done!")