-- use "," for <leader>  key, idk it's nice
vim.g.mapleader = ","

-- back out of file (useful)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- vim settings
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "120"

-- lsp setup
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition)
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references)
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "<leader>gT", vim.lsp.buf.type_definition)
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

-- lsp diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- lsp log management
-- Clears the LSP log file (useful due to terraform-ls stderr bug: https://github.com/hashicorp/terraform-ls/issues/1271)
vim.api.nvim_create_user_command('LspLogNuke', function()
    local log_path = vim.lsp.get_log_path()
    local file = io.open(log_path, 'w')
    if file then
        file:close()
        vim.notify('Nuked LSP log: ' .. log_path, vim.log.levels.INFO)
    else
        vim.notify('Failed to nuke LSP log: ' .. log_path, vim.log.levels.ERROR)
    end
end, { desc = 'Clear the LSP log file' })
