hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)
hs.fnutils.ieach(hs.application.runningApplications(), function(app)
  print(app:bundleID())
end)

local launchOrFocusByBundleID = function(bundleID)
  return function()
    local app = hs.application(bundleID)
    if app and app:isFrontmost() then
      app:hide()
    else
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  end
end

for key, bundle_id in pairs({
  c = "com.google.Chrome",
  d = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  e = "com.microsoft.edgemac",
  m = "com.readdle.SparkDesktop",
  n = "notion.id",
  o = "md.obsidian",
  p = "com.brettterpstra.marked2",
  r = "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk",
  s = "com.tinyspeck.slackmacgap",
  t = "ru.keepcoder.Telegram",
  v = "com.neovide.neovide",
  w = "com.github.wez.wezterm",
}) do
  hs.hotkey.bind(
    { "ctrl", "option", "shift" },
    key,
    launchOrFocusByBundleID(bundle_id)
  )
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
