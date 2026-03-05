return {
	"mfussenegger/nvim-lint",
	config = function()
		require("lint").linters_by_ft = {
			yaml = { "actionlint" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				local filepath = vim.fn.expand("%:p")
				if filepath:match("%.github/workflows/") then
					require("lint").try_lint()
				end
			end,
		})
	end,
}