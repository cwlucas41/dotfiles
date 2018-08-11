import XMonad

import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile

import XMonad.Util.Run
import XMonad.Util.EZConfig

myManageHook = composeAll
    [ className =? "Gimp"       --> doFloat
    , className =? "Vncviewer"  --> doFloat
    , isDialog                  --> doCenterFloat
    ] <+> manageDocks <+> manageHook desktopConfig

myLayoutHook = avoidStruts $
     tall ||| threeCol ||| simpleTabbed

tall = ResizableTall 1 (3/100) (34/55) []
threeCol = ThreeColMid 1 (3/100) (34/55)

myHandleEventHook = docksEventHook <+> handleEventHook desktopConfig

myStartupHook = setWMName "LG3D" <+> startupHook desktopConfig
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ desktopConfig
        { manageHook = myManageHook
        , modMask = mod4Mask
        , startupHook = myStartupHook
        , layoutHook = myLayoutHook
        , handleEventHook = myHandleEventHook
        , terminal = "urxvt"
        , borderWidth = 2
        , normalBorderColor = "#aaaaaa"
        , focusedBorderColor = "#eeeeee"
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "white" "" . shorten 75
                        }
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures'")
        , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Pictures'")
        , ((mod4Mask, xK_b), sendMessage ToggleStruts)
        , ((mod4Mask .|. controlMask, xK_j), sendMessage MirrorShrink)
        , ((mod4Mask .|. controlMask, xK_k), sendMessage MirrorExpand) 
        ]
