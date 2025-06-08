return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      -- Variable to store the previous mouse status
      local mouse_status = vim.o.mouse
      local dap = require("dap")

      -- Enable mouse and save status when dap-ui opens
      dap.listeners.after["event_initialized"]["me"] = function()
        -- Save the current mouse status
        mouse_status = vim.o.mouse
        -- Enable the mouse
        vim.o.mouse = "a"
      end

      -- Restore mouse status when dap-ui closes
      -- Restore the saved mouse status
      dap.listeners.after["event_terminated"]["me"] = function()
        vim.o.mouse = mouse_status
      end
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "nvim-lua/plenary.nvim", -- Plenary provides TOML parsing and file handling
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local mason_registry = require("mason-registry")

      -- -- make sure codelldb is installed
      -- if not mason_registry.is_installed("codelldb") then
      --   print("Installing codelldb")
      --   mason_registry.get_package("codelldb"):install()
      -- end
      -- local codelldb_pkg = mason_registry.get_package("codelldb")
      -- if not codelldb_pkg then
      --   error("Could not find codelldb package in mason registry")
      -- end
      -- local codelldb_root = codelldb_pkg:get_install_path() .. "/extension/"
      --
      -- local codelldb_path = codelldb_root .. "adapter/codelldb"
      -- local liblldb_path = codelldb_root .. "lldb/lib/liblldb.dylib"
      --
      -- dap.adapters.lldb = {
      --   type = "executable",
      --   command = "/usr/bin/lldb",
      --   name = "lldb",
      -- }
      --
      -- dap.adapters.codelldb = {
      --   type = "server",
      --   host = "127.0.0.1",
      --   port = "${port}",
      --   executable = {
      --     command = codelldb_path,
      --     args = { "--liblldb", liblldb_path, "--port", "${port}" },
      --   },
      -- }
      --
      -- dap.configurations.zig = {
      --   {
      --     type = "codelldb",
      --     request = "launch",
      --     program = function()
      --       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      --     end,
      --     --program = '${fileDirname}/${fileBasenameNoExtension}',
      --     cwd = "${workspaceFolder}",
      --     terminal = "integrated",
      --   },
      -- }

      dapui.setup()
      require("dap-go").setup()

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      vim.keymap.set("n", "<Leader>dt", function()
        dap.toggle_breakpoint()
      end)
      vim.keymap.set("n", "<Leader>dc", function()
        dap.continue()
      end)
      vim.keymap.set("n", "<C-'>", function()
        dap.step_over()
      end)
      vim.keymap.set("n", "<C-;>", function()
        dap.step_into()
      end)
      vim.keymap.set("n", "<C-:>", function()
        dap.step_out()
      end)
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      local python_dap = require("dap-python")
      python_dap.setup("~/.virtualenvs/debugpy/bin/python")

      -- Add a new configuration for debugging the dynamically extracted module
      local dap = require("dap")
      table.insert(dap.configurations.python, {
        name = "Launch Module",
        type = "python",
        request = "launch",
        module = function()
          return vim.fn.input("module: ")
        end, -- Dynamically set the module from pyproject.toml
        console = "integratedTerminal",
      })
      -- Add configuration for launching a module with arguments (will prompt for args)
      table.insert(dap.configurations.python, {
        name = "Launch Module with Arguments",
        type = "python",
        request = "launch",
        module = function()
          return vim.fn.input("module: ")
        end, -- Dynamically set the module from pyproject.toml
        args = function()
          return vim.split(vim.fn.input("arguments: "), " ")
        end,
        console = "integratedTerminal",
      })
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        version = "1.x",
        build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
      },
    },
    config = function()
      require("dap-vscode-js").setup({
        debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      })
      for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
            name = "Attach debugger to existing `node --inspect` process",
            sourceMaps = true,
            resolveSourceMapLocations = {
              "${workspaceFolder}/**",
              "!**/node_modules/**",
            },
            cwd = "${workspaceFolder}/src",
            skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
          },
          {
            type = "pwa-chrome",
            name = "Launch Chrome to debug client",
            request = "launch",
            url = "http://localhost:5173",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}/src",
            skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
          },
          language == "javascript" and {
            type = "pwa-node",
            request = "launch",
            name = "Launch file in new node process",
            program = "${file}",
            cwd = "${workspaceFolder}",
          } or nil,
        }
      end
    end,
  },
}
