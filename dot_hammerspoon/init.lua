local wf = hs.window.filter

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)

for key, bundle_id_and_args in pairs({
  c = "com.google.Chrome",
  d = "com.microsoft.edgemac.app.knaiokfnmjjldlfhlioejgcompgenfhb",
  e = "com.microsoft.edgemac",
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
  w = "com.github.wez.wezterm",
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
    { "ctrl", "cmd" },
    "a",
    function(mods, key, hotkey)
      local timer = hs.timer.doEvery(1, function()
        hs.eventtap.keyStroke(mods, key)
      end)

      local wf_todoist
      wf_todoist = wf.new({ "Todoist" })
        :subscribe(wf.windowVisible, function(win)
          if win:size().w == 640 then
            timer:stop()
            wf_todoist:unsubscribeAll()
            hotkey:enable()
          else
            win:close()
          end
        end)
    end,
  },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "1" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "2" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "3" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "4" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "5" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "6" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "7" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "8" },
  { "com.github.wez.wezterm", { "ctrl", "shift" }, "9" },
}) do
  local bundle_id = mods_and_key[1]
  local mods = mods_and_key[2]
  local key = mods_and_key[3]
  local after_launch = mods_and_key[4]

  local hotkey
  hotkey = hs.hotkey.bind(mods, key, function()
    hotkey:disable()

    local app = hs.application(bundle_id)

    if app then
      app:setFrontmost()
    else
      hs.application.open(bundle_id, 10, true)

      if after_launch then
        after_launch(mods, key, hotkey)
        return
      end
    end

    hs.eventtap.keyStroke(mods, key)
    hotkey:enable()
  end)
end

for key, command in pairs({
  f = "format-clipboard",
  q = "format-clipboard SQL",
  y = "format-clipboard Python",
}) do
  hs.hotkey.bind({ "ctrl", "option", "shift" }, key, function()
    local clipboardContents = hs.pasteboard.getContents()
    hs.eventtap.keyStroke({ "cmd" }, "c")
    local output = hs.execute(command, true)
    hs.eventtap.keyStroke({ "cmd" }, "v")
    hs.pasteboard.setContents(clipboardContents)

    print(output)
  end)
end

hs.keycodes.inputSourceChanged(hs.reload)
