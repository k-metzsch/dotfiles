-- General terminal mapping
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal: Exit to Normal mode" })

-- Helper for cleaner keymap definitions
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

-- Helper to run commands in a terminal split
local function term_run(cmd, title)
  title = title or cmd
  vim.cmd("botright 12split | terminal " .. cmd)
  vim.cmd("file " .. title)
  vim.cmd("startinsert")
end

local function bg_run(cmd, title)
  title = title or cmd
  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        vim.notify(table.concat(data, "\n"), vim.log.levels.INFO, { title = title })
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Command exited with code: " .. code, vim.log.levels.WARN, { title = title })
      end
    end,
  })
end

-- Helper for commands that need user input
local function term_run_with_input(base_cmd, prompt_text, extra_args)
  vim.ui.input({ prompt = prompt_text }, function(answer)
    if answer and #answer > 0 then
      local cmd = base_cmd .. " " .. answer
      if extra_args then
        cmd = cmd .. " " .. extra_args
      end
      bg_run(cmd, cmd)
    end
  end)
end

-- Universal format command
map("n", "<leader>=", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, "Format Document")

-- Which-key setup for top-level groups
local wk = require("which-key")
wk.add({
  { "<leader>d", group = "Debug", icon = "" },
  { "<leader>L", group = "Laravel", icon = "" },
  { "<leader>P", group = "Python", icon = "" },
  { "<leader>F", group = "Flutter", icon = "" },
  { "<leader>R", group = "Rust", icon = "" },
  { "<leader>G", group = "Go", icon = "" },
  { "<leader>p", desc = "Projects", icon = "" },
})

-- Dashboard project picker
local alpha_ok, alpha = pcall(require, "alpha")
if alpha_ok then
  alpha.add_mapping("p", "<cmd>Telescope projects<cr>", {
    desc = "Projects",
    hl = "AlphaButtons",
    keymap = { "n" },
  })
end

-----------------------------------------------------------------------
-- DAP (DEBUG) KEYMAPS (<leader>d)
-----------------------------------------------------------------------
map("n", "<leader>db", require("dap").toggle_breakpoint, "Debug: Toggle Breakpoint")
map("n", "<leader>dc", require("dap").continue, "Debug: Continue")
map("n", "<leader>di", require("dap").step_into, "Debug: Step Into")
map("n", "<leader>do", require("dap").step_over, "Debug: Step Over")
map("n", "<leader>dO", require("dap").step_out, "Debug: Step Out")
map("n", "<leader>dr", require("dap").repl.open, "Debug: Open REPL")
map("n", "<leader>dl", require("dap").run_last, "Debug: Run Last")
map("n", "<leader>du", require("dapui").toggle, "Debug: Toggle UI")
map("n", "<leader>dt", require("dap").terminate, "Debug: Terminate")

-----------------------------------------------------------------------
-- LARAVEL (<leader>L)
-----------------------------------------------------------------------
local artisan = "php artisan "
-- Removed: terminal-based Phpactor call. Native Phpactor mappings are in lang-laravel.lua.

map("n", "<leader>Lc", function()
  bg_run("composer install", "Composer Install")
end, "Composer Install")
map("n", "<leader>LC", function()
  term_run("composer run dev", "Composer Dev")
end, "Composer Run Dev")

map("n", "<leader>Lt", function()
  term_run(artisan .. "tinker")
end, "Tinker")
map("n", "<leader>LT", function()
  term_run(artisan .. "test")
end, "Run Tests")

-- Migrations and Seeding
map("n", "<leader>Lm", function()
  bg_run(artisan .. "migrate")
end, "Migrate")
map("n", "<leader>LM", function()
  bg_run(artisan .. "migrate:fresh")
end, "Migrate Fresh")
map("n", "<leader>Lr", function()
  bg_run(artisan .. "migrate:rollback")
end, "Rollback")
map("n", "<leader>LD", function()
  bg_run(artisan .. "db:seed")
end, "DB Seed")
map("n", "<leader>LMS", function()
  bg_run(artisan .. "migrate:fresh --seed")
end, "Migrate Fresh + Seed")

-- Cache and Config
map("n", "<leader>Lo", function()
  bg_run(artisan .. "optimize")
end, "Optimize")
map("n", "<leader>LO", function()
  bg_run(artisan .. "optimize:clear")
end, "Optimize Clear")
map("n", "<leader>Lk", function()
  bg_run(artisan .. "cache:clear")
end, "Cache Clear")
map("n", "<leader>Lg", function()
  bg_run(artisan .. "config:clear")
end, "Config Clear")
map("n", "<leader>LG", function()
  bg_run(artisan .. "config:cache")
end, "Config Cache")

-- Make commands
map("n", "<leader>Lmm", function()
  term_run_with_input(artisan .. "make:model", "Make Model:", "-m")
end, "Make Model (+ mig)")
map("n", "<leader>Lmc", function()
  term_run_with_input(artisan .. "make:controller", "Make Controller:")
end, "Make Controller")
map("n", "<leader>Lmi", function()
  term_run_with_input(artisan .. "make:migration", "Make Migration:")
end, "Make Migration")

-- IDE Helper
map("n", "<leader>Lhg", function()
  bg_run(artisan .. "ide-helper:generate", "IDE-Helper Generate")
end, "IDE-Helper Generate")
map("n", "<leader>Lhm", function()
  bg_run(artisan .. "ide-helper:models --nowrite", "IDE-Helper Models")
end, "IDE-Helper Models Write")
map("n", "<leader)Lhf", function()
  bg_run(artisan .. "ide-helper:meta", "IDE-Helper Meta")
end, "IDE-Helper Meta")

-----------------------------------------------------------------------
-- PYTHON (<leader>P)
-----------------------------------------------------------------------
map("n", "<leader>PV", "<cmd>VenvSelect<cr>", "Select VirtualEnv")
map("n", "<leader>Pv", "<cmd>VenvSelectCached<cr>", "Select Cached VirtualEnv")
map("n", "<leader>Pc", function()
  vim.ui.input({ prompt = "Venv name: " }, function(name)
    if name then
      bg_run("python -m venv " .. name, "Create Venv")
    end
  end)
end, "Create VirtualEnv")
map("n", "<leader>Pi", function()
  vim.ui.input({ prompt = "Pip install: " }, function(pkg)
    if pkg then
      bg_run("pip install " .. pkg, "Pip Install")
    end
  end)
end, "Pip Install")
map("n", "<leader>Pr", function()
  term_run("python -u " .. vim.fn.expand("%:p"), "Python Run")
end, "Run File")
map("n", "<leader>Pt", function()
  term_run("pytest -v " .. vim.fn.expand("%:p"), "Pytest File")
end, "Test File")

-----------------------------------------------------------------------
-- FLUTTER (<leader>F)
-----------------------------------------------------------------------
map("n", "<leader>Fr", "<cmd>FlutterRun<cr>", "Run App")
map("n", "<leader>FR", "<cmd>FlutterRestart<cr>", "Hot Restart")
map("n", "<leader>Fh", "<cmd>FlutterReload<cr>", "Hot Reload")
map("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", "Quit App")
map("n", "<leader>Fd", "<cmd>FlutterDevices<cr>", "Select Device")
map("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", "Toggle Outline")
map("n", "<leader>Fa", "<cmd>PubspecAssistAdd<cr>", "Add Dependency")
map("n", "<leader>Fu", "<cmd>PubspecAssistUpdate<cr>", "Update Dependencies")
map("n", "<leader>FX", function()
  local xcworkspace = vim.fn.glob("ios/*.xcworkspace")
  if xcworkspace ~= "" and vim.fn.filereadable(xcworkspace) == 1 then
    vim.fn.system({ "open", xcworkspace })
    vim.notify("Opening Xcode workspace...", vim.log.levels.INFO)
  else
    vim.notify("No .xcworkspace found in ios/ directory", vim.log.levels.WARN)
  end
end, "Open Xcode Workspace")

-----------------------------------------------------------------------
-- RUST (<leader>R)
-----------------------------------------------------------------------
map("n", "<leader>Rr", "<cmd>RustLsp run<cr>", "Run")
map("n", "<leader>Rt", "<cmd>RustLsp test<cr>", "Test")
map("n", "<leader>Rb", "<cmd>RustLsp build<cr>", "Build")
map("n", "<leader>Rd", "<cmd>RustLsp debug<cr>", "Debug")
map("n", "<leader>Rc", function()
  bg_run("cargo check", "Cargo Check")
end, "Cargo Check")
map("n", "<leader>Rl", function()
  bg_run("cargo clippy", "Cargo Clippy")
end, "Cargo Clippy")
map("n", "<leader>Rk", "<cmd>RustLsp hover actions<cr>", "Hover Actions")
map("n", "<leader>Ra", vim.lsp.buf.code_action, "Code Action")

-----------------------------------------------------------------------
-- GO (<leader>G)
-----------------------------------------------------------------------
map("n", "<leader>Gr", "<cmd>GoRun<cr>", "Run")
map("n", "<leader>Gt", "<cmd>GoTest<cr>", "Test")
map("n", "<leader>GT", "<cmd>GoTestFunc<cr>", "Test Function")
map("n", "<leader>Gc", "<cmd>GoCoverage<cr>", "Test Coverage")
map("n", "<leader>Gd", function()
  require("dap").run({ type = "go", name = "Debug Test", request = "launch", mode = "test", program = "${fileDirname}" })
end, "Debug Test")
map("n", "<leader>Gm", "<cmd>GoModTidy<cr>", "Tidy Modules")
map("n", "<leader>Gi", "<cmd>GoInstall<cr>", "Install")
map("n", "<leader>Ge", "<cmd>GoAlternate<cr>", "Go to Test file")
