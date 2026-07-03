hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 5,

    border_size = 2,

    -- # https://wiki.hypr.land/Configuring/Variables/#variable-types for info about colors
    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(7100e5cc)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    -- # Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true,

    -- # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
    allow_tearing = false,

    layout = "dwindle"
  },

  decoration = {
    rounding = 10,
    rounding_power = 2,

    -- # Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 0.8,

    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    -- # https://wiki.hypr.land/Configuring/Variables/#blur
    blur = {
      enabled = true,
      size = 5,
      passes = 1,

      vibrancy = 0.1696
    }
  },

  misc = {
    force_default_wallpaper = -1,  --# Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = false, --# If true disables the random hyprland logo / anime girl background. :(
    focus_on_activate = true
  },

  dwindle = {
    preserve_split = true
  },

  master = {
    new_status = "master"
  },

  binds = {
    allow_workspace_cycles = true,
    workspace_back_and_forth = true,
    workspace_center_on = true,
    movefocus_cycles_fullscreen = true,
    window_direction_monitor_fallback = true,
  },
})
