return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},

		config = function()
			local mason_tool_installer = require("mason-tool-installer")
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort", -- python formatter
					"pylint", -- python linter
					--"eslint-lsp", -- js/ts linter
					"eslint_d",
				},
			})

			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				-- run ":help lspconfig-all" to see list of all the lsp names etc
				ensure_installed = {
					"gopls",
					"lua_ls",
					"html",
					"jsonls",
					"ts_ls",
					"astro",
					"sqlls",
					"pyright",
					"terraformls",
					"tailwindcss",
					"eslint",
				},
			})
		end,
	},
	--  use the command :h vim.lsp to see all the functions
	--  use ":LspInfo" for troubleshooting
	{
		"neovim/nvim-lspconfig",
		--		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.html.setup({ capabilities = capabilities })
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.jsonls.setup({ capabilities = capabilities })
			lspconfig.astro.setup({ capabilities = capabilities })
			lspconfig.ts_ls.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.sqlls.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "python" },
			})
			lspconfig.terraformls.setup({ capabilities = capabilities })
			--lspconfig.tflint.setup({ capabilities = capabilities })
			lspconfig.tailwindcss.setup({ capabilities = capabilities })

			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
		end,
	},
	-- adding astro lsp, since mason-lspconfig was not working properly for astro
	"wuelnerdotexe/vim-astro",
}
