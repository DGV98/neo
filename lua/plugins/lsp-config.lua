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
				"vtsls",
				"mdx_analyzer",
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
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})

			-- mdx-analyzer ships with its TypeScript layer off by default, and
			-- lspconfig only fills in the tsdk path without enabling it.
			vim.lsp.config("mdx_analyzer", {
				init_options = { typescript = { enabled = true } },
				-- Replaces lspconfig's before_init: same project-local tsdk
				-- lookup, but falls back to the TypeScript 5 installed inside
				-- Mason's mdx-analyzer package. Without a valid tsdk the server
				-- rejects initialize with "Can't find typescript.js ...".
				before_init = function(_, config)
					local ts = config.init_options and config.init_options.typescript
					if not ts or (ts.tsdk and ts.tsdk ~= "") then
						return
					end
					local tsdk = ""
					if config.root_dir then
						local ok, path = pcall(require("lspconfig.util").get_typescript_server_path, config.root_dir)
						if ok then
							tsdk = path or ""
						end
					end
					if tsdk == "" or not vim.uv.fs_stat(tsdk .. "/tsserverlibrary.js") then
						tsdk = vim.fn.stdpath("data") .. "/mason/packages/mdx-analyzer/node_modules/typescript/lib"
					end
					ts.tsdk = tsdk
				end,
			})
		end,
	},
}
