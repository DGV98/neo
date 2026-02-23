return {
	{
		"mason-org/mason.nvim",
		opts = {},
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.enable({ "lua_ls", "hyprls", "qmlls", "pyright" })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			-- local lspconfig = require("lspconfig")
			-- lspconfig.tsserver.setup({ capabilities = capabilities })
			-- lspconfig.html.setup({ capabilities = capabilities })
			-- lspconfig.lua_ls.setup({ capabilities = capabilities })
		end,
	},
}
