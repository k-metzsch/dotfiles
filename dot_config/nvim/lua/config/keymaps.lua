-- Global Language & Debug keymaps + which-key group icons

-- Safely add which-key groups with icons (requires which-key v3+)
local ok_wk, wk = pcall(require, "which-key")
if ok_wk and wk.add then
  wk.add({
    { "<leader>F", group = "Flutter", icon = { icon = "", color = "blue" } }, -- Flutter icon
    { "<leader>R", group = "Rust", icon = { icon = "", color = "orange" } }, -- Rust icon
    { "<leader>J", group = "JS/TS", icon = { icon = "󰛦", color = "yellow" } }, -- JS/TS (alt:  for JS, 󰛦 is TS)
    { "<leader>P", group = "Python", icon = { icon = "", color = "green" } }, -- Python icon
    { "<leader>G", group = "Go", icon = { icon = "", color = "cyan" } }, -- Go icon
  })
else
  -- Fallback (older which-key): still create groups (no icons)
  if ok_wk then
    wk.register({
      ["<leader>F"] = { name = "+Flutter" },
      ["<leader>R"] = { name = "+Rust" },
      ["<leader>J"] = { name = "+JS/TS" },
      ["<leader>P"] = { name = "+Python" },
      ["<leader>G"] = { name = "+Go" },
    })
  end
end

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
end

-- Helpers
local function has_command(cmd)
  return vim.fn.exists(":" .. cmd) == 2
end
local function notify_missing(what)
  vim.notify(what .. " not available (missing tool/plugin)", vim.log.levels.WARN)
end
local function run_in_split(cmd, title)
  title = title or cmd
  vim.cmd("botright 15split")
  vim.cmd("terminal " .. cmd)
  vim.cmd("file " .. title)
  vim.cmd("startinsert")
end
local function format_buffer()
  local ok_conform, conform = pcall(require, "conform")
  if ok_conform then
    conform.format({ async = true, lsp_fallback = true })
  else
    vim.lsp.buf.format({ async = true })
  end
end
local function fix_all()
  vim.lsp.buf.code_action({
    apply = true,
    context = { only = { "source.fixAll", "source.organizeImports" } },
  })
end

-----------------------------------------------------------------------
-- FLUTTER (<leader>F)
-----------------------------------------------------------------------
map("n", "<leader>Fr", function()
  if has_command("FlutterRun") then
    vim.cmd("FlutterRun")
  else
    notify_missing("FlutterRun")
  end
end, "Flutter: Run App")
map("n", "<leader>FR", function()
  if has_command("FlutterRestart") then
    vim.cmd("FlutterRestart")
  else
    notify_missing("FlutterRestart")
  end
end, "Flutter: Restart App")
map("n", "<leader>Fh", function()
  if has_command("FlutterReload") then
    vim.cmd("FlutterReload")
  else
    notify_missing("FlutterReload")
  end
end, "Flutter: Hot Reload")
map("n", "<leader>Fd", function()
  if has_command("FlutterDevices") then
    vim.cmd("FlutterDevices")
  else
    notify_missing("FlutterDevices")
  end
end, "Flutter: Select Device")
map("n", "<leader>Fe", function()
  if has_command("FlutterEmulators") then
    vim.cmd("FlutterEmulators")
  else
    notify_missing("FlutterEmulators")
  end
end, "Flutter: Select Emulator")
map("n", "<leader>Fo", function()
  if has_command("FlutterOutlineToggle") then
    vim.cmd("FlutterOutlineToggle")
  else
    notify_missing("FlutterOutlineToggle")
  end
end, "Flutter: Toggle Outline")
map("n", "<leader>Fq", function()
  if has_command("FlutterQuit") then
    vim.cmd("FlutterQuit")
  else
    notify_missing("FlutterQuit")
  end
end, "Flutter: Quit App")
map("n", "<leader>Ft", function()
  if has_command("FlutterRun") or has_command("FlutterReload") then
    run_in_split("flutter test", "flutter test")
  else
    notify_missing("flutter tool")
  end
end, "Flutter: Test Project")
map("n", "<leader>Ff", format_buffer, "Flutter: Format")
map("n", "<leader>FX", function()
  local xcworkspace = vim.fn.glob("ios/*.xcworkspace")
  if xcworkspace ~= "" then
    vim.fn.system({ "open", xcworkspace })
  else
    notify_missing("iOS .xcworkspace file")
  end
end, "Flutter: Open Xcode Workspace")

-----------------------------------------------------------------------
-- RUST (<leader>R)
-----------------------------------------------------------------------
map("n", "<leader>Rb", function()
  run_in_split("cargo build", "cargo build")
end, "Rust: Cargo Build")
map("n", "<leader>Rr", function()
  run_in_split("cargo run", "cargo run")
end, "Rust: Cargo Run")
map("n", "<leader>Rt", function()
  run_in_split("cargo test", "cargo test")
end, "Rust: Cargo Test")
map("n", "<leader>Rc", function()
  run_in_split("cargo check", "cargo check")
end, "Rust: Cargo Check")
map("n", "<leader>Rl", function()
  run_in_split("cargo clippy", "cargo clippy")
end, "Rust: Cargo Clippy")
map("n", "<leader>Rf", format_buffer, "Rust: Format")
map("n", "<leader>Ra", function()
  if has_command("RustLsp") then
    vim.cmd("RustLsp codeAction")
  else
    notify_missing("RustLsp")
  end
end, "Rust: Code Action")
map("n", "<leader>Rj", function()
  if has_command("RustLsp") then
    vim.cmd("RustLsp joinLines")
  else
    notify_missing("RustLsp")
  end
end, "Rust: Join Lines")
map("n", "<leader>Rk", function()
  if has_command("RustLsp") then
    vim.cmd("RustLsp hover actions")
  else
    notify_missing("RustLsp")
  end
end, "Rust: Hover Actions")

-----------------------------------------------------------------------
-- GO (<leader>G)
-----------------------------------------------------------------------
map("n", "<leader>Gb", function()
  run_in_split("go build ./...", "go build")
end, "Go: Build Project")
map("n", "<leader>Gr", function()
  -- Run current go file
  local file = vim.fn.expand("%")
  run_in_split("go run " .. vim.fn.fnameescape(file), "go run")
end, "Go: Run File")
map("n", "<leader>Gt", function()
  run_in_split("go test ./...", "go test")
end, "Go: Test Project")
map("n", "<leader>GT", function()
  -- Test current file
  local file = vim.fn.expand("%")
  run_in_split("go test " .. vim.fn.fnameescape(file), "go test file")
end, "Go: Test File")
map("n", "<leader>Gi", function()
  run_in_split("go install ./...", "go install")
end, "Go: Install Project")
map("n", "<leader>Gm", function()
  run_in_split("go mod tidy", "go mod tidy")
end, "Go: Tidy Modules")
map("n", "<leader>GF", format_buffer, "Go: Format")
map("n", "<leader>Ga", fix_all, "Go: Fix All (LSP Organize Imports etc.)")
map("n", "<leader>GV", function()
  if has_command("GoVenv") then
    vim.cmd("GoVenv")
  else
    notify_missing("GoVenv")
  end
end, "Go: Select Go Version")

-----------------------------------------------------------------------
-- JS / TS / React (<leader>J)
-----------------------------------------------------------------------
map("n", "<leader>Jo", function()
  if has_command("TSToolsOrganizeImports") then
    vim.cmd("TSToolsOrganizeImports")
  else
    notify_missing("TSToolsOrganizeImports")
  end
end, "JS/TS: Organize Imports")
map("n", "<leader>Jf", fix_all, "JS/TS: Fix All")
map("n", "<leader>Jr", function()
  if has_command("TSToolsRenameFile") then
    vim.cmd("TSToolsRenameFile")
  else
    notify_missing("TSToolsRenameFile")
  end
end, "JS/TS: Rename File")
map("n", "<leader>Ji", function()
  if has_command("TSToolsAddMissingImports") then
    vim.cmd("TSToolsAddMissingImports")
  else
    notify_missing("TSToolsAddMissingImports")
  end
end, "JS/TS: Add Missing Imports")
map("n", "<leader>Jx", function()
  if has_command("TSToolsRemoveUnused") then
    vim.cmd("TSToolsRemoveUnused")
  else
    notify_missing("TSToolsRemoveUnused")
  end
end, "JS/TS: Remove Unused")
map("n", "<leader>Jt", function()
  run_in_split("npm test --silent", "npm test")
end, "JS/TS: npm test")
map("n", "<leader>Js", function()
  run_in_split("npm run dev", "npm run dev")
end, "JS/TS: Start Dev")
map("n", "<leader>JF", format_buffer, "JS/TS: Format")

-----------------------------------------------------------------------
-- PYTHON (<leader>P)
-----------------------------------------------------------------------
map("n", "<leader>Pr", function()
  local file = vim.fn.expand("%")
  run_in_split("python -u " .. vim.fn.fnameescape(file), "python run")
end, "Python: Run File")
map("n", "<leader>Pt", function()
  local file = vim.fn.expand("%")
  run_in_split("pytest -q " .. vim.fn.fnameescape(file), "pytest file")
end, "Python: Test File")
map("n", "<leader>PF", format_buffer, "Python: Format (isort+black)")
map("n", "<leader>PV", function()
  if has_command("VenvSelect") then
    vim.cmd("VenvSelect")
  else
    notify_missing("VenvSelect")
  end
end, "Python: Select venv")
