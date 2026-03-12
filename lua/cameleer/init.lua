local M = {}

local defaults = {
  build = "dune build",
  test = "dune test",
  repl = "dune utop",
}

local function open_term(cmd)
  vim.cmd("botright split")
  vim.cmd("resize 12")
  vim.cmd("term " .. cmd)
end

function M.setup(opts)
  M.opts = vim.tbl_deep_extend("force", {}, defaults, opts or {})

  vim.filetype.add({
    extension = {
      flux = "flux",
      mly = "menhir",
      mli = "ocamlinterface",
    },
  })

  local group = vim.api.nvim_create_augroup("CameleerOcaml", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "ocaml", "ocamlinterface", "menhir", "flux" },
    callback = function(event)
      local bufnr = event.buf
      local function buf_map(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
      end
      buf_map("<leader>ob", M.build, "Dune build")
      buf_map("<leader>ot", M.test, "Dune test")
      buf_map("<leader>or", M.repl, "Launch utop")
    end,
  })

  vim.api.nvim_create_user_command("CameleerBuild", M.build, {})
  vim.api.nvim_create_user_command("CameleerTest", M.test, {})
  vim.api.nvim_create_user_command("CameleerRepl", M.repl, {})
end

function M.build()
  open_term(M.opts.build or defaults.build)
end

function M.test()
  open_term(M.opts.test or defaults.test)
end

function M.repl()
  open_term(M.opts.repl or defaults.repl)
end

return M
