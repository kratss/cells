# Cells

Bring Jupyter-like cell functionality to Neovim with this dead simple plugin.

Write `%%` to define the beginning of each cell. You can write it as `# %%` or `-- %%` or anything else so long as the line contains the cell signifier `%%`. This is intended for Python but the plugin itself is filetype agnostic

The intended workflow is to yank the current cell, go to an ipython  terminal, and type `%paste`

**Keymap:**
<leader>ay - yank current cell
<leader>an - move to next cell
<leader>ap - move to prev cell
<leader>am[number][Enter] - move the specified number of cells

There is a lot of room to improve the configurability of this plugin. Feel free to contribute improvements.

If this plugin has been useful to you, shoot me message or leave or star
