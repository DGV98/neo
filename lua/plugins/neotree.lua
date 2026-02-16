return {
	"nvim-neo-tree/neo-tree.nvim",
	name = "neotree",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
    filesystem = {
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
      },
    },
    default_component_configs = {
      name = {
        use_git_status_colors = false
      }
    },
		event_handlers = {
			{
				event = "file_opened",
				handler = function(file_path)
          require('neo-tree').close_all()
				end
			},
		},
	},
	config = function(_, opts)
		vim.keymap.set("n", "<C-n>", "<Cmd>Neotree toggle<CR>")
    require("neo-tree").setup(opts)
	end,
}
