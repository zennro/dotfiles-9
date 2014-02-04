-- -*- mode: haskell; -*-
import XMonad

import qualified XMonad.StackSet as W

import XMonad.Actions.DwmPromote
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowMenu

import XMonad.Config.Gnome

import XMonad.Hooks.SetWMName

import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName

import XMonad.Prompt
import XMonad.Prompt.Man
import XMonad.Prompt.Window

import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Scratchpad

myStartupHook = setWMName "LG3D"   -- Workaround for Java grey screen issues.
myModMask     = mod4Mask           -- Use Windoze key.

scratchpads = [
      NS "htop" "xterm -name htop -e htop" (title =? "htop") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    , NS "nautilus" "Nautilus" (className =? "Nautilus") (nonFloating)
    ] where role = stringProperty "WM_WINDOW_ROLE"

myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myActiveBorderColor = myCurrentWsBgColor
myInactiveBorderColor = "#262626"
myHighlightedBgColor = "#7F9F7F"
myCurrentWsBgColor = myHighlightedBgColor

mySWNConfig = defaultSWNConfig {
                swn_color   = myFgColor
              , swn_bgcolor = myBgColor}

main = do
  xmonad $ gnomeConfig {
               startupHook        = myStartupHook
             , terminal           = "xterm"
             , borderWidth        = 2
             , modMask            = myModMask
             , layoutHook         = showWName' mySWNConfig $ smartBorders (layoutHook gnomeConfig)
             , normalBorderColor  = myInactiveBorderColor
             , focusedBorderColor = myActiveBorderColor
             } `additionalKeys` keys'
      where
        keys' =  [ ((myModMask , xK_Return),               dwmpromote)
                 , ((myModMask .|. shiftMask, xK_Return),  spawn "urxvt")
                 , ((myModMask .|. shiftMask, xK_z),       spawn "gnome-screensaver-command -l")
                 , ((mod1Mask, xK_F4),                     kill)

                 , ((myModMask, xK_F1),                manPrompt defaultXPConfig)

                 , ((myModMask, xK_g),                 windowPromptGoto defaultXPConfig { autoComplete = Just 500000 } )
                 , ((myModMask .|. shiftMask, xK_g),   windowPromptBring defaultXPConfig { autoComplete = Just 500000 } )
                 , ((myModMask, xK_s),                 goToSelected defaultGSConfig)
                 , ((myModMask, xK_o ),                windowMenu)

                 , ((myModMask, xK_F8),                scratchpadSpawnAction defaultConfig)
                 , ((myModMask, xK_F9),                namedScratchpadAction scratchpads "htop")
                 , ((myModMask, xK_F10),               namedScratchpadAction scratchpads "nautilus")

                 -- Without this Gnome sometimes swallows <WIN>p and turns off second monitor.
                 , ((myModMask, xK_p), spawn "dmenu_run -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'")
                 ]
