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
  { "ctrl", "option", "shift" },
  "c",
  launchOrFocusByBundleID("com.google.Chrome")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "d",
  launchOrFocusByBundleID(
    "com.microsoft.edgemac.app.elldfnmogicegdcphgljaoaklkpcnbnn"
  )
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "e",
  launchOrFocusByBundleID("com.microsoft.edgemac")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "m",
  launchOrFocusByBundleID("com.readdle.SparkDesktop")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "n",
  launchOrFocusByBundleID("notion.id")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "o",
  launchOrFocusByBundleID("md.obsidian")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "s",
  launchOrFocusByBundleID("com.tinyspeck.slackmacgap")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "t",
  launchOrFocusByBundleID("ru.keepcoder.Telegram")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "v",
  launchOrFocusByBundleID("com.neovide.neovide")
)
hs.hotkey.bind(
  { "ctrl", "option", "shift" },
  "w",
  launchOrFocusByBundleID("com.github.wez.wezterm")
)

hs.keycodes.inputSourceChanged(hs.reload)
