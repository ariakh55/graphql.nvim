local M = {}
local json = vim.json

M.current_endpoint = nil
M.buffers = {}

local function set_buffer_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set(
    'n', '<C-y>',
    function() M.execute_query() end,
    vim.tbl_extend('force', opts, { desc = "Execute GraphQL query" })
  )

  vim.keymap.set(
    'n', 'q', ':tabclose <CR>',
    vim.tbl_extend('force', opts, { desc = "Close GraphQL buffer" }))
end

local function create_buffer(name, content, filetype)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'hide'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = filetype

  vim.api.nvim_buf_set_name(buf, 'graphql://' .. name:lower())

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, '\n'))

  if not readonly then
    set_buffer_keymaps(buf)
  end

  return buf
end


function M.open_graphql_buffer()
  M.current_endpoint = vim.fn.input('Enter GraphQL Endpoint URL:')
  if M.current_endpoint == '' then
    print('No endpoint provided. Aborting.')
    return
  end

  vim.cmd('tabnew')

  M.buffers.query = create_buffer("Query", "# Write the query here", 'graphql')
  M.buffers.variables = create_buffer('Variables', "{\n  \n}", 'json')
  M.buffers.headers = create_buffer('Headers', "{\n  \"Content-Type\": \"application/json\"\n}", 'json')
  M.buffers.results = create_buffer('Results', "// Results will appear here after executing a query", 'json')

  vim.api.nvim_win_set_buf(0, M.buffers.query)

  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, M.buffers.results)

  vim.cmd('wincmd h')
  vim.cmd('split')
  vim.api.nvim_win_set_buf(0, M.buffers.variables)

  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, M.buffers.headers)

  vim.cmd('wincmd =')
  vim.cmd('wincmd t')
  vim.cmd('resize ' .. math.floor(vim.o.lines * 0.7))
  vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.65))

  vim.api.nvim_set_current_buf(M.buffers.query)
end

local function get_section_content(buf, start, end_)
  local lines = vim.api.nvim_buf_get_lines(buf, start, end_, false)

  return table.concat(lines, '\n')
end

function M.execute_query()
  local query = get_section_content(M.buffers.query, 0, -1)
  local variables = get_section_content(M.buffers.variables, 0, -1)
  local headers = get_section_content(M.buffers.headers, 0, -1)

  local variables_parsed, headers_parsed
  local success, err = pcall(function()
    variables_parsed = json.decode(variables)
    headers_parsed = json.decode(headers)
  end)

  if not success then
    vim.api.nvim_buf_set_lines(M.buffers.results, 0, -1, false, vim.split("Error parsing JSON: " .. err, '\n'))
    return
  end

  local result = require('graphql.requests').fetch_graphql(M.current_endpoint, query, {
    variables = variables_parsed,
    headers = headers_parsed
  })

  local formatted_result = json.encode(result)
  vim.api.nvim_buf_set_lines(M.buffers.results, 0, -1, false, vim.split(formatted_result, '\n'))

  vim.api.nvim_set_current_buf(M.buffers.results)
  vim.cmd(string.format('%%!jq "%s"','.'))

  vim.api.nvim_set_current_buf(M.buffers.query)
end

return M
