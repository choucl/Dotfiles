-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = false, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        swapfile = false -- sets vim.opt.swapfile
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      i = {
        ["<C-L>"] = { 'copilot#Accept("\\<CR>")', expr = true, replace_keycodes = false },
      },
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>a"] = { desc = "Gen (Ollama local AI)" },
        ["<Leader>as"] = { ":Gen Summarize<cr>", desc = "Generate summary" },
        ["<Leader>ac"] = { ":Gen Chat<cr>", desc = "Generate chat" },
        ["<Leader>ar"] = { ":Gen Review_Code<cr>", desc = "Generate code review" },
        ["<Leader>aa"] = { ":Gen Ask<cr>", desc = "Ask a question" },

        -- git hunk navigation
        ["<leader>gj"] = { ":Gitsigns next_hunk<cr>", desc = "Go to next Git hunk" },
        ["<leader>gk"] = { ":Gitsigns prev_hunk<cr>", desc = "Go to previous Git hunk" },

        -- language server diagnostics
        ["<leader>lj"] = { vim.diagnostic.goto_next, desc = "Jump to next diagnostic" },
        ["<leader>lk"] = { vim.diagnostic.goto_prev, desc = "Jump to previous diagnostic" },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
      v = {
        ["<Leader>a"] = { desc = "Gen (Ollama local AI)" },
        ["<Leader>as"] = { ":Gen Summarize<cr>", desc = "Generate summary" },
        ["<Leader>ar"] = { ":Gen Review_Code<cr>", desc = "Generate code review" },
        ["<Leader>aa"] = { ":Gen Ask<cr>", desc = "Ask a question" },
        ["<Leader>ac"] = { ":Gen Add_Comment<cr>", desc = "Add a comment" },
      }
    },
  },
}
