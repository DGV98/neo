-- Floating todos.md dashboard + markdown checkbox toggling.
local M = {}

local todo_file = vim.fn.expand("~/darch_todos.md")

local state = { win = nil }

function M.toggle_float()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, false)
		state.win = nil
		return
	end

	-- Open the window on a throwaway buffer, then :edit the real file so
	-- filetype detection and markview's attach autocmds fire normally.
	local scratch = vim.api.nvim_create_buf(false, true)
	vim.bo[scratch].bufhidden = "wipe"

	local width = math.floor(vim.o.columns * 0.6)
	local height = math.floor(vim.o.lines * 0.75)
	state.win = vim.api.nvim_open_win(scratch, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
		title = " todos ",
		title_pos = "center",
	})

	vim.cmd.edit(vim.fn.fnameescape(todo_file))
	local buf = vim.api.nvim_win_get_buf(state.win)
	pcall(vim.cmd, "Markview enable")

	vim.keymap.set("n", "q", M.toggle_float, { buffer = buf, nowait = true, desc = "Close todos dashboard" })

	-- Runs no matter how the float is closed (q, :q, <C-w>c, ...)
	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(state.win),
		once = true,
		callback = function()
			if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].modified then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("silent write")
				end)
			end
			pcall(vim.keymap.del, "n", "q", { buffer = buf })
			state.win = nil
		end,
	})
end

-- "- item" -> "- [ ] item", "- [ ]" <-> "- [x]"
function M.toggle_checkbox()
	local line = vim.api.nvim_get_current_line()
	local updated
	if line:match("^%s*[-*+]%s+%[ %]") then
		updated = line:gsub("^(%s*[-*+]%s+)%[ %]", "%1[x]", 1)
	elseif line:match("^%s*[-*+]%s+%[[xX]%]") then
		updated = line:gsub("^(%s*[-*+]%s+)%[[xX]%]", "%1[ ]", 1)
	elseif line:match("^%s*[-*+]%s") then
		updated = line:gsub("^(%s*[-*+]%s)", "%1[ ] ", 1)
	else
		return
	end
	vim.api.nvim_set_current_line(updated)
end

vim.keymap.set("n", "<leader>td", M.toggle_float, { desc = "Toggle todos dashboard" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	group = vim.api.nvim_create_augroup("me-todos", { clear = true }),
	callback = function(ev)
		vim.keymap.set("n", "<leader>tt", M.toggle_checkbox, { buffer = ev.buf, desc = "Toggle checkbox" })
	end,
})

return M
