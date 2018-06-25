import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import qualified Data.Map as M

-- The main function.
main = xmonad =<< statusBar myBar myPP toggleStrutsKey defaultConfig { 
	terminal    	= "gnome-terminal",
	keys = mykeys <+> keys def
}

-- xmobar
myBar = "xmobar"

myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


-- bindings
mykeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList
	[ ((modm, xK_f), spawn "firefox")
	, ((modm, xK_n), spawn "dmenu_run")
	]
