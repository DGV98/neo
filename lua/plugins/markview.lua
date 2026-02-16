-- For `plugins/markview.lua` users.
return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  opts = {
    preview = {enable = false}
  },
  config = function(_, opts)
    vim.api.nvim_set_keymap("n", "<leader>m", "<CMD>Markview<CR>", { desc = "Toggles `markview` previews globally." });
    vim.api.nvim_set_keymap("n", "<leader>s", "<CMD>Markview splitToggle<CR>", { desc = "Toggles `splitview` for current buffer." });
    require("markview").setup(opts)
  end


  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
};
