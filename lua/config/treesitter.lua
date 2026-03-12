local M = {}

function M.setup()
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  if not ok then
    return
  end

  configs.setup({
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "bash",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
      "javascript",
      "typescript",
      "tsx",
      "css",
      "html",
      "python",
      "java",
      "c",
      "cpp",
      "ocaml",
      "regex",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    playground = { enable = true },
  })

  local parser_dir = vim.fn.stdpath("data") .. "/site/parser"
  for _, lang in ipairs({ "flux", "menhir", "ocaml_interface" }) do
    local so = string.format("%s/%s.so", parser_dir, lang)
    if vim.fn.filereadable(so) == 1 then
      vim.treesitter.language.add(lang, { path = so })
    end
  end
end

return M
