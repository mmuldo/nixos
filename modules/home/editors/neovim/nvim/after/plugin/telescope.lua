require("telescope").setup {}
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files {
    cwd = vim.fn.stdpath "config"
  }
end)
vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
vim.keymap.set("n", "<leader>s/", builtin.live_grep, {})
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(
    require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    }
  )
end)
