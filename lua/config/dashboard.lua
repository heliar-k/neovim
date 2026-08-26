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
-- 注意：必须传入 win 让 dashboard 以普通窗口渲染，而不是浮窗。
-- 浮窗会盖住后开的 :Neotree 分屏（导致 neotree 无法显示），
-- 且浮窗下方背景窗口的 lualine 状态栏会从欢迎页底部透出
-- （即此前看到的 "powerline 状态栏"）。
local function is_empty_buf(buf)
  if vim.bo[buf].modified then
    return false
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return #lines == 0 or (#lines == 1 and lines[1] == "")
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      local prev_buf = vim.api.nvim_get_current_buf()
      local dash = require("snacks").dashboard({ win = vim.api.nvim_get_current_win() })
      -- 删除启动时残留的空 [No Name] buffer（已不在任何窗口显示），
      -- 否则它一直挂在 barbar 的 tabline 里（[buffer 1]）
      if prev_buf ~= dash.buf and vim.api.nvim_buf_get_name(prev_buf) == "" and is_empty_buf(prev_buf) then
        pcall(vim.api.nvim_buf_delete, prev_buf, { force = true })
      end
      -- 欢迎页不需要 buffer tab（barbar 的 tabline）：打开时隐藏，退出时恢复
      local prev_tabline = vim.o.showtabline
      vim.o.showtabline = 0
      vim.api.nvim_create_autocmd("BufWipeout", {
        buffer = dash.buf,
        once = true,
        callback = function()
          vim.o.showtabline = prev_tabline
        end,
      })
    end
  end,
  once = true,
})

return M
