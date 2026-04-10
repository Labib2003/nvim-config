-- BASE UI
vim.opt.termguicolors = true
vim.cmd.colorscheme("catppuccin")

-- EDITOR
vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor
vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 1 -- single line command line
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.conceallevel = 0 -- do not hide markup
vim.opt.concealcursor = "" -- do not hide cursorline in markup
vim.opt.lazyredraw = true -- do not redraw during macros
vim.opt.synmaxcol = 300 -- syntax highlighting limit
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

local undodir = vim.fn.expand("~/.vim/undodir")
if
	vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory
vim.opt.updatetime = 300 -- faster completion
vim.opt.timeoutlen = 500 -- timeout duration
vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save

vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = "indent,eol,start" -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append("-") -- include - in words
vim.opt.path:append("**") -- include subdirs in search
vim.opt.selection = "inclusive" -- include last char in selection
vim.opt.mouse = "a" -- enable mouse support
vim.opt.clipboard:append("unnamedplus") -- use system clipboard
vim.opt.modifiable = true -- allow buffer modifications
vim.opt.encoding = "utf-8" -- set encoding

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = "expr" -- use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = "longest:full,full" -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append("linematch:60") -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- KEYMAPS FOR BULIT IN FEATURES
vim.g.mapleader = " " 
vim.g.maplocalleader = " " 

vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { noremap = true, silent = true })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])


-- CUSTOM PLUGINS
vim.pack.add({
    "https://github.com/akinsho/toggleterm.nvim",
	"https://www.github.com/lewis6991/gitsigns.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/nvim-tree/nvim-tree.lua",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/echasnovski/mini.nvim",
    "https://github.com/akinsho/bufferline.nvim"
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end
packadd("toggleterm.nvim")
packadd("gitsigns.nvim")
packadd("nvim-web-devicons")
packadd("nvim-tree.lua")
packadd("fzf-lua")
packadd("mini.nvim")
packadd("bufferline.nvim")

-- PLUGIN CONFIG
require("toggleterm").setup({
  direction = "float",
  start_in_insert = true,

  on_open = function(term)
    vim.schedule(function()
      vim.cmd("startinsert!")
    end)
  end, 

  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return 35 
    end
  end,
})
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm direction=vertical<CR>", { silent = true })

require("gitsigns").setup({
	signs = {
		add = { text = "\u{2590}" }, -- ▏
		change = { text = "\u{2590}" }, -- ▐
		delete = { text = "\u{2590}" }, -- ◦
		topdelete = { text = "\u{25e6}" }, -- ◦
		changedelete = { text = "\u{25cf}" }, -- ●
		untracked = { text = "\u{25cb}" }, -- ○
	},
	signcolumn = true,
	current_line_blame = false,
})

require("nvim-tree").setup({
	view = {
		width = 35,
	},
	filters = {
		dotfiles = false,
	},
	renderer = {
		group_empty = true,
	},
    actions = {  
    change_dir = {  
      restrict_above_cwd = true,  
    },  
  },
})
vim.keymap.set("n", "<leader>e", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

-- GIT INTEGRATION WITH LAZYGIT
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
  cmd = "lazygit",
  hidden = true,
  direction = "float",

  float_opts = {
    border = "double",
  },

  on_open = function(term)
    vim.cmd("startinsert!")
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = term.bufnr, silent = true })
  end,

  on_close = function()
    vim.cmd("startinsert!")
  end,
})

function _lazygit_toggle()
  lazygit:toggle()
end
vim.keymap.set("n", "<leader>gg", _lazygit_toggle, { noremap = true, silent = true })

require("mini.ai").setup({})
require("mini.align").setup({})
require("mini.comment").setup({})
require("mini.pairs").setup({})
require("mini.basics").setup({})
require("mini.icons").setup({})
require('mini.statusline').setup({  
  content = {  
    active = function()  
      -- Add offset for nvimtree  
      if vim.bo.filetype == 'NvimTree' then  
        return '   ' .. MiniStatusline.combine_groups({  
          { hl = 'MiniStatuslineFilename', strings = { 'NvimTree' } },  
          '%='  
        })  
      end  
        
      -- Default content for other buffers  
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })  
      local git           = MiniStatusline.section_git({ trunc_width = 40 })  
      local diff          = MiniStatusline.section_diff({ trunc_width = 75 })  
      local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })  
      local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })  
      local filename      = MiniStatusline.section_filename({ trunc_width = 140 })  
      local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })  
      local location      = MiniStatusline.section_location({ trunc_width = 75 })  
      local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })  
  
      return MiniStatusline.combine_groups({  
        { hl = mode_hl,                  strings = { mode } },  
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },  
        '%<',  
        { hl = 'MiniStatuslineFilename', strings = { filename } },  
        '%=',  
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },  
        { hl = mode_hl,                  strings = { search, location } },  
      })  
    end  
  }  
})

require("bufferline").setup({
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
      }
    }
  }
})
vim.keymap.set("n", "<leader>bb", "<cmd>BufferLinePick<CR>", { noremap = true, silent = true })

-- AUTOCMDS
-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})
