local M = {}

function M.setup()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    return
  end

  vim.g.vsnip_snippet_dirs = {
    vim.fn.stdpath("config") .. "/snippets", -- custom ones,
    vim.fn.stdpath("data") .. "/site/pack/packer/start/friendly-snippets/snippets" }

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    if col == 0 then
      return false
    end
    local current_line = vim.api.nvim_get_current_line()
    return current_line:sub(col, col):match("%s") == nil
  end

  local feedkey = function(key)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n", true)
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered({ border = "rounded" }),
      documentation = cmp.config.window.bordered({ border = "rounded" }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          feedkey("<Plug>(vsnip-expand-or-jump)")
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          feedkey("<Plug>(vsnip-jump-prev)")
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "vsnip" },
      { name = "path" },
    }, {
      { name = "buffer" },
    }),
  })

  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })

  local ok_pairs, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
  if ok_pairs then
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

return M
