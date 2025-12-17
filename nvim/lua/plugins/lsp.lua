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

			-- bashls
			vim.lsp.config.bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}
			vim.lsp.enable("bashls")

			-- lua_ls
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".git", ".luarc.json", ".luarc.jsonc", ".luacheckrc" },
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
			}
			vim.lsp.enable("lua_ls")

            -- Optional: Only required if you need to update the language server settings
            vim.lsp.config('ty', {
              settings = {
                ty = {
                  -- ty language server settings go here
                }
              }
            })

            -- Required: Enable the language server
            vim.lsp.enable('ty')

			-- zls
			vim.lsp.config.zls = {
				cmd = { "zls" },
				filetypes = { "zig", "zir" },
				root_markers = { "build.zig", ".git" },
				capabilities = capabilities,
			}
			vim.lsp.enable("zls")

			-- yamlls
			vim.lsp.config.yamlls = {
				cmd = { "yaml-language-server", "--stdio" },
				filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					yaml = {
						schemas = {
							["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
						}
					}
				}
			}
			vim.lsp.enable("yamlls")
		end,
	},
}
