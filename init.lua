-- hello_plugin/init.lua

local function move()
  local found = vim.fn.search("%%", "b")
  if found == 0 then
    print("No instance of '%%' found before the cursor.")
  end
end

local function copy()
  local start = vim.fn.line(".")
  local end_line = vim.fn.line("w$")
  local start_line = vim.fn.line("w0")
  local text = ""
  local cell_found = false

  for i = start, start_line do
    local line = vim.fn.getline(i)
    if cell_found then
      local finish = line:find("%%")
      if finish then
        text = text .. line:sub(1, finish - 1)
      end
    end
  end

  local cell_found = false
  for i = start, end_line do
    local line = vim.fn.getline(i)
    local start = line:find("%%")

    if cell_found then
      local finish = line:find("%%")
      if finish then
        text = text .. line:sub(1, finish - 1)
        break
      else
        text = text .. line .. "\n"
      end
      vim.fn.setreg('"', text)
      vim.notify("Copied text: " .. text, vim.log.levels.INFO)
    else
      if start then
        cell_found = true
        text = text .. line:sub(start + 2) .. "\n" -- Start copying after the first %%
      end
    end
  end
end

vim.api.nvim_create_user_command("MoveCell", move, {})
vim.api.nvim_set_keymap("n", "<leader>aa", ":MoveCell<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("CopyCell", copy, {})
vim.api.nvim_set_keymap("n", "<leader>ac", ":CopyCell<CR>", { noremap = true, silent = true })
