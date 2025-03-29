local wf = hs.window.filter

local KITTY_BUNDLE_ID = "net.kovidgoyal.kitty"
local WEZTERM_BUNDLE_ID = "com.github.wez.wezterm"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

local switcher_window_filter = hs.window.filter.new()
switcher_window_filter:rejectApp("1Password")
switcher_window_filter:rejectApp("Microsoft Edge")

local function setup_app_hotkey(bundle_id_and_args, key, modifiers)
  local bundle_id = bundle_id_and_args.bundle_id or bundle_id_and_args

  local app_name = hs.application.nameForBundleID(bundle_id) or bundle_id
  switcher_window_filter:rejectApp(app_name)

  hs.hotkey.bind(modifiers, key, function()
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
  -- ["'"] = "Rectangle Pro Layout 0",
  [","] = {
    bundle_id = "com.apple.systempreferences",
    open = "/System/Library/PreferencePanes/Displays.prefPane",
  },
  -- ["."] = "",
  ["/"] = "com.flexibits.fantastical2.mac",
  a = "com.aptakube.Aptakube",
  b = "md.obsidian",
  c = "Google Chrome",
  d = "com.kapeli.dash-setapp",
  e = "com.microsoft.edgemac",
  f = "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj",
  g = "com.hahainteractive.GoodTask3Mac",
  h = "net.whatsapp.WhatsApp",
  i = "com.openai.chat",
  j = "com.jetbrains.pycharm",
  k = KITTY_BUNDLE_ID,
  l = "com.linear",
  m = "com.mimestream.Mimestream",
  n = "notion.id",
  o = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  p = "co.noteplan.NotePlan-setapp",
  q = "com.readdle.SparkDesktop-setapp",
  r = "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk",
  s = "com.tinyspeck.slackmacgap",
  t = "ru.keepcoder.Telegram",
  u = "com.todesktop.230313mzl4w4u92",
  v = "com.neovide.neovide",
  w = WEZTERM_BUNDLE_ID,
  x = "org.mozilla.firefox",
  y = "com.spotify.client",
  z = {
    args = "~/thebengeu/qmk_userspace/keymap.svg",
    bundle_id = "com.wolfrosch.Gapplin",
  },
}) do
  setup_app_hotkey(bundle_id_and_args, key, { "ctrl", "option", "shift" })
end

for key, bundle_id_and_args in pairs({
  -- ["."] = "unwrap-clipboard",
  c = "com.apple.podcasts",
  d = "com.hnc.Discord",
  e = "com.endel.endel",
  f = "com.apple.finder",
  -- g = "GhostText",
  h = "org.hammerspoon.Hammerspoon",
  -- j = "Colab local URL",
  k = "org.pqrs.Karabiner-EventViewer",
  -- l = "Colab remote URL",
  m = {
    args = "~/thebengeu/cheatsheet/README.md",
    bundle_id = "com.brettterpstra.marked2",
  },
  o = "com.bloombuilt.dayone-mac",
  p = "com.apple.Preview",
  -- q = "format-clipboard SQL",
  s = "dev.kdrag0n.MacVirt",
  v = "com.microsoft.VSCode",
  -- w = "format-clipboard Python",
  x = "com.microsoft.Excel",
}) do
  setup_app_hotkey(bundle_id_and_args, key, { "ctrl", "shift", "cmd" })
end

for key, bundle_id_and_args in pairs({
  [","] = {
    bundle_id = "com.apple.systempreferences",
    open = "/System/Library/PreferencePanes/Displays.prefPane",
  },
  ["/"] = { "com.flexibits.fantastical2.mac" },
  a = { "com.aptakube.Aptakube" },
  b = { "md.obsidian", "p", { "cmd", "shift" } },
  c = { "Google Chrome", "l" },
  e = { "com.microsoft.edgemac", "l" },
  f = { "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj", "/", {} },
  g = { "com.hahainteractive.GoodTask3Mac" },
  h = { "net.whatsapp.WhatsApp" },
  i = { "com.openai.chat" },
  j = { "com.jetbrains.pycharm", "o", { "cmd", "shift" } },
  k = { KITTY_BUNDLE_ID, "h", { "ctrl", "shift" } },
  l = { "com.linear", "/", {} },
  m = { "com.mimestream.Mimestream", "f", { "cmd", "option" } },
  n = { "notion.id", "k" },
  o = { "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb", "k" },
  p = { "co.noteplan.NotePlan-setapp", "f", { "cmd", "shift" } },
  q = { "com.readdle.SparkDesktop-setapp" },
  r = { "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk" },
  s = { "com.tinyspeck.slackmacgap", "k" },
  t = { "ru.keepcoder.Telegram", "k" },
  u = { "com.todesktop.230313mzl4w4u92", "p" },
  v = { "com.neovide.neovide", "p" },
  w = { WEZTERM_BUNDLE_ID },
  x = { "org.mozilla.firefox", "l" },
  y = { "com.spotify.client", "k" },
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
  local bundle_id, mods, key, skip_set_frontmost, after_launch =
    table.unpack(mods_and_key)
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
    elseif not skip_set_frontmost then
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
  w = "format-clipboard Python",
}) do
  hs.hotkey.bind({ "ctrl", "cmd", "shift" }, key, function()
    local clipboardContents = hs.pasteboard.getContents()
    hs.eventtap.keyStroke({ "cmd" }, "a")
    hs.eventtap.keyStroke({ "cmd" }, "c")
    local output = hs.execute(command, true)
    hs.eventtap.keyStroke({ "cmd" }, "v")
    hs.pasteboard.setContents(clipboardContents)

    print(output)
  end)
end

hs.hotkey.bind({ "ctrl", "shift", "cmd" }, "g", function()
  local bundle_id = "com.neovide.neovide"

  if not hs.application(bundle_id) then
    os.execute(
      "open -g -b " .. bundle_id .. " --args -- ~/.local/share/chezmoi"
    )
  end

  local window_filter = wf.new({ "Neovide" })
  window_filter:subscribe(wf.windowCreated, function()
    window_filter:unsubscribeAll()
    hs.eventtap.keyStroke({ "cmd", "shift" }, "k")
    hs.application(bundle_id):setFrontmost(true)
  end, true)
end)

for key, command in pairs({
  j = "cat /tmp/jupyter.log | ~/.local/bin/jn-url",
  l = "ssh hc -C 'cat /tmp/jupyter.log | jn-url 8888 8889'",
}) do
  hs.hotkey.bind({ "ctrl", "shift", "cmd" }, key, function()
    hs.eventtap.keyStroke({ "cmd" }, "a")
    local output = hs.execute(command)
    hs.eventtap.keyStrokes(output)
    hs.timer.usleep(10000)
    hs.eventtap.keyStroke({}, "tab")
    hs.eventtap.keyStroke({}, "tab")
    hs.eventtap.keyStroke({}, "return")
  end)
end

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
