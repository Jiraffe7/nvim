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
  vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format({ async=true }) end, bufopts)

  -- Syntax highlighting for LSP semantic tokens
  -- https://neovim.io/doc/user/lsp#lsp-semantic-highlight
  vim.api.nvim_set_hl(0, '@lsp.mod.documentation.rust', {link = 'Special'}) -- link to the group Special
  --vim.api.nvim_set_hl(0, '@lsp.mod.documentation.rust', {ctermfg=6, fg='#8ec07c'}) -- manually set to the same values as Special

  -- Hide all semantic highlights
  --for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  --  vim.api.nvim_set_hl(0, group, {})
  --end
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
  cmd = { "rust-analyzer" }, -- default
  -- cmd = { "rustup", "run", "stable", "rust-analyzer" }, -- run rust-analyzer when installed using rustup
  -- rust-analyzer settings
  -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
  settings = {
    ["rust-analyzer"] = {
      -- rust = {
      --   analyzerTargetDir = true
      -- },
      -- checkOnSave = false, -- should still get errors in the editor if you invoke build manually
      check = {
        command = "clippy",
	-- extraArgs = { "--target-dir", "/tmp/rust-analyzer-check" } -- https://github.com/rust-lang/rust-analyzer/issues/6007
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
	ST1006 = false, -- self is a contextually acceptable receiver name -- https://staticcheck.io/docs/checks/#ST1006
      },
      staticcheck = true,
    }
  }
}

lspconfig.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "pyright-langserver", "--stdio" },
  filetypes = { "python" },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  },
  single_file_support = true,
}

lspconfig.zls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
}


-- Setup Completion
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.confirm({
      --behavior = cmp.ConfirmBehavior.Replace, -- Insert is default
      select = true, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  }),

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
