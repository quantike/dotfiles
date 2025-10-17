return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"lua_ls",
					"pyright",
					"zls",
					"yamlls",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.bashls.setup({
				capabilities = capabilities,
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" }, -- recognize `vim` as a global command
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true), -- include neovim runtime files
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})
			lspconfig.zls.setup({
				capabilities = capabilities,
				cmd = { "zls" },
			})
			lspconfig.yamlls.setup({
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
						}
					}
				}
			})
		end,
	},
}
