import XMonad


import XMonad.Actions.SpawnOn

import XMonad.Config.Desktop

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.IM
import XMonad.Layout.Grid

import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.Cursor
import XMonad.Util.EZConfig

import Graphics.X11.ExtraTypes.XF86

myModMask = mod4Mask
myTerminal = "urxvt"
myBorderWidth = 3
myNormalBorderColor = "#aea79f"
myFocusedBorderColor = "#e95420"

myManageHook = composeOne
    [ isDialog                      -?> doCenterFloat
    , isFullscreen                  -?> doFullFloat
    , className =? "Pidgin"         -?> doShift "3"
    ] <+> manageDocks <+> manageSpawn <+> manageHook desktopConfig

myLayoutHook = desktopLayoutModifiers $
    smartBorders $
    onWorkspace "3" imLayout $
    onWorkspace "5" tabbedFirst $
    normal

tall = ResizableTall 1 (3/100) (34/55) []
imLayout = withIM (1/8) (Role "buddy_list") (GridRatio (4/3) ||| simpleTabbed)
normal = tall ||| Mirror tall ||| simpleTabbed
tabbedFirst = simpleTabbed ||| tall ||| Mirror tall

myHandleEventHook = docksEventHook <+> handleEventHook desktopConfig <+> fullscreenEventHook

myStartupHook = setWMName "LG3D" 
    <+> spawn "setxkbmap -option && setxkbmap -option altwin:swap_alt_win,ctrl:nocaps,shift:both_capslock" 
    <+> spawn "xcape -e 'Control_L=Escape'" 
    <+> spawn "xsetroot -solid '#000' -cursor_name left_ptr" 

    <+> spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x000000 --height 18 --alpha 0 --monitor primary --iconspacing 5 --padding 5"
    <+> spawnOnce "nm-applet --sm-disable" 
    <+> spawnOnce "blueman-applet" 
    <+> spawnOnce "xscreensaver -no-splash" 
    <+> spawnOnce "xbanish" 
    <+> spawnOnce "jetbrains-toolbox --minimize" 
    <+> spawnOnce "clipit" 

    <+> spawnOnOnce "1" "google-chrome"
    <+> spawnOnOnce "1" myTerminal
    <+> spawnOnOnce "3" "pidgin" 
    <+> spawnOnOnce "4" "thunderbird" 
    <+> spawnOnOnce "5" "spotify" 
    <+> spawnOnOnce "5" "pavucontrol" 
    <+> startupHook desktopConfig

conf = 
    withUrgencyHook dzenUrgencyHook
    { args = ["-bg", "orange", "-fg", "black", "-xs", "1"]}
    desktopConfig
    { manageHook = myManageHook
    , modMask = myModMask
    , startupHook = myStartupHook
    , layoutHook = myLayoutHook
    , handleEventHook = myHandleEventHook
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    } `additionalKeys`
        [ ((myModMask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        , ((myModMask, xK_Print), spawn "scrot -u -e 'mv $f ~/Pictures'")
        , ((0, xK_Print), spawn "scrot -e 'mv $f ~/Pictures'")
        , ((myModMask, xK_u), focusUrgent)
        , ((myModMask, xK_b), sendMessage ToggleStruts)
        , ((myModMask .|. controlMask, xK_j), sendMessage MirrorShrink)
        , ((myModMask .|. controlMask, xK_k), sendMessage MirrorExpand) 
        , ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
        , ((0, xF86XK_AudioStop), spawn "playerctl stop")
        , ((0, xF86XK_AudioNext), spawn "playerctl next")
        , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
        , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2%+")
        , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2%-")
        ]
 
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad conf {
        logHook = dynamicLogWithPP xmobarPP
            { ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "white" "" . shorten 75
            } <+> logHook desktopConfig
    }
