-- -*- mode: haskell; -*-

-- TODO:
-- * Take a look at https://github.com/davidbeckingsale/xmonad-config/blob/master/xmonad.hs
-- * Decide on dzen/conky/xmobar etc.
--   http://dzen.geekmode.org/dwiki/doku.php?id=dzen:dzen-and-xmonad
-- * Investigate urgencyhook
-- * Use zenburn like colors

import System.IO

import XMonad hiding ( (|||) )

import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS
import XMonad.Actions.DwmPromote
import XMonad.Actions.GridSelect
import XMonad.Actions.WindowMenu
import XMonad.Actions.UpdatePointer

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName

import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.ShowWName

import XMonad.Prompt
import XMonad.Prompt.AppLauncher as AL
import XMonad.Prompt.Man
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Prompt.Window

import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Scratchpad
import XMonad.Util.WorkspaceCompare

scratchpads = [
      NS "htop" "xterm -name htop -e htop" (title =? "htop") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
    , NS "nautilus" "Nautilus" (className =? "Nautilus") (nonFloating)
    ] where role = stringProperty "WM_WINDOW_ROLE"

myManageHook = namedScratchpadManageHook scratchpads <+> scratchpadManageHookDefault
               <+> (composeAll . concat $ [[
                                     resource   =? "Do"           --> doIgnore
                                   , resource  =? "gnome-do"     --> doIgnore
                                   , className =? "Gimp"         --> doFloat
                                   , className =? "MPlayer"      --> doFloat
                                   , className =? "Vncviewer"    --> doFloat
                                   , className =? "stalonetray"  --> doIgnore
                                   , className =? "trayer"       --> doIgnore
                                   ]])

myWorkSpaces = [" 1-office ", " 2-emacs " ," 3-shell ", " 4-web ", " 5-fm ", " 6 ", " 7 ", " 8 ", " 9-keep "]


-- myLogHook h = do
--   dynamicLogWithPP $ oxyPP h

-- oxyPP :: Handle -> PP
-- oxyPP h = defaultPP {
--             ppOutput = hPutStrLn h
--           , ppWsSep = ""
--           , ppCurrent = xmobarColor myCurrentWsFgColor myCurrentWsBgColor
--           , ppVisible = xmobarColor myVisibleWsFgColor myVisibleWsBgColor
--           , ppHidden = xmobarColor myHiddenWsFgColor ""
--           , ppHiddenNoWindows = xmobarColor myHiddenEmptyWsFgColor ""
--           , ppUrgent = xmobarColor "" myUrgentWsBgColor
--           , ppSort = getSortByTag --getSortByXineramaRule
--           --             , ppSort = getSortByXineramaPhysicalRule
--           , ppTitle = xmobarColor myTitleFgColor myBgColor . shorten 120
--           }


myStartupHook = setWMName "LG3D"   -- Workaround for Java grey screen issues.

myModMask = mod4Mask               -- Use Windoze key.

myFont = "Inconsolata-10"

myFgColor = "#DCDCCC"
myBgColor = "#3f3f3f"
myHighlightedFgColor = myFgColor
myHighlightedBgColor = "#7F9F7F"
myActiveBorderColor = myCurrentWsBgColor
myInactiveBorderColor = "#262626"
myCurrentWsFgColor = myHighlightedFgColor
myCurrentWsBgColor = myHighlightedBgColor
myVisibleWsFgColor = myFgColor
myVisibleWsBgColor = "#506070"
myHiddenWsFgColor = myHighlightedFgColor
myHiddenEmptyWsFgColor = "#8F8F8F"
myUrgentWsBgColor = "#DCA3A3"
myTitleFgColor = myFgColor
myUrgencyHintFgColor = "red"
myUrgencyHintBgColor = "blue"

myLayout = smartBorders $ avoidStruts $ named "tile" tiled ||| named "mTile" mirrorTiled ||| noBorders Full
  where
     tiled       = Tall nmaster delta ratio
     nmaster     = 1
     ratio       = 1/2
     delta       = 3/100
     mirrorTiled = Mirror tiled


-- Configure showWName
mySWNConfig = defaultSWNConfig {
                swn_color   = myFgColor
              , swn_bgcolor = myBgColor}


main = do
--  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmonad/xmobar"
  conf <- dzen defaultConfig
  xmonad $ conf {
               manageHook         = manageDocks <+> myManageHook <+> manageHook defaultConfig
             , layoutHook         = showWName' mySWNConfig $ myLayout
             , workspaces         = myWorkSpaces
             -- , logHook            = myLogHook
             --                        >> updatePointer (Relative 0.5 0.5)
             , startupHook        = myStartupHook
             , borderWidth        = 2
             , modMask            = myModMask
             , normalBorderColor  = myInactiveBorderColor
             , focusedBorderColor = myActiveBorderColor
             } `additionalKeys` keys'
       where
         keys' =  [ ((myModMask , xK_Return),               dwmpromote)
                  , ((myModMask .|. shiftMask, xK_Return),  spawn "xterm")

                  , ((myModMask .|. shiftMask, xK_z),       spawn "gnome-screensaver-command -l")

                  -- Print Screen - Interactively select window or rectangle
                  , ((myModMask, xK_Print),                 spawn "sleep 0.2;scrot -d2 -s 'Zshot-%Y%m%d-%H.%M.%S.png' -e 'display $f'")

                  -- Print Screen - Current screen
                  , ((myModMask .|. shiftMask, xK_Print),   spawn "sleep 0.2;scrot -d2 'Zshot-%Y%m%d-%H.%M.%S.png' -e 'display $f'")

                  -- Print Screen - All screens
                  , ((myModMask .|. controlMask, xK_Print), spawn "sleep 0.2;scrot -d2 -m 'Zshot-%Y%m%d-%H.%M.%S.png' -e 'display $f'")

                  , ((myModMask, xK_F1),                manPrompt defaultXPConfig)
                  , ((myModMask, xK_g),                 windowPromptGoto defaultXPConfig { autoComplete = Just 500000 } )
                  , ((myModMask .|. shiftMask, xK_g),   windowPromptBring defaultXPConfig { autoComplete = Just 500000 } )
                  , ((myModMask, xK_s),                 goToSelected defaultGSConfig)
                  , ((myModMask, xK_o ),                windowMenu)

                  , ((myModMask, xK_p),                 spawn "dmenu_run -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'")
                  , ((myModMask, xK_F8),                scratchpadSpawnAction defaultConfig)
                  , ((myModMask, xK_F9),                namedScratchpadAction scratchpads "htop")
                  , ((myModMask, xK_F10),               namedScratchpadAction scratchpads "nautilus")

                  , ((myModMask, xK_b),                 sendMessage ToggleStruts)
                  , ((mod1Mask, xK_F4),                 kill)

                  , ((myModMask, xK_Left),              prevWS)
                  , ((myModMask, xK_Right),             nextWS)

           ]
