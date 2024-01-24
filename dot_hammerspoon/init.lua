local wf = hs.window.filter

local WEZTERM_BUNDLE_ID = "com.github.wez.wezterm"

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

for key, bundle_id_and_args in pairs({
  c = "com.google.Chrome",
  d = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  e = "com.microsoft.edgemac",
  f = "Safari",
  h = "com.spotify.client",
  k = "com.kapeli.dashdoc",
  m = "com.readdle.SparkDesktop",
  n = "notion.id",
  o = "md.obsidian",
  p = { "com.brettterpstra.marked2", "~/thebengeu/cheatsheet/README.md" },
  r = "com.microsoft.edgemac.app.bndmnggfngpgmmijcogkkgglhalbpomk",
  s = "com.tinyspeck.slackmacgap",
  t = "ru.keepcoder.Telegram",
  v = "com.neovide.neovide",
  w = WEZTERM_BUNDLE_ID,
}) do
  local bundle_id = bundle_id_and_args[1] or bundle_id_and_args

  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    local app = hs.application(bundle_id)
    local args = bundle_id_and_args[2]

    if app and app:isFrontmost() then
      app:hide()
    elseif args then
      os.execute("open -b " .. bundle_id .. " " .. args)
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

hs.keycodes.inputSourceChanged(hs.reload)
