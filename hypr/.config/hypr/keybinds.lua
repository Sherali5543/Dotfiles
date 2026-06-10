require('programs')

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",

    follow_mouse = true,

    sensitivity = 0, --# -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = true
    }
  }
})

-- Gestures and keybinds
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-- General utility
hl.bind(MainMod .. " + RETURN", hl.dsp.exec_cmd(Terminal))
hl.bind(MainMod .. " + Q", hl.dsp.window.close('activewindow'))
hl.bind(MainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(MainMod .. " + E", hl.dsp.exec_cmd(Filemanager))
hl.bind(MainMod .. " + V", hl.dsp.window.float({ action = 'toggle', window = 'activewindow' }))
hl.bind(MainMod .. " + F", hl.dsp.window.fullscreen({ mode = 'maximized', action = 'toggle', window = 'activewindow' }))
hl.bind(MainMod .. " + P", hl.dsp.window.pseudo({ action = 'toggle', window = 'activewindow' }))
hl.bind(MainMod .. " + CTRL + P", hl.dsp.window.pin({ wkndow = 'activewindow' }))
hl.bind(MainMod .. " + T", hl.dsp.layout('togglesplit'))
hl.bind(MainMod .. " + SPACE", hl.dsp.exec_cmd("pkill " .. Launcher .. " || " .. Launcher ))

-- # Move focus with MainMod + vim controls
hl.bind(MainMod .. " + H", hl.dsp.focus({ direction = 'l' }))
hl.bind(MainMod .. " + L", hl.dsp.focus({ direction = 'r' }))
hl.bind(MainMod .. " + K", hl.dsp.focus({ direction = 'u' }))
hl.bind(MainMod .. " + J", hl.dsp.focus({ direction = 'd' }))

-- # Switch workspaces with MainMod + [0-9]
-- # Move with active window to a workspace with MainMod + SHIFT + [0-9]
-- # Move active window to a workspace with MainMod + SHIFT + ALT + [0-9]
for i = 1, 10 do
  local key = i % 10                                                                            -- 10 binds to 0
  hl.bind(MainMod .. " + " .. key, hl.dsp.focus({ workspace = i, on_current_monitor = false })) -- on_current_monitor = true causes back_and_forth to stop working
  hl.bind(MainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = true, window = 'activewindow' }))
  hl.bind(MainMod .. " + CTRL + SHIFT + " .. key,
    hl.dsp.window.move({ workspace = i, follow = false, window = 'activewindow' }))
end

-- # Example special workspace (scratchpad)
hl.bind(MainMod .. " + S", hl.dsp.workspace.toggle_special('scratchpad'))
hl.bind(MainMod .. " + SHIFT + S",
  hl.dsp.window.move({ workspace = 'special:scratchpad', follow = true, window = 'activewindow' }))
hl.bind(MainMod .. " + CTRL + SHIFT + S",
  hl.dsp.window.move({ workspace = 'special:scratchpad', follow = true, window = 'activewindow' }))

-- # Scroll through existing workspaces with MainMod + scroll or "," "."
hl.bind(MainMod .. " + mouse_down", hl.dsp.focus({ workspace = '+1', on_current_monitor = true }))
hl.bind(MainMod .. " + mouse_up", hl.dsp.focus({ workspace = '-1', on_current_monitor = true }))
hl.bind(MainMod .. " + PERIOD", hl.dsp.focus({ workspace = '+1', on_current_monitor = true }))
hl.bind(MainMod .. " + COMMA", hl.dsp.focus({ workspace = '-1', on_current_monitor = true }))

-- Move/resize windows with MainMod + LMB/RMB and dragging
hl.bind(MainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
  { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- # Screenshot
hl.bind(MainMod .. " + SHIFT + P", hl.dsp.exec_cmd('grim -g "$(slurp -w 0)" ~/Pictures/shot-$date( +%s).png'))
hl.bind(MainMod .. " + CTRL + SHIFT + P", hl.dsp.exec_cmd('grim -g "$(slurp -w 0)" - | wl-copy'))


-- Requires https://github.com/Shanu-Kumawat/quickshell-overview 
hl.bind(MainMod .. " + TAB", hl.dsp.exec_cmd('qs ipc -c overview call overview toggle'))
