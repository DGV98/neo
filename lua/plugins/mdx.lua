return {
	"davidmh/mdx.nvim",
	-- Upstream's README lists "nvim-treesitter/nvim-treesitter" here, but our
	-- treesitter spec renames that plugin, so the full URL would make lazy
	-- install a second copy under the default name.
	dependencies = { "treesitter" },
}
