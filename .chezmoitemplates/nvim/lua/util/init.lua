return {
  async_run = function(command)
    return function()
      vim.cmd.AsyncRun("-close -mode=term -rows=5 " .. command)
    end
  end,
}
