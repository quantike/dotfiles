return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "ruff" },
				rust = { "rustfmt" },
				json = { "prettier" },
				markdown = { "prettier" },
				sql = function(bufnr)
					local name = vim.api.nvim_buf_get_name(bufnr)
					-- DuckDB spawns editor buffers named duckdb.edit.NUMBER.sql via \e
					if name:match("duckdb%.edit%.%d+%.sql$") then
						return { "sqlfluff_duckdb" }
					end
					return { "sqlfluff_postgres" }
				end,
			},
			formatters = {
				sqlfluff_postgres = {
					command = "sqlfluff",
					args = { "format", "--dialect", "postgres", "-" },
				},
				sqlfluff_duckdb = {
					command = "sqlfluff",
					args = { "format", "--dialect", "duckdb", "-" },
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})

		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
