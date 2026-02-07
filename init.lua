-- ══════════════════════════════════════════════════════════════
--  Ultra · Neovim
--  macOS Terminal · Zero Plugins · Pure Lua · 0.11+
-- ══════════════════════════════════════════════════════════════

-- ── Leader ───────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Options ──────────────────────────────────────────────────

-- UI
vim.opt.number         = true
vim.opt.relativenumber = true          -- efficient j/k motions
vim.opt.signcolumn     = "yes"
vim.opt.cursorline     = true
vim.opt.termguicolors  = true
vim.opt.showmode       = false         -- mode shown in statusline
vim.opt.laststatus     = 3             -- single global statusline
vim.opt.pumheight      = 10
vim.opt.pumblend       = 10            -- popup transparency
vim.opt.winblend       = 10            -- float transparency
vim.opt.wrap           = false
vim.opt.linebreak      = true          -- break at word boundaries
vim.opt.breakindent    = true          -- indent wrapped lines
vim.opt.showbreak      = "↪ "
vim.opt.list           = true
vim.opt.listchars      = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars      = {
  eob       = " ",
  fold      = " ",
  foldopen  = "▾", foldclose = "▸", foldsep = " ",
  diff      = "╱",
  vert      = "│", horiz    = "─",
  horizup   = "┴", horizdown = "┬",
  vertleft  = "┤", vertright = "├", verthoriz = "┼",
}
vim.opt.shortmess:append("Ic")        -- no intro, no completion msgs
vim.opt.title = true                   -- show filename in terminal title

-- Behavior
vim.opt.mouse        = "a"
vim.opt.clipboard    = "unnamedplus"   -- macOS: pbcopy / pbpaste
vim.opt.updatetime   = 250
vim.opt.timeoutlen   = 400
vim.opt.confirm      = true            -- confirm before closing unsaved
vim.opt.virtualedit  = "block"         -- free cursor in visual block
vim.opt.inccommand   = "split"         -- live preview for :s substitution

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.hlsearch   = true

-- Indent
vim.opt.expandtab   = true
vim.opt.tabstop     = 4
vim.opt.shiftwidth  = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.shiftround  = true

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.splitkeep  = "screen"

-- Scrolling
vim.opt.scrolloff     = 8
vim.opt.sidescrolloff = 8
vim.opt.smoothscroll  = true

-- Folds
vim.opt.foldmethod     = "indent"
vim.opt.foldlevel      = 99
vim.opt.foldlevelstart = 99

-- Persistence
vim.opt.undofile   = true
vim.opt.undolevels = 10000
vim.opt.backup     = false
vim.opt.swapfile   = false

-- Command-line completion
vim.opt.wildmode       = "longest:full,full"
vim.opt.wildignorecase = true

-- Grep — prefer ripgrep
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg    = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- macOS terminal cursor
vim.opt.guicursor   = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.ttimeoutlen  = 10

-- ── Keymaps ──────────────────────────────────────────────────
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Visual line movement (respect wrapped lines)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window resize
map("n", "<C-Up>",    "<cmd>resize +2<CR>")
map("n", "<C-Down>",  "<cmd>resize -2<CR>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Stay in visual after indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Centered navigation
map("n", "n",     "nzzzv")
map("n", "N",     "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "G",     "Gzz")

-- Join without cursor jump
map("n", "J", "mzJ`z")

-- Paste over without losing register
map("x", "p", '"_dP')

-- ── Leader ───────────────────────────

map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save" })
map("n", "<leader>q", "<cmd>q<CR>",  { desc = "Quit" })
map("n", "<leader>a", "ggVG",        { desc = "Select all" })

-- Toggle netrw sidebar
map("n", "<leader>e", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "netrw" then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd("Lexplore")
end, { desc = "Toggle explorer" })

-- Buffer switcher
map("n", "<leader>b", function()
  local items = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted and vim.api.nvim_buf_is_loaded(b) then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= "" then
        table.insert(items, { bufnr = b, name = vim.fn.fnamemodify(name, ":~:.") })
      end
    end
  end
  if #items == 0 then return vim.notify("No buffers") end
  vim.ui.select(items, {
    prompt = "Buffer:",
    format_item = function(item) return item.name end,
  }, function(choice)
    if choice then vim.api.nvim_set_current_buf(choice.bufnr) end
  end)
end, { desc = "Switch buffer" })

-- Delete buffer
map("n", "<leader>x", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- File finder (fd > find fallback)
map("n", "<leader>f", function()
  local cmd = vim.fn.executable("fd") == 1
    and "fd -tf --hidden --exclude .git --max-results 500"
    or  "find . -type f -not -path '*/.git/*' | head -500"
  local files = vim.fn.systemlist(cmd)
  if #files == 0 then return vim.notify("No files found") end
  vim.ui.select(files, { prompt = "File:" }, function(choice)
    if choice then vim.cmd("edit " .. vim.fn.fnameescape(choice)) end
  end)
end, { desc = "Find file" })

-- Grep in files
map("n", "<leader>/", function()
  local pattern = vim.fn.input("Grep > ")
  if pattern == "" then return end
  vim.cmd("silent grep! " .. vim.fn.shellescape(pattern))
  vim.cmd("copen")
end, { desc = "Grep" })

-- Quickfix
map("n", "]q", "<cmd>cnext<CR>zz",  { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>zz",  { desc = "Prev quickfix" })

-- Diagnostics
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end,  { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float,                   { desc = "Diagnostic float" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })

-- Open URL / file under cursor (macOS)
map("n", "gx", function()
  local target = vim.fn.expand("<cfile>")
  if target ~= "" then vim.fn.jobstart({ "open", target }, { detach = true }) end
end, { desc = "Open with macOS" })

-- ── Toggles (<leader>t) ─────────────

map("n", "<leader>tw", "<cmd>set wrap!<CR>",            { desc = "Toggle wrap" })
map("n", "<leader>ts", "<cmd>set spell!<CR>",           { desc = "Toggle spell" })
map("n", "<leader>tn", "<cmd>set relativenumber!<CR>",  { desc = "Toggle relnumber" })
map("n", "<leader>tl", "<cmd>set list!<CR>",            { desc = "Toggle listchars" })

-- Zen mode — strip all distractions
local zen = false
map("n", "<leader>z", function()
  zen = not zen
  vim.opt.number         = not zen
  vim.opt.relativenumber = not zen
  vim.opt.signcolumn     = zen and "no" or "yes"
  vim.opt.laststatus     = zen and 0 or 3
  vim.opt.cursorline     = not zen
  vim.opt.list           = not zen
  vim.opt.showtabline    = zen and 0 or 1
  vim.notify(zen and "Zen on" or "Zen off")
end, { desc = "Toggle zen mode" })

-- ── Netrw ────────────────────────────────────────────────────
vim.g.netrw_banner    = 0
vim.g.netrw_liststyle = 3          -- tree view
vim.g.netrw_winsize   = 25

-- ── Diagnostics ──────────────────────────────────────────────
vim.diagnostic.config({
  underline        = true,
  virtual_text     = { spacing = 2 },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN]  = "▲",
      [vim.diagnostic.severity.HINT]  = "⚑",
      [vim.diagnostic.severity.INFO]  = "●",
    },
  },
  update_in_insert = false,
  severity_sort    = true,
  float            = { border = "rounded" },
})

-- ── Autocommands ─────────────────────────────────────────────
local au = function(name)
  return vim.api.nvim_create_augroup("ultra_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group    = au("yank"),
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

-- Remember last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = au("cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lc   = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lc then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-resize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  group   = au("resize"),
  command = "tabdo wincmd =",
})

-- Close helper windows with q
vim.api.nvim_create_autocmd("FileType", {
  group   = au("close_q"),
  pattern = { "help", "man", "qf", "checkhealth", "netrw" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf })
  end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = au("mkdir"),
  callback = function(args)
    if args.match:match("^%w%w+://") then return end
    local dir = vim.fn.fnamemodify(args.file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
  end,
})

-- Terminal: auto insert, hide chrome
vim.api.nvim_create_autocmd("TermOpen", {
  group = au("term"),
  callback = function()
    vim.opt_local.number         = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn     = "no"
    vim.cmd.startinsert()
  end,
})

-- Don't auto-continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = au("fmtopts"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- ── Statusline ───────────────────────────────────────────────
local mode_config = {
  ["n"]     = { "NORMAL",  "StlNormal"  }, ["no"]    = { "O-PEND",  "StlNormal"  },
  ["nov"]   = { "O-PEND",  "StlNormal"  }, ["noV"]   = { "O-PEND",  "StlNormal"  },
  ["no\22"] = { "O-PEND",  "StlNormal"  },
  ["niI"]   = { "NORMAL",  "StlNormal"  }, ["niR"]   = { "NORMAL",  "StlNormal"  },
  ["niV"]   = { "NORMAL",  "StlNormal"  }, ["nt"]    = { "NORMAL",  "StlNormal"  },
  ["v"]     = { "VISUAL",  "StlVisual"  }, ["vs"]    = { "VISUAL",  "StlVisual"  },
  ["V"]     = { "V-LINE",  "StlVisual"  }, ["Vs"]    = { "V-LINE",  "StlVisual"  },
  ["\22"]   = { "V-BLOCK", "StlVisual"  }, ["\22s"]  = { "V-BLOCK", "StlVisual"  },
  ["s"]     = { "SELECT",  "StlVisual"  }, ["S"]     = { "S-LINE",  "StlVisual"  },
  ["\19"]   = { "S-BLOCK", "StlVisual"  },
  ["i"]     = { "INSERT",  "StlInsert"  }, ["ic"]    = { "INSERT",  "StlInsert"  },
  ["ix"]    = { "INSERT",  "StlInsert"  },
  ["R"]     = { "REPLACE", "StlReplace" }, ["Rc"]    = { "REPLACE", "StlReplace" },
  ["Rx"]    = { "REPLACE", "StlReplace" },
  ["Rv"]    = { "V-REPL",  "StlReplace" }, ["Rvc"]   = { "V-REPL",  "StlReplace" },
  ["Rvx"]   = { "V-REPL",  "StlReplace" },
  ["c"]     = { "COMMAND", "StlCommand" }, ["cv"]    = { "EX",      "StlCommand" },
  ["ce"]    = { "EX",      "StlCommand" }, ["r"]     = { "PROMPT",  "StlCommand" },
  ["rm"]    = { "MORE",    "StlCommand" }, ["r?"]    = { "CONFIRM", "StlCommand" },
  ["!"]     = { "SHELL",   "StlCommand" }, ["t"]     = { "TERM",    "StlCommand" },
}

function Statusline()
  local m    = vim.api.nvim_get_mode().mode
  local info = mode_config[m] or { m:upper(), "StlNormal" }

  local name = vim.fn.expand("%:t")
  if name == "" then name = "[No Name]" end
  local mod = vim.bo.modified and " [+]" or ""
  local ro  = vim.bo.readonly and " [RO]" or ""

  local ft  = vim.bo.filetype
  local enc = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  local fmt = vim.bo.fileformat

  return table.concat({
    string.format("%%#%s# %s %%#StatusLine#", info[2], info[1]),
    "  ", name, mod, ro,
    "%=",
    ft ~= "" and (ft .. "  ") or "",
    enc, "[", fmt, "]",
    "  %l:%c  %p%% ",
  })
end

vim.opt.statusline = "%!v:lua.Statusline()"

-- ── Colors ───────────────────────────────────────────────────
local function set_highlights()
  local hi = vim.api.nvim_set_hl
  hi(0, "StlNormal",  { fg = "#1a1b26", bg = "#7aa2f7", bold = true })
  hi(0, "StlInsert",  { fg = "#1a1b26", bg = "#9ece6a", bold = true })
  hi(0, "StlVisual",  { fg = "#1a1b26", bg = "#bb9af7", bold = true })
  hi(0, "StlReplace", { fg = "#1a1b26", bg = "#f7768e", bold = true })
  hi(0, "StlCommand", { fg = "#1a1b26", bg = "#e0af68", bold = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group    = au("stl_colors"),
  callback = set_highlights,
})

set_highlights()
vim.cmd.colorscheme("habamax")
