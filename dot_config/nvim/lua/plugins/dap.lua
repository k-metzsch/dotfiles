return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio", -- required by dap-ui
    },
    config = function()
      local dap = require("dap")

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "⊗", texthl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignInfo", linehl = "Visual" })

      -- Python (debugpy adapter is provided by mason-nvim-dap)
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          console = "integratedTerminal",
          pythonPath = function()
            local venv = os.getenv("VIRTUAL_ENV")
            if venv and #venv > 0 and vim.fn.executable(venv .. "/bin/python") == 1 then
              return venv .. "/bin/python"
            end
            return "python"
          end,
        },
      }

      -- Rust (codelldb)
      dap.configurations.rust = {
        {
          name = "Debug executable",
          type = "codelldb",
          request = "launch",
          program = function()
            local cwd = vim.fn.getcwd()
            local exe_guess = cwd .. "/target/debug/" .. vim.fn.fnamemodify(cwd, ":t")
            if vim.fn.filereadable(exe_guess) == 1 then
              return exe_guess
            end
            return vim.fn.input("Path to executable: ", exe_guess, "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- JS/TS (node2). Config will be appended by handler once adapter exists.
      local js_cfg = {
        {
          name = "Launch file",
          type = "node2",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          name = "Attach (localhost:9229)",
          type = "node2",
          request = "attach",
          address = "127.0.0.1",
          port = 9229,
          restart = true,
          sourceMaps = true,
          protocol = "inspector",
        },
      }
      dap.configurations.javascript = js_cfg
      dap.configurations.typescript = js_cfg

      -- Dart / Flutter (basic)
      dap.configurations.dart = {
        {
          type = "dart",
          request = "launch",
          name = "Launch Dart Program",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },

  -- UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_autoopen"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_autoclose"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_autoclose"] = function()
        dapui.close()
      end
    end,
  },

  -- Mason integration (auto install adapters)
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "python", -- debugpy
        "codelldb", -- Rust
        "node2", -- JS/TS
        "dart", -- if registry supports
      },
      automatic_installation = true,
      handlers = {
        -- Default handler (just call default_setup)
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
        -- node2 custom to avoid early path warnings
        node2 = function(config)
          -- Let mason-nvim-dap figure out the path; no manual warning
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
}
