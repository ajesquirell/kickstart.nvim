-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

---@module 'lazy'
---@type LazySpec
return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
    opts = {
      delete_to_trash = true,
      watch_for_changes = true,
      keymaps = {
        ['<ESC>'] = 'actions.close',
        ['<leader>y'] = 'actions.copy_to_system_clipboard',
        ['<C-r>'] = 'actions.refresh',

        -- Allow for window navigation to work as expected between oil, oil previews, and normal buffers
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,

        ['<M-h>'] = 'actions.preview_scroll_left',
        ['<M-j>'] = 'actions.preview_scroll_down',
        ['<M-k>'] = 'actions.preview_scroll_up',
        ['<M-l>'] = 'actions.preview_scroll_right',

        ['<leader>v'] = { 'actions.select', opts = { vertical = true }, desc = 'Open in vertical split' },
        ['<leader>h'] = { 'actions.select', opts = { horizontal = true } },
      },
    },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      {
        '-',
        mode = { 'n', 'v' },
        '<CMD>Oil<CR>',
        desc = 'Open parent directory',
      },
      {
        '<leader>-',
        function() require('oil.actions').open_cwd.callback() end,
        desc = 'Open current working directory',
      },
    },
    init = function()
      -- HACK: override which key description, since it conflicts with git hunk (purely visual)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'oil',
        callback = function()
          local wk = require 'which-key'
          wk.add {
            { '<leader>h', desc = 'Open in horizontal split', buffer = true },
          }
        end,
      })
    end,
  },
}
