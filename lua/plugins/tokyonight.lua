return {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent",
			floats = "transparent",
		},
	},
	--  config = function()
	--    vim.opt.colorscheme("tokyonight-night")
	--    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	--  end
}
