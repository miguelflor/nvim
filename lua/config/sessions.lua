local M = {}

function M.setup()
  local ok, auto_session = pcall(require, "auto-session")
  if not ok then
    return
  end

  auto_session.setup({
    log_level = "error",
    auto_session_suppress_dirs = { "~/" },
    auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
    auto_session_enabled = true,
    auto_save_enabled = true,
    auto_restore_enabled = false,
    cwd_change_handling = {
      post_cwd_changed_hook = function()
        local telescope_ok, telescope = pcall(require, "telescope")
        if telescope_ok then
          pcall(telescope.load_extension, "projects")
        end
      end,
    },
  })
end

return M
