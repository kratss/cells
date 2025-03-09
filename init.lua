-- Bring cell functionality to neovim
local function copy_text(start, stop)
  local lines = vim.api.nvim_buf_get_lines(0, start - 1, stop, false)
  local copied_text = table.concat(lines, "\n")
  -- You can use the system clipboard or Neovim's unnamed register
  vim.fn.setreg("+", copied_text) -- Copy to system clipboard
  -- vim.fn.setreg('"', copied_text)  -- Copy to unnamed register
end
local function get_cell_start()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  for i = cursor_pos - 1, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:find("%%") then
      return i -- Return the line number if found
    end
  end
  return 1
end
local function get_cell_end()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  local last_line = vim.api.nvim_buf_line_count(0)
  for i = cursor_pos + 1, last_line do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:find("%%") then
      return i - 1
    end
  end
  return last_line
end
local function copy_cell()
  local a = get_cell_start()
  local b = get_cell_end()
  copy_text(a, b)
  vim.notify("Copied text: " .. a .. "," .. b .. ". " .. vim.log.levels.INFO)
end
local function prev_cell()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get current line number
  for i = cursor_pos - 1, 1, -1 do -- Iterate downwards
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:find("%%") then
      return i
    end
  end
  return 1
end
local function get_next_cell(opts)
  opts = opts or { args = "1" } -- Default to "1" if opts is nil
  local cursor_pos = vim.api.nvim_win_get_cursor(0)[1]
  local last_line = vim.api.nvim_buf_line_count(0)
  local count = 0
  local num_cells = tonumber(opts.args) or 1
  for i = cursor_pos + 1, last_line do -- Iterate downwards
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if line and line:find("%%") then
      count = count + 1
      if count == num_cells then
        return i
      end
    end
  end
  return last_line
end
local function move_cursor(line)
  vim.api.nvim_win_set_cursor(0, { line, 0 }) -- Move cursor to the found line
end
local function move_next_cell()
  local line = get_next_cell()
  move_cursor(line)
end
local function move_prev_cell()
  local line = prev_cell()
  move_cursor(line)
end
local function copy_multiple_cells(opts)
  local start = get_cell_start()
  local stop = get_next_cell(opts) -- Move to the next cell
  copy_text(start, stop)
  vim.notify("Copied cells from line " .. start .. " to line " .. stop .. ". ", vim.log.levels.INFO)
end

vim.api.nvim_set_keymap("n", "<leader>a", "<Nop>", { noremap = true, silent = true, desc = "Cell motions" })

vim.api.nvim_create_user_command("Copycell", copy_cell, {})
vim.api.nvim_set_keymap(
  "n",
  "<leader>ay",
  ":Copycell<CR>",
  { noremap = true, silent = true, desc = "Yank current cell" }
)

vim.api.nvim_create_user_command("Movenextcell", move_next_cell, { nargs = 1 })
vim.api.nvim_set_keymap(
  "n",
  "<leader>an",
  ":Movenextcell 1<CR>",
  { noremap = true, silent = true, desc = "Go next cell" }
)

vim.api.nvim_create_user_command("Moveprevcell", move_prev_cell, {})
vim.api.nvim_set_keymap(
  "n",
  "<leader>ab",
  ":Moveprevcell<CR>",
  { noremap = true, silent = true, desc = "Go prev cell" }
)

vim.api.nvim_create_user_command("Copymulticell", copy_multiple_cells, { nargs = 1 })
vim.api.nvim_set_keymap(
  "n",
  "<leader>am",
  ":Copymulticell<CR>",
  { noremap = true, silent = true, desc = "copy multiple cell" }
)
