local nightfox = require('nightfox')

-- This function set the configuration of nightfox. If a value is not passed in the setup function
-- it will be taken from the default configuration above
nightfox.setup({
  -- fox = "nordfox", -- change the colorscheme to use nordfox
  options = {
    styles = {
      comments = "italic", -- change style of comments to be italic
      keywords = "bold", -- change style of keywords to be bold
      functions = "bold" -- styles can be a comma separated list
    },
    inverse = {
      match_paren = true, -- inverse the highlighting of match_parens
    }
  },
  palettes = {
    -- red = "#FF000", -- Override the red color for MAX POWER
    -- bg_alt = "#000000",
  },
  groups = {
    all = {
      type = { fg = "#88C0D0" }
    }
  }
})

vim.cmd [[
try
  colorscheme nordfox
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
