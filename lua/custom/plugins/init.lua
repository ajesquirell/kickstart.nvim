--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local palette = require('catppuccin.palettes').get_palette()

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
  {
    'MagicDuck/grug-far.nvim',
    -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
    -- additional lazy config to defer loading is not really needed...
    config = function()
      -- optional setup call to override plugin options
      -- alternatively you can set options with vim.g.grug_far = { ... }
      require('grug-far').setup {
        -- options, see Configuration section below
        -- there are no required options atm
      }
    end,
    keys = {
      {
        '<leader>rg',
        mode = { 'n', 'v' },
        function() require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } } end,
        -- function() require('grug-far').open { transient = true } end,
      },
    },
    {
      'catgoose/nvim-colorizer.lua',
      event = 'BufReadPre',
      opts = {},
    },
    {
      'petertriho/nvim-scrollbar',
      dependencies = {
        'lewis6991/gitsigns.nvim',
      },
      config = function()
        require('scrollbar').setup {
          handle = {
            color = palette.overlay0,
          },
          marks = {
            Cursor = {
              color = palette.peach,
              text = '◀',
            },
            GitAdd = {
              priority = 7,
              color = palette.green
            },
            GitChange = {
              priority = 9,
              color = palette.yellow
            },
            GitDelete = {
              priority = 8,
              color = palette.red
            }
          },
        }
        require('scrollbar.handlers.gitsigns').setup()
      end,
    },
  },
}
