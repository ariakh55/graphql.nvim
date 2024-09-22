if vim.g.loaded_gql_plugin then
  return
end

vim.g.loaded_gql_plugin = true

local function setup_commands()
  require('graphql.commands').setup_commands()
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = setup_commands,
  once = true
})

vim.g.graphql_setup = function(opts)
  opts = opts or {}
  setup_commands()
end
