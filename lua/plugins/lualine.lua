return {
	"nvim-lualine/lualine.nvim",
	name = "lualine",
	config = function()
		require("lualine").setup()
		options = {
			theme = "dracula",
		}
	end,
}
