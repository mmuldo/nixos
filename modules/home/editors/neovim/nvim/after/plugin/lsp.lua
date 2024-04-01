local lspconfig = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_nvim_lsp.default_capabilities()
)

require("neodev").setup {}

lspconfig.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
}

lspconfig.nixd.setup {
  capabilities = capabilities
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach-keybinds", { clear = true }),
  callback = function(e)
    local keymap = function(keys, func)
      vim.keymap.set("n", keys, func, { buffer = e.buf })
    end
    local builtin = require("telescope.builtin")

    keymap("gd", builtin.lsp_definitions)
    keymap("gD", vim.lsp.buf.declaration)
    keymap("gr", builtin.lsp_references)
    keymap("gI", builtin.lsp_implementations)
    keymap("<leader>D", builtin.lsp_type_definitions)
    keymap("<leader>ds", builtin.lsp_document_symbols)
    keymap("<leader>ws", builtin.lsp_dynamic_workspace_symbols)
    keymap("<leader>rn", vim.lsp.buf.rename)
    keymap("<leader>ca", vim.lsp.buf.code_action)
    keymap("K", vim.lsp.buf.hover)
  end
})
