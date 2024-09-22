local curl = require('plenary.curl')
local json = vim.json

local M = {}

function M.sample_fetch(url)
  local response = curl.get(url)

  if response.status ~= 200 then
    error('GET request failed with status' .. response.status)
  end

  return response.body
end

function M.fetch_graphql(url, query, options)
  options = options or {}
  local headers = vim.tbl_extend('force', {
    content_type = 'application/json',
  }, options.headers or {})

  local response = curl.post(url, {
    headers = headers,
    body = json.encode({
      query = query,
      variables = options.variables or {}
    })
  })

  if response.status ~= 200 then
    error('GraphQL request failed with status' .. response.status)
  end

  return json.decode(response.body)
end

return M
