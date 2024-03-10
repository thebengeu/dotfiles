local common = require("common")
local wezterm = require("wezterm")

local M = {}

function M.apply_to_config(config)
  if wezterm.GLOBAL.is_remote == nil then
    local _, stdout, _ = wezterm.run_child_process({ "ipconfig" })
    wezterm.GLOBAL.is_remote = not stdout:match("192%.168%.50%.1")
  end

  config.ssh_domains = common.map(
    wezterm.default_ssh_domains(),
    function(domain)
      domain.local_echo_threshold_ms = 1000

      if domain.name:match("%:wsl$") then
        domain.assume_shell = "Posix"
        domain.default_prog = {
          "fish",
          "-C",
          "set --export TITLE_PREFIX wsl:",
        }
      elseif wezterm.GLOBAL.is_remote then
        for suffix, port in pairs({
          ["dev"] = "22",
          ["dev%-wsl"] = "24",
          ["mbp-2023"] = "30",
          ["staging"] = "26",
        }) do
          if domain.name:match("%:" .. suffix .. "$") then
            domain.remote_address = "h.he.sg"
            domain.ssh_option = { port = port }
            break
          end
        end
      end

      return domain
    end
  )

  table.insert(config.ssh_domains, {
    name = "SSHMUX:localhost",
    remote_address = "localhost",
  })

  config.wsl_domains = common.map(
    wezterm.default_wsl_domains(),
    function(wsl_domain)
      wsl_domain.default_cwd = "~"
      wsl_domain.default_prog = common.fish_tmux_detached_session
      return wsl_domain
    end
  )
end

return M
