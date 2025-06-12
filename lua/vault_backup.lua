-- ~/.config/nvim/lua/vault_backup.lua

local last_push_file = vim.fn.stdpath("cache") .. "/vault_last_push"
local push_interval = 60 * 10 -- 10 minutes, change as needed

local function is_vault_file()
  local fname = vim.fn.expand("%:p")
  return fname:find(vim.fn.expand("$HOME/vaults/")) == 1
end

local function has_changes(vault_root)
  local handle = io.popen("cd '" .. vault_root .. "' && git status --porcelain")
  local result = handle:read("*a")
  handle:close()
  return result ~= ""
end

local function get_vault_root()
  local dir = vim.fn.expand("%:p:h")
  local home_vaults = vim.fn.expand("$HOME/vaults")
  while dir ~= "/" do
    if dir:find(home_vaults, 1, true) == 1 and vim.fn.isdirectory(dir .. "/.git") == 1 then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

local function last_push_time()
  local file = io.open(last_push_file, "r")
  if not file then
    return 0
  end
  local t = tonumber(file:read("*a"))
  file:close()
  return t or 0
end

local function update_last_push()
  local file = io.open(last_push_file, "w")
  if file then
    file:write(tostring(os.time()))
    file:close()
  end
end

local function vault_backup()
  local vault_root = get_vault_root()
  if not vault_root then
    return
  end
  if not has_changes(vault_root) then
    return
  end
  if (os.time() - last_push_time()) < push_interval then
    return
  end

  vim.notify("Vault backup started...", vim.log.levels.INFO, { title = "Vault Backup" })
  local commit_msg = "Auto backup: " .. os.date("%Y-%m-%d %H:%M:%S")
  local commit_cmd = "cd '" .. vault_root .. "' && git add . && git commit -m \"" .. commit_msg .. '"'

  vim.fn.jobstart({
    "bash",
    "-c",
    commit_cmd .. " && git push",
  }, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_exit = function(_, code, _)
      if code == 0 then
        update_last_push()
        vim.schedule(function()
          vim.notify("Vault backup finished.", vim.log.levels.INFO, { title = "Vault Backup" })
        end)
      else
        vim.schedule(function()
          vim.notify("Vault backup failed!", vim.log.levels.ERROR, { title = "Vault Backup" })
        end)
      end
    end,
  })
end

-- Autocmd on write and on quit for files in vault
vim.api.nvim_create_autocmd({ "BufWritePost", "VimLeavePre" }, {
  callback = function()
    if is_vault_file() then
      vault_backup()
    end
  end,
})
