-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add more things to the ensure_installed table protecting against community packs modifying it
    
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.bsv = {
      install_info = {
        url = "https://github.com/yuyuranium/tree-sitter-bsv", -- local path or git repo
        files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
        -- optional entries:
        branch = "main", -- default branch in case of git repo if different from master
        generate_requires_npm = false, -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
      },
      filetype = "bsv", -- if filetype does not match the parser name
    }

    opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
      "lua",
      "vim",
      "bsv"
      -- add more arguments for adding more treesitter parsers
    })
  end,
}
