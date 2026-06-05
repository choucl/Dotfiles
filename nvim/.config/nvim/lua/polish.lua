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

local osc52_group = vim.api.nvim_create_augroup("OSC52Yank", { clear = true })

local function osc52_copy(text)
  local b64 = vim.base64.encode(text)
  local seq = string.format("\027]52;c;%s\007", b64)

  io.stdout:write(seq)
  io.stdout:flush()
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = osc52_group,
  callback = function()
    local event = vim.v.event
    if event.operator ~= "y" then
      return
    end

    ---@type string[]
    local regcontents = event.regcontents

    local text = table.concat(regcontents, "\n")
    osc52_copy(text)
  end,
})
