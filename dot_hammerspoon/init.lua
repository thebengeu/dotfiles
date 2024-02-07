local WEZTERM_BUNDLE_ID = "com.github.wez.wezterm"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

local switcher_window_filter = hs.window.filter.new()
switcher_window_filter:rejectApp("1Password")

for key, bundle_id_and_args in pairs({
  [","] = {
    bundle_id = "com.apple.systempreferences",
    open = "/System/Library/PreferencePanes/Displays.prefPane",
  },
  a = "com.readdle.SparkDesktop",
  b = "Safari",
  c = "Google Chrome",
  d = "com.hnc.Discord",
  e = "com.microsoft.edgemac",
  f = "com.microsoft.edgemac.app.nkbljeindhmekmppbpgebpjebkjbmfaj",
  g = "ru.keepcoder.Telegram",
  h = "com.spotify.client",
  j = "com.jetbrains.pycharm",
  k = "com.kapeli.dashdoc",
  m = "com.mimestream.Mimestream",
  n = "notion.id",
  o = "md.obsidian",
  p = {
    args = "~/thebengeu/cheatsheet/README.md",
    bundle_id = "com.brettterpstra.marked2",
  },
  r = "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk",
  s = "com.tinyspeck.slackmacgap",
  t = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  v = "com.neovide.neovide",
  w = WEZTERM_BUNDLE_ID,
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

for _, mods_and_key in ipairs({
  {
    "com.todoist.mac.Todoist",
    { "cmd", "ctrl" },
    "a",
    true,
    function(hotkey, mods, key, bundle_id)
      local found_add_task_window_or_timeout
      local timeout_timer

      local keystroke_timer = hs.timer.doEvery(1, function()
        hs.eventtap.keyStroke(mods, key)

        local app = hs.application(bundle_id)

        if not app then
          return
        end

        for _, win in ipairs(app:allWindows()) do
          if win:size().w == 640 then
            found_add_task_window_or_timeout()
          else
            win:close()
          end
        end
      end)

      found_add_task_window_or_timeout = function()
        keystroke_timer:stop()
        timeout_timer:stop()
        hotkey:enable()
      end

      timeout_timer = hs.timer.doAfter(5, found_add_task_window_or_timeout)
    end,
  },
  {
    "com.kapeli.dashdoc",
    { "ctrl", "option", "shift" },
    "l",
    true,
    function(hotkey)
      hotkey:enable()
    end,
  },
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
        after_launch(hotkey, mods, key, bundle_id)
        return
      end
    elseif set_frontmost then
      app:setFrontmost()
    end

    hs.eventtap.keyStroke(mods, key)
    hotkey:enable()
  end)
end

for key, command in pairs({
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
