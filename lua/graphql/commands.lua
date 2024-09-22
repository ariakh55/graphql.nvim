local M = {}

function M.setup_commands()
  vim.api.nvim_create_user_command('Graphql', function(opts)
    require('graphql.buffer').open_graphql_buffer()
  end, {})

  vim.api.nvim_create_user_command('CURL', function(opts)
    local graphql = require('graphql')
    local url = vim.fn.input('Endpoint URL: ')
    local result = graphql.sample_fetch(url)

    vim.cmd('new')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.inspect(result), '\n'))
  end, {})

  vim.api.nvim_create_user_command('GraphQLQuery', function(opts)
    local graphql = require('graphql')

    local url = vim.fn.input('GraphQL Endpoint URL: ')
    local query = vim.fn.input('GraphQL Query: ')

    local result = graphql.fetch_graphql(url, query)

    vim.cmd('new')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(vim.inspect(result), '\n'))
  end, {})
end

return M
