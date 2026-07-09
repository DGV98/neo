local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	name = "treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install(parsers)

		-- main dropped the jsonc parser, and nothing maps the filetype to json.
		vim.treesitter.language.register("json", "jsonc")

		-- Parser names are not filetype names: the tsx parser attaches to
		-- typescriptreact, and markdown_inline/luap/regex attach to nothing.
		local filetypes = {}
		for _, lang in ipairs(parsers) do
			vim.list_extend(filetypes, vim.treesitter.language.get_filetypes(lang))
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = filetypes,
			callback = function()
				vim.treesitter.start()
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
