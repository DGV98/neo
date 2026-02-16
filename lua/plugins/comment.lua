return {
	"numToStr/Comment.nvim",
	opts = {
		toggler = {
			line = "<C-/>",
		},
	},
	config = function(_, opts)
		require("Comment").setup(opts)
	end,
}
