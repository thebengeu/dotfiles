hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.application.enableSpotlightForNameSearches(true)
hs.fnutils.ieach(hs.application.runningApplications(),
                function(app) print(app:bundleID()) end)

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

hs.hotkey.bind({"ctrl", "command", "shift"}, "a",
               launchOrFocusByBundleID("it.bloop.airmail2"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "c",
               launchOrFocusByBundleID("com.google.Chrome"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "f",
               launchOrFocusByBundleID("org.mozilla.firefox"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "g",
               launchOrFocusByBundleID("ru.keepcoder.Telegram"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "h",
               launchOrFocusByBundleID("com.google.chat"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "i",
               launchOrFocusByBundleID("com.googlecode.iterm2"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "m",
               launchOrFocusByBundleID("com.mailplaneapp.Mailplane3"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "t",
               launchOrFocusByBundleID("com.culturedcode.ThingsMac"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "v",
               launchOrFocusByBundleID("com.microsoft.VSCode"))
hs.hotkey.bind({"ctrl", "command", "shift"}, "w",
               launchOrFocusByBundleID("pro.writer.mac"))

hs.keycodes.inputSourceChanged(hs.reload)
