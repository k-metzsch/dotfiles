-- lua/plugins/dap.lua
return {
  -----------------------------------------------------------------------------
  -- DAP and UI
  -----------------------------------------------------------------------------
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        opts = function()
          local dapui = require("dapui")
          return {
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            controls = {
              enabled = true,
              element = "repl",
              icons = {
                pause = "",
                play = "",
                step_into = "",
                step_over = "",
                step_out = "",
                step_back = "",
                run_last = "↻",
                terminate = "",
              },
            },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 0.25,
                position = "bottom",
              },
            },
            floating = {
              max_height = nil,
              max_width = nil,
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
            render = {
              max_type_length = nil,
            },
          }
        end,
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      {
        "nvim-neotest/nvim-nio",
      },
    },
    config = function()
      local dap = require("dap")
      -- Codelldb
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }
    end,
  },
}
