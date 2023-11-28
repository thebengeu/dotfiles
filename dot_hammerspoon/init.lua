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

hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "1",
  launchOrFocusByBundleID("com.google.Chrome")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "2",
  launchOrFocusByBundleID("com.microsoft.edgemac")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "3",
  launchOrFocusByBundleID("com.readdle.SparkDesktop")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "4",
  launchOrFocusByBundleID("notion.id")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "5",
  launchOrFocusByBundleID("md.obsidian")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "6",
  launchOrFocusByBundleID("com.tinyspeck.slackmacgap")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "7",
  launchOrFocusByBundleID("ru.keepcoder.Telegram")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "8",
  launchOrFocusByBundleID(
    "com.microsoft.edgemac.app.elldfnmogicegdcphgljaoaklkpcnbnn"
  )
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "9",
  launchOrFocusByBundleID("com.microsoft.VSCode")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "0",
  launchOrFocusByBundleID("com.github.wez.wezterm")
)

hs.keycodes.inputSourceChanged(hs.reload)
