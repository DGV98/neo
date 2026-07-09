return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"lua_ls",
				"pyright",
				"eslint",
				"hyprls",
				"qmlls",
				"sqls",
			},
			-- stylua is a mason-installed formatter, but nvim-lspconfig ships an
			-- `lsp/stylua.lua`, so automatic_enable would start it as a server and
			-- fight conform over formatting.
			automatic_enable = { exclude = { "stylua" } },
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			-- Merged into every server that mason-lspconfig enables.
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})
		end,
	},
}
