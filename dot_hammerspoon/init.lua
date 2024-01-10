hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

for key, bundle_id_and_args in pairs({
  c = "com.google.Chrome",
  d = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  e = "com.microsoft.edgemac",
  m = "com.readdle.SparkDesktop",
  n = "notion.id",
  o = "md.obsidian",
  p = { "com.brettterpstra.marked2", "~/thebengeu/cheatsheet/README.md" },
  r = "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk",
  s = "com.tinyspeck.slackmacgap",
  t = "ru.keepcoder.Telegram",
  v = "com.neovide.neovide",
  w = "com.github.wez.wezterm",
}) do
  local bundleID = bundle_id_and_args[1] or bundle_id_and_args

  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    local app = hs.application(bundleID)

    if app then
      if app:isFrontmost() then
        app:hide()
      else
        app:setFrontmost()
      end
    else
      local args = bundle_id_and_args[2]

      if args then
        os.execute("open -b " .. bundleID .. " " .. args)
      else
        hs.application.open(bundleID)
      end
    end
  end)
end

for key, command in pairs({
  f = "format-clipboard",
  q = "format-clipboard SQL",
  y = "format-clipboard Python",
}) do
  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    hs.eventtap.keyStroke({ "cmd" }, "c")
    local output = hs.execute(command, true)
    hs.eventtap.keyStroke({ "cmd" }, "v")

    print(output)
  end)
end

hs.keycodes.inputSourceChanged(hs.reload)
