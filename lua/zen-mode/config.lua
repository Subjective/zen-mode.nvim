local util = require("zen-mode.util")
local M = {}

--- @type ZenOptions
M.options = {}

--- @class ZenOptions
local defaults = {
  zindex = 40, -- zindex of the zen window. Should be less than 50, which is the float default
  window = {
    backdrop = 0.95, -- shade the backdrop of the zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an asbolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    width = 120, -- width of the zen window
    height = 1, -- height of the zen window
    -- by default, no options are changed in for the zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      -- signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    gitsigns = true, -- disables git signs
    tmux = true, -- disables the tmux statusline
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = false,
      font = "+4", -- font size increment
    },
  },
  -- callback where you can add custom code when the zen window opens
  on_open = function(_win)
  end,
  -- callback where you can add custom code when the zen window closes
  on_close = function()
  end,
}

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
  local normal = util.get_hl("Normal")
  if normal and normal.background then
    local bg = util.darken(normal.background, M.options.window.backdrop)
    vim.cmd(("highlight ZenBg guibg=%s guifg=%s"):format(bg, bg))
  end
  for plugin, plugin_opts in pairs(M.options.plugins) do
    if type(plugin_opts) == "boolean" then
      M.options.plugins[plugin] = { enabled = plugin_opts }
    end
    if M.options.plugins[plugin].enabled == nil then
      M.options.plugins[plugin].enabled = true
    end
  end
end

M.setup()

return M