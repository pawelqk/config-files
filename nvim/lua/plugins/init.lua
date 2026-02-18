return {
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
						command = "pnpx",
						args = { "prettier", "--write", "$FILENAME" },
						stdin = false,
						cwd = function()
							vim.fn.getcwd()
						end,
						timeout_ms = 5000,
					},
					myeslint = {
						command = "pnpx",
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
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
        --require('bufferline').setup({})
      end
   },
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      --vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        indent = { 
            indent = {
				priority = 1,
				enabled = true,
			},
			scope = {
				enabled = true,
			},
			chunk = {
				enabled = true,
			},
			animate = {
				-- enabled = vim.fn.has("nvim-0.10") == 1,
				enabled = false,
				-- duration = {
				-- 	step = 10, -- ms per step
				-- 	total = 500, -- maximum duration
				-- },
			},
			filter = function(buf)
				return vim.g.snacks_indent ~= false
					and vim.b[buf].snacks_indent ~= false
					and vim.bo[buf].ft ~= ""
					and vim.bo[buf].ft ~= "wk"
					and vim.bo[buf].ft ~= "qf"
					and vim.bo[buf].ft ~= "help"
					and vim.bo[buf].ft ~= "dapui_scopes"
					and vim.bo[buf].ft ~= "dapui_watches"
					and vim.bo[buf].ft ~= "dapui_stacks"
					and vim.bo[buf].ft ~= "dapui_breakpoints"
					and vim.bo[buf].ft ~= "dapui_console"
					and vim.bo[buf].ft ~= "dap-repl"
					and vim.bo[buf].ft ~= "harpoon"
					and vim.bo[buf].ft ~= "dropbar_menu"
					and vim.bo[buf].ft ~= "glow"
					and vim.bo[buf].ft ~= "aerial"
					and vim.bo[buf].ft ~= "dashboard"
					and vim.bo[buf].ft ~= "lspinfo"
					and vim.bo[buf].ft ~= "lspsagafinder"
					and vim.bo[buf].ft ~= "packer"
					and vim.bo[buf].ft ~= "checkhealth"
					and vim.bo[buf].ft ~= "man"
					and vim.bo[buf].ft ~= "mason"
					and vim.bo[buf].ft ~= "noice"
					and vim.bo[buf].ft ~= "NvimTree"
					and vim.bo[buf].ft ~= "neo-tree"
					and vim.bo[buf].ft ~= "plugin"
					and vim.bo[buf].ft ~= "lazy"
					and vim.bo[buf].ft ~= "TelescopePrompt"
					and vim.bo[buf].ft ~= "alpha"
					and vim.bo[buf].ft ~= "toggleterm"
					and vim.bo[buf].ft ~= "sagafinder"
					and vim.bo[buf].ft ~= "sagaoutline"
					and vim.bo[buf].ft ~= "better_term"
					and vim.bo[buf].ft ~= "fugitiveblame"
					and vim.bo[buf].ft ~= "Trouble"
					and vim.bo[buf].ft ~= "Outline"
					and vim.bo[buf].ft ~= "OutlineHelp"
					and vim.bo[buf].ft ~= "starter"
					and vim.bo[buf].ft ~= "NeogitPopup"
					and vim.bo[buf].ft ~= "NeogitStatus"
					and vim.bo[buf].ft ~= "DiffviewFiles"
					and vim.bo[buf].ft ~= "DiffviewFileHistory"
					and vim.bo[buf].ft ~= "DressingInput"
					and vim.bo[buf].ft ~= "spectre_panel"
					and vim.bo[buf].ft ~= "zsh"
					and vim.bo[buf].ft ~= "vuffers"
					and vim.bo[buf].ft ~= "oil"
					and vim.bo[buf].ft ~= "oil_preview"
					and vim.bo[buf].ft ~= "NeogitConsole"
					and vim.bo[buf].ft ~= "text"
					and vim.bo[buf].ft ~= "AvanteInput"
					and vim.bo[buf].ft ~= "buffer_manager"
					and vim.bo[buf].ft ~= "snacks_picker_list"
					and vim.bo[buf].ft ~= "snacks_picker_input"
					and vim.bo[buf].ft ~= "markdown"
			end,
		},
    },
}
}
