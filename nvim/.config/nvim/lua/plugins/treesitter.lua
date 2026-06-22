-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it

    -- Register custom parser for BSV (new nvim-treesitter main branch API)
    vim.api.nvim_create_autocmd("User", {
      pattern = "TSUpdate",
      callback = function()
        require("nvim-treesitter.parsers").bsv = {
          install_info = {
            url = "https://github.com/yuyuranium/tree-sitter-bsv",
            branch = "main",
          },
        }
      end,
    })

    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "bsv"
      -- add more arguments for adding more treesitter parsers
    })
  end,
}
