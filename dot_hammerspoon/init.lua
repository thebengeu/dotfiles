hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)
hs.fnutils.ieach(hs.application.runningApplications(), function(app)
  print(app:bundleID())
end)

function launchOrFocusByBundleID(bundleID)
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
  launchOrFocusByBundleID("com.microsoft.edgemac.Beta")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "4",
  launchOrFocusByBundleID(
    "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj"
  )
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "5",
  launchOrFocusByBundleID("md.obsidian")
)
hs.hotkey.bind(
  { "ctrl", "command", "shift" },
  "6",
  launchOrFocusByBundleID("com.spotify.client")
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
  launchOrFocusByBundleID("com.github.wez.wezterm")
)

hs.keycodes.inputSourceChanged(hs.reload)
