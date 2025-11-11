return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			python = { "pylint" },
		}

		-- Add this to help debug
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
			vim.notify("Linting with: " .. vim.inspect(lint.get_running()))
		end, { desc = "Trigger linting" })

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Configure diagnostics to show inline
		vim.diagnostic.config({
			virtual_text = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,

	-- Press `gl` to open a focused floating window with the full diagnostic under the cursor
	vim.keymap.set("n", "gl", function()
		vim.diagnostic.open_float(nil, {
			scope = "cursor",
			focus = true, -- lets you scroll with j/k if the message is long
			border = "rounded",
		})
	end, { desc = "Show full diagnostic under cursor" }),
}
