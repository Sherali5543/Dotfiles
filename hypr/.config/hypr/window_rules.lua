hl.window_rule({
  name = "firefox-library-float",

  match = {
    class = "firefox",
    title = "Library"
  },

  float = true,
  center = true,
  size = { 900, 600 }
})

hl.window_rule({
  name = "steam-settings-float",

  match = {
    class = "steam",
    title = "negative:^(Steam)$"
  },

  float = true,
  center = true,
  size = { 900, 900 }
})

hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },

  suppress_event = "maximize"
})

hl.window_rule({
  name = "fix-xwayland-drags",
  match = {
    class = "^$",
    title = "^$",
    xwayland = true,
    float = true,
    fullscreen = false,
    pin = false,
  },

  no_focus = true
})

hl.window_rule({
  name = "move-hyprland-run",

  match = { class = "hyprland-run" },

  move = { 20, "monitor_h - 120" },
  float = true,
})

-- Game rules 
hl.window_rule({
  name = "Battle-net-float",
  match = {
    class = "^(steam_app_.*)$",
    title = "^(Battle.net)$"
  },
  float = true
})

hl.window_rule({
  name = "Starcraft 2 float",
  match = {
    class = "^(steam_app_.*)$",
    title = "^(StarCraft II)$"
  },
  float = true,
  maximize = true,
  focus_on_activate = true
})

