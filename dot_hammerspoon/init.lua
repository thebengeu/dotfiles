local wf = hs.window.filter

local KITTY_BUNDLE_ID = "net.kovidgoyal.kitty"
local WEZTERM_BUNDLE_ID = "com.github.wez.wezterm"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

local switcher_window_filter = hs.window.filter.new()
switcher_window_filter:rejectApp("1Password")
switcher_window_filter:rejectApp("Microsoft Edge")

for key, bundle_id_and_args in pairs({
  -- ["'"] = "Rectangle Pro Layout 0",
  [","] = {
    bundle_id = "com.apple.systempreferences",
    open = "/System/Library/PreferencePanes/Displays.prefPane",
  },
  -- ["."] = "unwrap-clipboard",
  ["/"] = "com.flexibits.fantastical2.mac",
  a = "net.whatsapp.WhatsApp",
  -- b = "BigQuery cell",
  c = "Google Chrome",
  d = "com.kapeli.dash-setapp",
  e = "com.microsoft.edgemac",
  f = "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj",
  g = "ru.keepcoder.Telegram",
  h = "com.spotify.client",
  i = "org.mozilla.firefox",
  j = "com.jetbrains.pycharm",
  k = KITTY_BUNDLE_ID,
  l = "com.linear",
  m = "com.mimestream.Mimestream",
  n = "notion.id",
  o = "md.obsidian",
  p = "com.readdle.SparkDesktop-setapp",
  -- q = "format-clipboard SQL",
  r = "com.apple.reminders",
  s = "com.tinyspeck.slackmacgap",
  t = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  u = "com.aptakube.Aptakube",
  v = "com.microsoft.VSCode",
  w = WEZTERM_BUNDLE_ID,
  x = {
    args = "~/thebengeu/cheatsheet/README.md",
    bundle_id = "com.brettterpstra.marked2",
  },
  -- y = "format-clipboard Python",
  z = {
    args = "~/thebengeu/qmk_userspace/keymap.svg",
    bundle_id = "com.wolfrosch.Gapplin",
  },
}) do
  local bundle_id = bundle_id_and_args.bundle_id or bundle_id_and_args

  local app_name = hs.application.nameForBundleID(bundle_id) or bundle_id
  switcher_window_filter:rejectApp(app_name)

  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    local app = hs.application(bundle_id)
    local args = bundle_id_and_args.args
    local open = bundle_id_and_args.open

    if app then
      if app:isFrontmost() then
        app:hide()
      else
        app:setFrontmost(true)
      end
    elseif args then
      os.execute("open -b " .. bundle_id .. " " .. args)
    elseif open then
      os.execute("open " .. open)
    else
      hs.application.open(bundle_id)
    end
  end)
end

for key, bundle_id_and_args in pairs({
  [","] = {
    bundle_id = "com.apple.systempreferences",
    open = "/System/Library/PreferencePanes/Displays.prefPane",
  },
  ["/"] = { "com.flexibits.fantastical2.mac" },
  a = { "net.whatsapp.WhatsApp" },
  c = { "Google Chrome", "l" },
  e = { "com.microsoft.edgemac", "l" },
  f = { "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj", "/", {} },
  g = { "ru.keepcoder.Telegram", "k" },
  h = { "com.spotify.client", "k" },
  i = { "org.mozilla.firefox", "l" },
  j = { "com.jetbrains.pycharm", "o", { "cmd", "shift" } },
  k = { KITTY_BUNDLE_ID, "h", { "ctrl", "shift" } },
  l = { "com.linear", "/", {} },
  m = { "com.mimestream.Mimestream", "f", { "cmd", "option" } },
  n = { "notion.id", "k" },
  o = { "md.obsidian", "p", { "cmd", "shift" } },
  p = { "com.readdle.SparkDesktop-setapp" },
  r = { "com.apple.reminders" },
  s = { "com.tinyspeck.slackmacgap", "k" },
  t = { "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb", "k" },
  u = { "com.aptakube.Aptakube" },
  v = { "com.microsoft.VSCode", "f", { "cmd", "shift" } },
  w = { WEZTERM_BUNDLE_ID },
  x = {
    args = "~/thebengeu/cheatsheet/README.md",
    bundle_id = "com.brettterpstra.marked2",
  },
}) do
  local bundle_id = bundle_id_and_args.bundle_id or bundle_id_and_args[1]
  local key_on_focus = bundle_id_and_args.key_on_focus
    or bundle_id_and_args[2]
    or "f"
  local mods_on_focus = bundle_id_and_args.mods
    or bundle_id_and_args[3]
    or { "cmd" }

  local app_name = hs.application.nameForBundleID(bundle_id) or bundle_id
  local on_window_focused_enabled = false

  local on_window_focused = function()
    if on_window_focused_enabled then
      on_window_focused_enabled = false

      hs.eventtap.keyStroke(mods_on_focus, key_on_focus)
    end
  end

  wf.new({ app_name }):subscribe(wf.windowFocused, on_window_focused)

  hs.hotkey.bind({ "ctrl", "option", "shift", "cmd" }, key, function()
    local app = hs.application(bundle_id)
    local args = bundle_id_and_args.args
    local open = bundle_id_and_args.open

    on_window_focused_enabled = true

    if app then
      if app:isFrontmost() then
        on_window_focused()
      else
        app:setFrontmost(true)
      end
    elseif args then
      os.execute("open -b " .. bundle_id .. " " .. args)
    elseif open then
      os.execute("open " .. open)
    else
      hs.application.open(bundle_id)
    end
  end)
end

for _, mods_and_key in ipairs({
  {
    "com.kapeli.dash-setapp",
    { "ctrl", "option", "shift", "cmd" },
    "d",
    true,
    function(hotkey)
      hotkey:enable()
    end,
  },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "1" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "2" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "3" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "4" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "5" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "6" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "7" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "8" },
  { KITTY_BUNDLE_ID, { "ctrl", "option", "shift", "cmd" }, "9" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "1" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "2" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "3" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "4" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "5" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "6" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "7" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "8" },
  { WEZTERM_BUNDLE_ID, { "ctrl", "option", "shift" }, "9" },
}) do
  local bundle_id = mods_and_key[1]
  local mods = mods_and_key[2]
  local key = mods_and_key[3]
  local set_frontmost = not mods_and_key[4]
  local after_launch = mods_and_key[5]

  local hotkey
  hotkey = hs.hotkey.bind(mods, key, function()
    hotkey:disable()

    local app = hs.application(bundle_id)

    if not app then
      hs.application.open(bundle_id, 10, true)

      if after_launch then
        after_launch(hotkey)
        return
      end
    elseif set_frontmost then
      app:setFrontmost()
    end

    hs.eventtap.keyStroke(mods, key)
    hotkey:enable()
  end)
end

hs.hotkey.bind({ "cmd", "ctrl" }, "a", function()
  hs.application.open(
    "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
    10,
    true
  )
  hs.eventtap.keyStroke({}, "q")
end)

for key, command in pairs({
  ["."] = "unwrap-clipboard",
  q = "format-clipboard SQL",
  y = "format-clipboard Python",
}) do
  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    local clipboardContents = hs.pasteboard.getContents()
    hs.eventtap.keyStroke({ "cmd" }, "a")
    hs.eventtap.keyStroke({ "cmd" }, "c")
    local output = hs.execute(command, true)
    hs.eventtap.keyStroke({ "cmd" }, "v")
    hs.pasteboard.setContents(clipboardContents)

    print(output)
  end)
end

hs.hotkey.bind({ "ctrl", "option", "shift" }, "b", function()
  hs.eventtap.keyStroke({ "cmd" }, "m")
  hs.eventtap.keyStrokes("b%%bigquery")
  hs.timer.usleep(10000)
  hs.eventtap.keyStroke({}, "return")
  hs.eventtap.keyStrokes("#@title ")
end)

hs.window.animationDuration = 0
hs.window.switcher.ui.showSelectedTitle = false
hs.window.switcher.ui.showTitles = false

local switcher = hs.window.switcher.new(switcher_window_filter)

hs.hotkey.bind("alt", "tab", function()
  switcher:next()
end)
hs.hotkey.bind("alt-shift", "tab", function()
  switcher:previous()
end)

hs.keycodes.inputSourceChanged(hs.reload)
