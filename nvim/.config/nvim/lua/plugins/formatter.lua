return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		-- cache the default on-save settings for reuse
		local default_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 500,
		}

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				svelte = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				graphql = { "prettier" },
				lua = { "stylua" },
				python = { "isort", "black" },
			},

			format_on_save = default_on_save,
		})

		--[[ 
		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })

]]

		-- make them globally available for the toggle
		vim.g._conform_format_on_save_cfg = default_on_save
		vim.g.conform_format_on_save_enabled = true
	end,
}
