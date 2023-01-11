local cmp = require('cmp')
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

--" Set completeopt to have a better completion experience
--" :help completeopt
--" menuone: popup even when there's only one match
--" noinsert: Do not insert text until a selection is made
--" noselect: Do not select, force user to select one from the menu
--set completeopt=menuone,noinsert,noselect
vim.opt.completeopt = "menuone,noinsert,noselect"

--" Avoid showing extra messages when using completion
--set shortmess+=c
vim.opt.shortmess:append("c")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  --vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  --vim.keymap.set('n', '<space>wl', function()
  --  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  --end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>F', vim.lsp.buf.formatting, bufopts)
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- opts to send to nvim-lspconfig
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
lspconfig.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  -- cmd = { "rust-analyzer" } -- default
  cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- run rust-analyzer when installed using rustup
  -- rust-analyzer settings
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy"
      },
    }
  }
}

lspconfig.gopls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  -- gopls settings
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  settings = {
    gopls = {
      analyses = {
	unusedparams = true,
	shadow = true,
      },
      staticcheck = true,
    }
  }
}


-- Setup Completion
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    --['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    --['<C-d>'] = cmp.mapping.scroll_docs(-4),
    --['<C-f>'] = cmp.mapping.scroll_docs(4),
    --['<C-Space>'] = cmp.mapping.complete(),
    --['<C-e>'] = cmp.mapping.close(),
    --['<CR>'] = cmp.mapping.confirm({
    --  behavior = cmp.ConfirmBehavior.Insert,
    --  select = true,
    --})
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})


-- References

-- Rust
-- https://sharksforarms.dev/posts/neovim-rust/
-- https://github.com/jakewies/.dotfiles/blob/main/nvim/.config/nvim/lua/jakewies/lsp.lua
-- https://github.com/jonhoo/configs/blob/master/editor/.config/nvim/init.vim

-- Go
-- https://www.getman.io/posts/programming-go-in-neovim/
