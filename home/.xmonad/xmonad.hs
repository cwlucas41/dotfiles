import XMonad

import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
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
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Util.EZConfig

myTerminal = "urxvt"
myBorderWidth = 3
myNormalBorderColor = "#aea79f"
myFocusedBorderColor = "#e95420"

myManageHook = composeOne
    [ isDialog                      -?> doCenterFloat
    , className =? "jetbrains-idea" -?> doShift "2"
    , className =? "Pidgin"         -?> doShift "3"
    ] <+> manageDocks <+> manageHook desktopConfig

myLayoutHook = avoidStruts $
    smartBorders $
    onWorkspace "3" imLayout $
    tall ||| Mirror tall ||| threeCol ||| simpleTabbed

tall = ResizableTall 1 (3/100) (34/55) []
threeCol = ThreeColMid 1 (3/100) (34/55)
imLayout = withIM (1/8) (Role "buddy_list") (simpleTabbed ||| GridRatio (4/3))

myHandleEventHook = docksEventHook <+> handleEventHook desktopConfig

myStartupHook = setWMName "LG3D" 
    <+> spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 18 --alpha 0 --monitor primary"
    <+> spawnOnce "nm-applet --sm-disable" 
    <+> spawnOnce "xscreensaver -no-splash" 
    <+> spawnOnce "xsetroot -cursor_name left_ptr" 
    <+> spawnOnce "xbanish" 
    <+> spawnOnce "jetbrains-toolbox --minimize" 
    <+> spawnOnce "idea" 
    <+> spawnOnce "firefox"
    <+> spawnOnce myTerminal
    <+> spawnOnce "pidgin" 
    <+> startupHook desktopConfig

conf = 
    withUrgencyHook dzenUrgencyHook
    { args = ["-bg", "orange", "-fg", "black", "-xs", "1"]}
    desktopConfig
    { manageHook = myManageHook
    , modMask = mod4Mask
    , startupHook = myStartupHook
    , layoutHook = myLayoutHook
    , handleEventHook = myHandleEventHook
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock; sleep 0.2; xset dpms force off")
        , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures'")
        , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Pictures'")
        , ((mod4Mask, xK_u), focusUrgent)
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
