vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.nvim_tree_respect_buf_cwd = 1,

-- always set leader first
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- keep more context on screen while scrolling
vim.opt.scrolloff = 2

-- never show me line breaks if they're not there
vim.opt.wrap = false

-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = "yes"

-- relative line numbers
vim.opt.relativenumber = true

-- show the absolute line number for the current line
vim.opt.number = true

-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- infinite undo
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true
vim.opt.wildmode = "list:longest"

-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

-- tabs
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = false

-- case-insensitive search/replace
vim.opt.ignorecase = true

-- unless uppercase in search term
vim.opt.smartcase = true

-- never ever make my terminal beep
vim.opt.vb = true

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append("iwhite")

-- show more hidden characters
-- also, show tabs nicer
vim.opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•"

-------------------------------------------------------------------------------
--
-- general key mappings
--
-------------------------------------------------------------------------------
-- quick-open
vim.keymap.set("", "<C-p>", "<cmd>Files<cr>")

-- search buffers
vim.keymap.set("n", "<leader>;", "<cmd>Buffers<cr>")

-- <leader><leader> toggles between buffers
vim.keymap.set("n", "<leader><leader>", "<c-^>")

-- <leader>, shows/hides hidden characters
vim.keymap.set("n", "<leader>,", ":set invlist<cr>")

-- <leader>t opens a terminal below
vim.keymap.set("n", "<leader>t", ":12sp +term<cr>")

-- <C-\><C-\> leaves insert mode in terminal
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>")

-- <leader>/ clears search
vim.keymap.set("n", "<leader>/", ":noh<cr>")

-- always center search results
vim.keymap.set("n", "n", "nzz", { silent = true })
vim.keymap.set("n", "N", "Nzz", { silent = true })
vim.keymap.set("n", "*", "*zz", { silent = true })
vim.keymap.set("n", "#", "#zz", { silent = true })
vim.keymap.set("n", "g*", "g*zz", { silent = true })

-- open new file adjacent to current file
vim.keymap.set("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- no arrow keys --- force yourself to use the home row
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- split current window
vim.keymap.set("n", "<leader>\\", ":vsp<cr>")

-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	command = "silent! lua vim.highlight.on_yank({ timeout = 500 })",
})
-- jump to last edit position on opening file
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function(ev)
		if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
			-- except for in git commit messages
			-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
			if not vim.fn.expand("%:p"):find(".git", 1, true) then
				vim.cmd('exe "normal! g\'\\""')
			end
		end
	end,
})
-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.orig", command = "set readonly" })
vim.api.nvim_create_autocmd("BufRead", { pattern = "*.pacnew", command = "set readonly" })

-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd("InsertLeave", { pattern = "*", command = "set nopaste" })

-- disable numbers upon entering terminal and immediately start inserting
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	command = "setlocal nonumber norelativenumber | startinsert",
})
-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- plugin setup
require("lazy").setup({
	-- main color scheme
	{
		"tinted-theming/tinted-vim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			vim.cmd([[colorscheme base16-ayu-dark]])
			vim.o.background = "dark"
			-- Make comments more prominent -- they are important.
			local bools = vim.api.nvim_get_hl(0, { name = "Boolean" })
			vim.api.nvim_set_hl(0, "Comment", bools)
			-- Make it clearly visible which argument we're at.
			local marked = vim.api.nvim_get_hl(0, { name = "PMenu" })
			vim.api.nvim_set_hl(
				0,
				"LspSignatureActiveParameter",
				{ fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true }
			)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			local configs = require("nvim-treesitter.configs")
			ensure_installed =
				{
					"c",
					"cpp",
					"dockerfile",
					"lua",
					"vim",
					"vimdoc",
					"rust",
					"python",
					"html",
					"css",
					"xml",
					"dockerfile",
					"jsonc",
					"markdown",
					"markdown_inline",
				}, configs.setup({
					highlight = {
						enable = true,
					},
				})
		end,
	},
	-- better vim %
	{
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	-- nice bar at the bottom
	{
		"itchyny/lightline.vim",
		lazy = false, -- also load at start since it's UI
		config = function()
			-- no need to also show mode in cmd line when we have bar
			vim.o.showmode = false
			vim.g.lightline = {
				active = {
					left = {
						{ "mode", "paste" },
						{ "readonly", "filename", "modified" },
					},
					right = {
						{ "lineinfo" },
						{ "percent" },
						{ "fileencoding", "filetype" },
					},
				},
				component_function = {
					filename = "LightlineFilename",
				},
			}
			function LightlineFilenameInLua(opts)
				if vim.fn.expand("%:t") == "" then
					return "[No Name]"
				else
					return vim.fn.getreg("%")
				end
			end
			-- https://github.com/itchyny/lightline.vim/issues/657
			vim.api.nvim_exec(
				[[
				function! g:LightlineFilename()
					return v:lua.LightlineFilenameInLua()
				endfunction
				]],
				true
			)
		end,
	},
	-- auto-cd to root of git project
--	{
--		"notjedi/nvim-rooter.lua",
--		config = function()
--			require("nvim-rooter").setup()
--		end,
--	},
	-- fzf
	{
		"junegunn/fzf.vim",
		dependencies = {
			{ "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
		},
		config = function()
			-- stop putting a giant window over my editor
			vim.g.fzf_layout = { down = "~20%" }
			-- when using :Files, pass the file list through
			--
			--   https://github.com/jonhoo/proximity-sort
			--
			-- to prefer files closer to the current file.
			function list_cmd()
				local base = vim.fn.fnamemodify(vim.fn.expand("%"), ":h:.:S")
				if base == "." then
					-- if there is no current file,
					-- proximity-sort can't do its thing
					return "fd --type file --follow"
				else
					return vim.fn.printf(
						"fd --type file --follow | proximity-sort %s",
						vim.fn.shellescape(vim.fn.expand("%"))
					)
				end
			end
			vim.api.nvim_create_user_command("Files", function(arg)
				vim.fn["fzf#vim#files"](arg.qargs, { source = list_cmd(), options = "--tiebreak=index" }, arg.bang)
			end, { bang = true, nargs = "?", complete = "dir" })
		end,
	},
	-- formatting
	{
		"stevearc/conform.nvim",
		config = function()
			local jsFtFormatter = { "myprettier", "myeslint", stop_after_first = false, timeout_ms = 8000 }
			local conform = require("conform")
			conform.setup({
				-- command = "prettier --write --log-level silent src/ __tests__/; eslint --quiet --fix --fix-type layout src/**/* __tests__/**/*"
				formatters = {
					myprettier = {
						command = "npx",
						args = { "prettier", "--write", "$FILENAME" },
						stdin = false,
						cwd = function()
							vim.fn.getcwd()
						end,
						timeout_ms = 5000,
					},
					myeslint = {
						command = "npx",
						args = { "eslint", "--quiet", "--fix", "--fix-type", "layout", "$FILENAME" },
						stdin = false,
						cwd = function()
							vim.fn.getcwd()
						end,
						timeout_ms = 5000,
					},
				},
				formatters_by_ft = {
					lua = { "stylua" },
					html = { "prettierd" },
					markdown = { "prettierd" },
					javascript = jsFtFormatter,
					typescript = jsFtFormatter,
					javascriptreact = jsFtFormatter,
					typescriptreact = jsFtFormatter,
				},
			})

			vim.keymap.set("n", "<C-q>", function()
				conform.format()
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {},
		config = function()
			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)
		end,
	},
	{ "hrsh7th/cmp-nvim-lsp" },
	{
		"hrsh7th/nvim-cmp",
		opts = {},
		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
			})
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					tsserver_file_preferences = {
						importModuleSpecifierPreference = "project-relative",
					},
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>k", builtin.live_grep, { desc = "Telescope live grep" })
		end,
	},
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 40,
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
				},
			})
			vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")
		end,
	},
})
