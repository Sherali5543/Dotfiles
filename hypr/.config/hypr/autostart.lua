-- #################
-- ### AUTOSTART ###
-- #################
hl.on("hyprland.start", function()
  hl.exec_cmd("quickshell")
  hl.exec_cmd("qs -c overview")
end)
