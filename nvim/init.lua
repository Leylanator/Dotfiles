-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Plugins here. Yes, I'm doing it in one file because I'm not fully hinged

    -- / Bulk Plugins /
    { "sheerun/vim-polyglot", "scrooloose/NERDTree", "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "BurntSushi/ripgrep", "sharkdp/fd", "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },

    -- / Autocomplete /
    {
    "neovim/nvim-lspconfig", -- REQUIRED: for native Neovim LSP integration
    lazy = false, -- REQUIRED: tell lazy.nvim to start this plugin at startup
    dependencies =
      {
        -- main one
        { "ms-jpq/coq_nvim", branch = "coq" },

        -- 9000+ Snippets
        { "ms-jpq/coq.artifacts", branch = "artifacts" },

        -- lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
        -- Need to **configure separately**
   --     { 'ms-jpq/coq.thirdparty', branch = "3p" }
        -- - shell repl
        -- - nvim lua api
        -- - scientific calculator
        -- - comment banner
        -- - etc
      },
    init = function()
      vim.g.coq_settings =
        {
        auto_start = false, -- if you want to start COQ at startup
        -- COQ settings here
        -- keymap
        keymap = 
          {
            recommended = false,
            vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true }),
            vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true }),
            vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true }),
            vim.api.nvim_set_keymap(
            "i",
            "<CR>",
            [[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
            { expr = true, silent = true }),
            vim.api.nvim_set_keymap('i', '<D-Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true }),    -- Set to D-Tab from Tab
            vim.api.nvim_set_keymap('i', '<D-S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true }),   -- Set to D-S-Tab from S-Tab
            -- Only changed last two such that instead of using a Tab,
            -- COQ instead has to have Super+Tab or Super+Shift+Tab.
            -- D-Tab = Super+Tab
            -- I find this less intrusive since I typeset with Tab.
          }
        }
      end,
      config = function()
      -- LSP settings here, if I get to it
      end,
    },

    -- / org mode plugin /
    {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
    },

    -- / Git wrapper /
    {
    'tanvirtin/vgit.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    -- Lazy loading on 'VimEnter' event is necessary.
    event = 'VimEnter',
    config = function() require("vgit").setup() end,
    },

    -- Lush... Set up later
    --{
    	--"rktjmp/lush.nvim",
    -- if you wish to use your own colorscheme:
    -- { dir = '/absolute/path/to/colorscheme', lazy = true },
    --},
    
    -- Pixel.nvim might be better for now
    {
  "bjarneo/pixel.nvim",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("pixel")
  end,
},
-- now to figure out how to set up transparency

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

--
-- Start of transparency shim

-- Function to apply transparency settings globally
local function set_transparency()
vim.cmd([[
hi Normal guibg=NONE ctermbg=NONE
hi NormalNC guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi StatusLine guibg=NONE ctermbg=NONE
hi StatusLineNC guibg=NONE ctermbg=NONE
hi VertSplit guibg=NONE ctermbg=NONE
hi TabLine guibg=NONE ctermbg=NONE
hi TabLineFill guibg=NONE ctermbg=NONE
hi TabLineSel guibg=NONE ctermbg=NONE
hi Pmenu guibg=NONE ctermbg=NONE
hi PmenuSel guibg=NONE ctermbg=NONE
hi NeoTreeNormal guibg=NONE ctermbg=NONE
hi NeoTreeNormalNC guibg=NONE ctermbg=NONE
hi NeoTreeWinSeparator guibg=NONE ctermbg=NONE
]])
end

-- Apply transparency settings initially
set_transparency()

-- Set up neo-tree with default settings and no custom mappings
--require('neo-tree').setup({
--window = {
-- Use default settings with no custom mappings
--},
--})

-- Reapply transparency on buffer enter
vim.api.nvim_create_autocmd("BufEnter", {
pattern = "*",
callback = set_transparency,
})

--
-- End of transparency shim
