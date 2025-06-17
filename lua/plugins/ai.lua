return {
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = "InsertEnter",

    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("copilot").setup({
        panel = {
          auto_refresh = false,
          keymap = {
            accept = "<CR>",
            jump_prev = "[[",
            jump_next = "]]",
            refresh = "gr",
            open = "<M-CR>",
          },
        },
        suggestion = {
          enabled = false, -- disable suggestion popups
          -- auto_trigger = true,
          -- keymap = {
          -- 	accept = "<M-l>",
          -- 	prev = "<M-[>",
          -- 	next = "<M-]>",
          -- 	dismiss = "<C-]>",
          -- },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp", -- required for copilot-cmp to work
      -- "hrsh7th/cmp-buffer", -- optional, for buffer completion
      -- "hrsh7th/cmp-path",   -- optional, for path completion
    },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  -- {
  -- 	"CopilotC-Nvim/CopilotChat.nvim",
  -- 	branch = "main",
  -- 	dependencies = {
  -- 		{ "github/copilot.vim" },
  -- 		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  -- 	},
  -- 	opts = {
  -- 		debug = true, -- Enable debugging
  -- 		-- default mappings
  -- 		mappings = {
  -- 			complete = {
  -- 				detail = "Use @<Tab> or /<Tab> for options.",
  -- 				insert = "<Tab>",
  -- 			},
  -- 			close = {
  -- 				normal = "q",
  -- 				insert = "<C-c>",
  -- 			},
  -- 			reset = {
  -- 				normal = "<leader>gr",
  -- 				insert = "<C-g>r",
  -- 			},
  -- 			submit_prompt = {
  -- 				normal = "<CR>",
  -- 				insert = "<C-s>",
  -- 			},
  -- 			accept_diff = {
  -- 				normal = "<C-y>",
  -- 				insert = "<C-y>",
  -- 			},
  -- 			yank_diff = {
  -- 				normal = "gy",
  -- 				register = '"',
  -- 			},
  -- 			show_diff = {
  -- 				normal = "gd",
  -- 			},
  -- 			show_info = {
  -- 				normal = "gp",
  -- 			},
  -- 			show_context = {
  -- 				normal = "gs",
  -- 			},
  -- 		},
  --
  -- 		-- See Configuration section for rest
  -- 	},
  -- 	-- See Commands section for default commands if you want to lazy load on them
  -- },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "yetone/avante.nvim",
    dependencies = {
      "ravitemer/mcphub.nvim",
      "HakonHarnes/img-clip.nvim",
      "folke/snacks.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    },
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub and hub:get_active_servers_prompt() or ""
      end,
      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
      provider = "copilot",
      -- provider = "ollama",
      providers = {
        ollama = {
          __inherited_from = "openai",
          api_key_name = "",
          endpoint = "http://127.0.0.1:11434/v1",
          model = "phi4:14b",
        },
      },
      input = {
        provider = "snacks",
        provider_opts = {
          -- Snacks input configuration
          title = "Avante Input",
          icon = " ",
          placeholder = "Enter your API key...",
        },

      }
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
  },
}
