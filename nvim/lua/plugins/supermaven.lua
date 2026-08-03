return {
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({})

        vim.keymap.set("n", "<leader>st", function()
          require("supermaven-nvim.api").toggle()
        end, { desc = "Supermaven: toggle on/off" })
      end,
    },
}
