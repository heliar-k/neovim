-- snacks.dashboard 启动页配置（替代 alpha.nvim）
-- 暂时移除自定义 ascii logo，使用 snacks 默认 header

-- ============================================================================
-- snacks.nvim 兼容补丁（自动检测并重新应用）
-- Issue:  https://github.com/folke/snacks.nvim/issues/2724
--          Neovim 0.12 下 dashboard buffer 被 wipe 时，augroup 可能已被核心
--          删除，再次 nvim_del_augroup_by_id 报 E367 "No such group: --Deleted--"
-- PR:     https://github.com/folke/snacks.nvim/pull/2725 （wrap with pcall，未合并）
-- 上游合并后（`:Lazy update` 拉入修复），本段检测到 pcall 已存在即自动失效，
-- 届时删除本段即可。注意：Lazy update 时若报 git 冲突，先
-- `git -C ~/.local/share/nvim/lazy/snacks.nvim checkout -- .` 重置后再 patch。
-- ============================================================================
local SNACKS_DASHBOARD = vim.fn.stdpath("data") .. "/lazy/snacks.nvim/lua/snacks/dashboard.lua"

local function patch_snacks_dashboard()
  local f = io.open(SNACKS_DASHBOARD, "r")
  if not f then
    return
  end
  local content = f:read("*a")
  f:close()
  -- 已打补丁或上游已修复，跳过
  if content:find("pcall(vim.api.nvim_del_augroup_by_id", 1, true) then
    return
  end
  -- 逐行匹配（不依赖上下文注释），仅替换那一行调用
  local line = "      vim.api.nvim_del_augroup_by_id(self.augroup)"
  local start = content:find(line, 1, true)
  if not start then
    return -- 上游代码结构已变，放弃打补丁
  end
  content = content:sub(1, start - 1)
    .. "      pcall(vim.api.nvim_del_augroup_by_id, self.augroup)"
    .. content:sub(start + #line)
  local w = assert(io.open(SNACKS_DASHBOARD, "w"))
  w:write(content)
  w:close()
end

patch_snacks_dashboard()

local M = {
  dashboard = {
    preset = {
      keys = {
        { icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
        { icon = "󰰉 ", key = "f", desc = "Find Files", action = ":lua require('snacks').picker.files({ hidden = true })" },
        { icon = "󰑭 ", key = "l", desc = "Recent Sessions", action = ":lua require('persistence').select()" },
        { icon = " ", key = "s", desc = "Settings", action = ":lua require('snacks').picker.files({ cwd = vim.fn.stdpath('config') })" },
        { icon = "󰚰 ", key = "u", desc = "Update Plugins", action = ":Lazy update" },
        { icon = "󰿅 ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "header", padding = 2 },
      { section = "keys", gap = 1, padding = 1 },
      {
        section = "recent_files",
        limit = 5,
        title = "Recent Files",
        gap = 1,
        -- 只显示本地文件，过滤 gitlens:// 等伪路径
        filter = function(file)
          return vim.startswith(file, "/") or vim.startswith(file, "~")
        end,
      },
    },
  },
}

-- 启动时自动显示（等价 alpha.nvim 行为：无文件参数时）
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      require("snacks").dashboard()
    end
  end,
  once = true,
})

return M
