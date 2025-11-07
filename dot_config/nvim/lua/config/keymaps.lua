-- General terminal mapping
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true, desc = "Terminal: Exit to Normal mode" })

-- Helper for cleaner keymap definitions
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

local Terminal = require("toggleterm.terminal").Terminal
local my_term = nil

-- Function to open the terminal
local function term_run(cmd, title)
  title = title or cmd
  local win = vim.api.nvim_get_current_win()
  if not my_term or not my_term:is_open() then
    my_term = Terminal:new({
      cmd = cmd,
      direction = "horizontal",
      size = 12,
      name = title,
      close_on_exit = true,
    })
  end
  my_term:open()
  vim.api.nvim_set_current_win(my_term.window)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)
  vim.api.nvim_set_current_win(win)
end

-- Function to send Ctrl-C to the running job, then close the terminal
local function term_close()
  if my_term and my_term:is_open() then
    pcall(function()
      my_term:send("\003")
    end)
  end
end

-- Helper for commands that runs command in background an notifies
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

-- Which-key setup for top-level groups
local wk = require("which-key")
wk.add({
  { "<leader>d", group = "Debug", icon = "" },
  { "<leader>L", group = "Laravel", icon = "" },
  { "<leader>Lh", group = "IDE-Helper", icon = "" },
  { "<leader>P", group = "Python", icon = "" },
  { "<leader>F", group = "Flutter", icon = "" },
  { "<leader>Fb", group = "Build", icon = "" },
  { "<leader>Fp", group = "Pub", icon = "" },
  { "<leader>Fl", group = "Log", icon = "" },
  { "<leader>R", group = "Rust", icon = "" },
  { "<leader>G", group = "Go", icon = "" },
  { "<leader>p", desc = "Projects", icon = "" },
})

-- Show a close key only when a terminal is open
map("n", "<leader>C", function()
  if my_term and my_term:is_open() then
    term_close()
  else
    vim.notify("No terminal open", vim.log.levels.WARN, { title = "Terminal" })
  end
end, "Terminal: Stop and Close")

wk.add({
  {
    "<leader>X",
    desc = "Terminal: Stop and Close",
    cond = function()
      return my_term and my_term:is_open()
    end,
  },
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

map("n", "<leader>Lc", function()
  bg_run("composer install", "Composer Install")
end, "Composer Install")
map("n", "<leader>LR", function()
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
map("n", "<leader>Ls", function()
  bg_run(artisan .. "migrate:fresh --seed")
end, "Migrate Fresh + Seed")
map("n", "<leader>Lc", function()
  bg_run(artisan .. "route:clear")
end, "Clear routes")
map("n", "<leader>LC", function()
  bg_run(artisan .. "view:clear")
end, "Clear views")
map("n", "<leader>Ll", function()
  bg_run(artisan .. "route:list")
end, "Route List")

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

-- IDE Helper
map("n", "<leader>Lhi", function()
  bg_run("composer require --dev barryvdh/laravel-ide-helper", "Composer Install IDE-Helper")
end, "Composer Install")
map("n", "<leader>Lhg", function()
  bg_run(artisan .. "ide-helper:generate")
end, "Generate")
map("n", "<leader>Lhm", function()
  bg_run(artisan .. "ide-helper:models -RW")
end, "Models")
map("n", "<leader>Lhf", function()
  bg_run(artisan .. "ide-helper:meta")
end, "Meta")

-- Extra handy Laravel commands
map("n", "<leader>LQw", function()
  term_run(artisan .. "queue:work", "Queue Work")
end, "Queue Work (interactive)")
map("n", "<leader>LQr", function()
  bg_run(artisan .. "queue:restart")
end, "Queue Restart")

-----------------------------------------------------------------------
-- LARAVEL MAKE ENHANCEMENTS (<leader>Lm)
-----------------------------------------------------------------------
local function artisan_make(cmd, prompt_text, extra_args)
  term_run_with_input(artisan .. "make:" .. cmd, prompt_text or ("Make " .. cmd .. ":"), extra_args)
end

map("n", "<leader>Lm", function()
  local items = {
    { cmd = "model", label = "Model (-a: all artifacts)", extra = "-a" },
    { cmd = "model", label = "Model (+migration)", extra = "-m" },
    { cmd = "controller", label = "Controller", extra = nil },
    { cmd = "controller", label = "Controller (resource)", extra = "--resource" },
    { cmd = "controller", label = "Controller (invokable)", extra = "--invokable" },
    { cmd = "controller", label = "Controller (API)", extra = "--api" },
    { cmd = "migration", label = "Migration", extra = nil },
    { cmd = "seeder", label = "Seeder", extra = nil },
    { cmd = "factory", label = "Factory", extra = nil },
    { cmd = "request", label = "Form Request", extra = nil },
    { cmd = "resource", label = "API Resource", extra = nil },
    { cmd = "middleware", label = "Middleware", extra = nil },
    { cmd = "event", label = "Event", extra = nil },
    { cmd = "listener", label = "Listener", extra = nil },
    { cmd = "job", label = "Job", extra = nil },
    { cmd = "mail", label = "Mailable", extra = nil },
    { cmd = "notification", label = "Notification", extra = nil },
    { cmd = "provider", label = "Service Provider", extra = nil },
    { cmd = "cast", label = "Eloquent Cast", extra = nil },
    { cmd = "channel", label = "Broadcast Channel", extra = nil },
    { cmd = "component", label = "Blade Component", extra = nil },
    { cmd = "command", label = "Artisan Console Command", extra = nil },
    { cmd = "observer", label = "Observer", extra = nil },
    { cmd = "test", label = "Test (Feature/Pest)", extra = nil },
    { cmd = "test", label = "Test (Unit)", extra = "--unit" },
    { cmd = "view", label = "View (Laravel 11+)", extra = nil },
    { cmd = "scope", label = "Eloquent Scope (Laravel 11+)", extra = nil },
  }
  vim.ui.select(items, {
    prompt = "Artisan make:",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if not choice then
      return
    end
    artisan_make(choice.cmd, choice.label .. " name:", choice.extra)
  end)
end, "Artisan Make")

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
map("n", "<leader>Pm", function()
  term_run_with_input("python -m", "Run module (python -m):")
end, "Run Python Module")

-----------------------------------------------------------------------
-- FLUTTER (<leader>F)
-----------------------------------------------------------------------
-- Core run/reload/restart/session controls
map("n", "<leader>Fr", "<cmd>FlutterRun<cr>", "Run App")
map("n", "<leader>Fd", "<cmd>FlutterDebug<cr>", "Run in Debug Mode")
map("n", "<leader>Fh", "<cmd>FlutterReload<cr>", "Hot Reload")
map("n", "<leader>FR", "<cmd>FlutterRestart<cr>", "Hot Restart")
map("n", "<leader>Fq", "<cmd>FlutterQuit<cr>", "Quit App")
map("n", "<leader>FA", "<cmd>FlutterAttach<cr>", "Attach to App")
map("n", "<leader>FD", "<cmd>FlutterDetach<cr>", "Detach (keep running)")

-- Devices / Emulators
map("n", "<leader>Fs", "<cmd>FlutterDevices<cr>", "Select Device")
map("n", "<leader>Fe", "<cmd>FlutterEmulators<cr>", "Select Emulator")

-- Outline
map("n", "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", "Toggle Outline")
map("n", "<leader>FO", "<cmd>FlutterOutlineOpen<cr>", "Open Outline")

-- DevTools
map("n", "<leader>Fv", "<cmd>FlutterDevTools<cr>", "Start DevTools Server")
map("n", "<leader>FV", "<cmd>FlutterDevToolsActivate<cr>", "Activate DevTools")
map("n", "<leader>FP", "<cmd>FlutterCopyProfilerUrl<cr>", "Copy Profiler URL")

-- LSP helpers
map("n", "<leader>FL", "<cmd>FlutterLspRestart<cr>", "LSP Restart (Dart)")
map("n", "<leader>FS", "<cmd>FlutterSuper<cr>", "Go To Super")
map("n", "<leader>FN", "<cmd>FlutterReanalyze<cr>", "Reanalyze Project")
map("n", "<leader>Fz", "<cmd>FlutterRename<cr>", "Flutter Rename (updates imports)")

-- Logs
map("n", "<leader>Flc", "<cmd>FlutterLogClear<cr>", "Log: Clear")
map("n", "<leader>Flt", "<cmd>FlutterLogToggle<cr>", "Log: Toggle")

map("n", "<leader>Fc", function()
  bg_run("flutter clean", "flutter clean")
end, "flutter clean")
map("n", "<leader>Fg", function()
  term_run("flutter gen-l10n", "flutter gen-l10n")
end, "flutter gen-l10n")

-- Pubspec
map("n", "<leader>Fpg", function()
  bg_run("flutter pub get", "flutter pub get")
end, "flutter pub get")
map("n", "<leader>Fpu", function()
  bg_run("flutter pub upgrade", "flutter pub upgrade")
end, "flutter pub upgrade")
map("n", "<leader>Fpu", function()
  bg_run("flutter pub upgrade", "flutter pub upgrade --major-versions")
end, "flutter pub upgrade Major")
map("n", "<leader>Fpo", function()
  term_run("flutter pub outdated", "flutter pub outdated")
end, "flutter pub outdated")

-- Build
map("n", "<leader>Fba", function()
  term_run("flutter build apk", "flutter build apk")
end, "Build APK (release)")
map("n", "<leader>Fbb", function()
  term_run("flutter build appbundle", "flutter build appbundle")
end, "Build AppBundle (AAB)")
map("n", "<leader>Fbi", function()
  term_run("flutter build ios", "flutter build ios")
end, "Build iOS")
map("n", "<leader>Fbp", function()
  term_run("flutter build ipa", "flutter build ipa")
end, "Build IPA")

map("n", "<leader>Fy", function()
  term_run("flutter analyze", "flutter analyze")
end, "Flutter Analyze")
map("n", "<leader>Ff", function()
  bg_run("dart format .", "dart format .")
end, "Dart Format (project)")
map("n", "<leader>Ff", function()
  bg_run("dart run flutter_native_splash:create", "create splash")
end, "Dart create Splash screen")

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
map("n", "<leader>Rk", "<cmd>RustLsp hover actions<cr>", "Hover Actions")

map("n", "<leader>Rc", function()
  bg_run("cargo check", "Cargo Check")
end, "Cargo Check")
map("n", "<leader>Rl", function()
  bg_run("cargo clippy", "Cargo Clippy")
end, "Cargo Clippy")
map("n", "<leader>RF", function()
  bg_run("cargo fmt", "Cargo Format")
end, "Cargo Format")
map("n", "<leader>RO", function()
  term_run("cargo doc --open", "Cargo Doc")
end, "Cargo Doc --open")
map("n", "<leader>RR", function()
  term_run("cargo run --release", "Cargo Run (release)")
end, "Cargo Run Release")
map("n", "<leader>RT", function()
  term_run("cargo test", "Cargo Test")
end, "Cargo Test")
map("n", "<leader>RB", function()
  term_run("cargo bench", "Cargo Bench")
end, "Cargo Bench")

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
map("n", "<leader>Gb", "<cmd>GoBuild<cr>", "Build")
map("n", "<leader>Gv", "<cmd>GoVet<cr>", "Vet")
map("n", "<leader>Gf", "<cmd>GoFmt<cr>", "Format")
map("n", "<leader>Gg", "<cmd>GoGenerate<cr>", "Generate")
map("n", "<leader>GI", "<cmd>GoImpl<cr>", "Implement Interface")
map("n", "<leader>GA", "<cmd>GoAddTag<cr>", "Add Struct Tags")
map("n", "<leader>GR", "<cmd>GoRmTag<cr>", "Remove Struct Tags")
map("n", "<leader>GE", "<cmd>GoIfErr<cr>", "Insert if err")
map("n", "<leader>GF", "<cmd>GoFillStruct<cr>", "Fill Struct")
map("n", "<leader>GK", "<cmd>GoDoc<cr>", "Show Doc")
