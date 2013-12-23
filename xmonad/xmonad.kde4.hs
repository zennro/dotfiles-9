-- -*- mode: haskell; -*-
import XMonad

import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote
import XMonad.Actions.GridSelect
import XMonad.Actions.UpdatePointer
import XMonad.Actions.Warp
import XMonad.Actions.WindowMenu

import XMonad.Config.Desktop (desktopLayoutModifiers)
import XMonad.Config.Kde

import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks

import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName
import XMonad.Layout.Tabbed

import XMonad.Prompt ( XPConfig(..), XPPosition(..), defaultXPConfig
                     , defaultXPKeymap, moveHistory,  deleteConsecutive
                     , deleteString, Direction1D(..)
                     , setSuccess, setDone )
import XMonad.Prompt.Man
import XMonad.Prompt.Theme
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Window

import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Scratchpad
import XMonad.Util.Themes

-- setWMName fixes grey rectangle problem in Swing apps
-- takeTopFocus fixes being unable to click a text field to get focus in Swing apps.
-- Requires JRE6, so far it doesn't work under 7.
-- myStartupHook = setWMName "LG3D"

myModMask    = mod4Mask

myWorkspaces = ["1-emacs","2-shell","3-web","4-fm","5","6","7","8-ssh","9-mail"]

myManageHook = scratchpadManageHookDefault <+>composeAll (
    [ manageHook kde4Config
    , className =? "Tilda"             --> doFloat
    , className =? "Guake.py"          --> doFloat
    , className =? "Yakuake"           --> doFloat
    , className =? "Unity-2d-panel"    --> doIgnore
    , className =? "Unity-2d-shell"    --> doIgnore
    , className =? "Unity-2d-launcher" --> doIgnore
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore
    , className =? "MPlayer"           --> doFloat
    , className =? "Gimp"              --> doFloat
    , className =? "Plasma"            --> doFloat
    , className =? "Plasma-desktop"    --> doFloat
    , className =? "Knotes"            --> doFloat
    , className =? "Klipper"           --> doFloat
    , className =? "XCalc"             --> doFloat
    , className =? "emulator-arm"      --> doFloat
    , className =? "Dolphin"           --> doShift "4-fm"
    , className =? "chromium-browser"  --> doShift "3-web"
    ])

myLayout = smartBorders $ showWName' mySWNConfig $ desktopLayoutModifiers (tiled ||| Mirror tiled ||| tabbed shrinkText myTabConfig |||  Full)
  where
     tiled       = Tall nmaster delta ratio
     nmaster     = 1
     ratio       = 1/2
     delta       = 3/100
     mirrorTiled = Mirror tiled


myLogHook =  do
     -- fadeInactiveLogHook fadeAmount      -- Requires xcompmgr or similar
     -- updatePointer (Relative 0.5 0.5)    -- Move cursor to newly focused windows.
     logHook kde4Config>> takeTopFocus
     --where
     -- fadeAmount = 0.8

myBgColor             = "#000000"
myFgColor             = "#CC5500"
myHighlightedBgColor  = myBgColor
myHighlightedFgColor  = "#FFA000"
myCurrentWsBgColor    = myHighlightedBgColor
myActiveBorderColor   = myHighlightedFgColor
myInactiveBorderColor = "#d3d3d3"

myTabConfig = defaultTheme {
    activeBorderColor        = myBgColor, --myHighlightedFgColor,
    activeTextColor          = myHighlightedFgColor,
    activeColor              = myBgColor,
    inactiveBorderColor      = myBgColor,
    inactiveTextColor        = "#EEEEEE",
    inactiveColor            = myBgColor,
    decoHeight               = 14
}

mySWNConfig = defaultSWNConfig {
                swn_color   = myActiveBorderColor
              , swn_fade    = 2.0
              , swn_bgcolor = myInactiveBorderColor}

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig
                { bgColor               = myBgColor
                , fgColor               = myFgColor
                , bgHLight              = myHighlightedBgColor
                , fgHLight              = myHighlightedFgColor
                , position              = Top
                , promptBorderWidth     = 0
                }

main = do
  xmonad $ kde4Config {
               workspaces         = myWorkspaces
             , logHook            = myLogHook
             , manageHook         = myManageHook
             -- , startupHook        = myStartupHook
             , borderWidth        = 2
             , modMask            = myModMask
             , layoutHook         = myLayout
             , normalBorderColor  = myInactiveBorderColor
             , focusedBorderColor = "#ff4500"
             } `additionalKeys` keys'
      where
        keys' =  [ ((myModMask , xK_Return),               dwmpromote)
                 , ((myModMask .|. shiftMask, xK_Return),  spawn "konsole")
                 , ((myModMask .|. shiftMask, xK_z),       spawn "/usr/lib/kde4/libexec/kscreenlocker --forcelock")
                 , ((mod1Mask, xK_F4),                     kill)

                 , ((myModMask, xK_F1),                manPrompt myXPConfig)

                 , ((myModMask, xK_u),                 sendMessage $ ToggleStrut U)
                 , ((myModMask, xK_b),                 sendMessage $ ToggleStrut D)

                 , ((myModMask, xK_g),                 windowPromptGoto myXPConfig { autoComplete = Just 500000 } )
                 , ((myModMask .|. shiftMask, xK_g),   windowPromptBring myXPConfig { autoComplete = Just 500000 } )
                 , ((myModMask, xK_s),                 goToSelected defaultGSConfig)
                 , ((myModMask, xK_o ),                windowMenu)

                 , ((myModMask .|. controlMask, xK_w), swapPrevScreen)
                 , ((myModMask .|. controlMask, xK_e), swapNextScreen)

                 , ((myModMask, xK_z             ), warpToWindow (0.5) (0.5))
                 , ((myModMask .|. mod1Mask, xK_w), warpToScreen 0 (0.5) (0.5))
                 , ((myModMask .|. mod1Mask, xK_e), warpToScreen 1 (0.5) (0.5))
                 , ((myModMask .|. mod1Mask, xK_r), warpToScreen 2 (0.5) (0.5))

                 , ((myModMask .|. shiftMask, xK_r), spawn "dmenu_run -nb '#000000' -nf '#DCDCCC' -sb '#000000' -sf '#CC5500'")
                 , ((myModMask, xK_r), runOrRaisePrompt myXPConfig)

                 , ((myModMask, xK_F2), spawn "~/bin/xmenud.py")
                 ]
                 ++
                 [((m .|. myModMask, k), windows $ f i) -- Don't use Greedy view
                      | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
                      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
