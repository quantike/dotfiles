function ColorMyPencils(color)
	color = color or "gruvbox"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end


return {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        require 'gruvbox'.setup {
            transparent_bg = true,
        }
        require 'gruvbox'.load()
        ColorMyPencils()  -- Apply the transparency settings
    end
}
