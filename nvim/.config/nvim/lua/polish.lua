-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

vim.filetype.add {
  pattern = {
    [".*sva"] = "systemverilog",
    [".*svh"] = "systemverilog",
    [".cl"] = "cpp",
  },
  extension = {
    bsv = "bsv",
    systemverilog = "sv"
  }
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "csv", "tsv" },
  callback = function()
    pcall(vim.cmd, "CsvViewEnable")
  end,
  desc = "Auto enable csvview for csv/tsv",
})

-- Create an augroup to prevent duplicate event listeners if you reload your config
local osc52_group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
    group = osc52_group,
    callback = function()
        local event = vim.v.event

        -- trigger only with y
        if event.operator == 'y' then
            -- event.regcontents contains the yanked text as a table of lines
            local text = table.concat(event.regcontents, "\n")
            -- Base64 encode the text
            local b64 = vim.base64.encode(text) -- Neovim 0.10+
            -- Construct and send the OSC 52 sequence
            local osc52_seq = string.format("\x1b]52;c;%s\x07", b64)
            io.stderr:write(osc52_seq)
        end
    end,
})
