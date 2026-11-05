01-wallpaper-mode|settings set wallpaper.mode shell
02-wallpaper-path|!qs -p "$SHELL_DIR" ipc call settings set wallpaper.path "$SHELL_DIR/tools/ci/assets/wallpaper.jpg"
03-maximum|settings set appearance.level 4
04-pin|settings set startMenu.initialPinned foot
05-place|settings set weather.locationMode manual
06-place-name|settings set weather.manualPlaceName Davao
07-latitude|settings set weather.manualLatitude 7.07
08-longitude|settings set weather.manualLongitude 125.61
11-start-dark|start toggle
12-close|start toggle
13-light|settings set theme.mode light
14-start-light|start toggle
15-close|start toggle
16-quick-settings-light|quickSettings toggle
17-close|quickSettings toggle
18-dark|settings set theme.mode dark
19-quick-settings|quickSettings toggle
20-close|quickSettings toggle
21-toast-one|!notify-send -a Mail "Ada Lovelace" "The build is green. Lunch at noon?"
22-toast-two|!notify-send -a Calendar "Design review" "Starts in 10 minutes in Room 4"
23-notification-center|notifications toggle
24-close|notifications toggle
25-widgets|widgets toggle
26-close|widgets toggle
27-task-view|taskView toggle
28-close|taskView toggle
29-osd|audio volumeDown
30-settings|settings open
31-lock-enable|settings set features.lockScreen.enabled true
32-lock|session lock
