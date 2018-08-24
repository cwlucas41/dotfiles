import XMonad

import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.Grid

import XMonad.Util.Run
import XMonad.Util.EZConfig

myManageHook = composeOne
    [ isDialog                      -?> doCenterFloat
    , className =? "jetbrains-idea" -?> doShift "1"
    , className =? "Pidgin"         -?> doShift "3"
    ] <+> manageDocks <+> manageHook desktopConfig

myLayoutHook = avoidStruts $
    smartBorders $
    onWorkspace "3" imLayout $
    tall ||| threeCol ||| simpleTabbed

tall = ResizableTall 1 (3/100) (34/55) []
threeCol = ThreeColMid 1 (3/100) (34/55)
imLayout = withIM (3/16) (Role "buddy_list") (simpleTabbed ||| Grid)

myHandleEventHook = docksEventHook <+> handleEventHook desktopConfig

myStartupHook = setWMName "LG3D" <+> startupHook desktopConfig

conf = desktopConfig
    { manageHook = myManageHook
    , modMask = mod4Mask
    , startupHook = myStartupHook
    , layoutHook = myLayoutHook
    , handleEventHook = myHandleEventHook
    , terminal = "urxvt"
    , borderWidth = 3
    , normalBorderColor = "#aea79f"
    , focusedBorderColor = "#e95420"
    } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures'")
        , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Pictures'")
        , ((mod4Mask, xK_b), sendMessage ToggleStruts)
        , ((mod4Mask .|. controlMask, xK_j), sendMessage MirrorShrink)
        , ((mod4Mask .|. controlMask, xK_k), sendMessage MirrorExpand) 
        ]
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad conf {
        logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "white" "" . shorten 75
            }
    }
