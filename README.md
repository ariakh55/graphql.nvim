# graphql.nvim

A GraphQL plugin for Neovim that provides an interactive interface for writing and executing GraphQL queries.

## Features

- Interactive GraphQL query editor
- Separate buffers for query, variables, headers, and results
- Easy execution of GraphQL queries with `<C-y>`
- JSON formatting of results using `jq`
- Support for custom headers and variables

## Requirements

- Neovim 0.5+
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- `jq` command-line JSON processor

## Installation

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

Add the following to your Neovim configuration:

```lua
use {
  'yourusername/graphql.nvim',
  requires = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('graphql').setup()
  end
}
```

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

Add the following to your Neovim configuration:

```lua
{
  'yourusername/graphql.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('graphql').setup()
  end
}
```

## Usage

1. Open Neovim and run the command `:Graphql`
2. Enter the GraphQL endpoint URL when prompted
3. Write your GraphQL query in the "Query" buffer
4. (Optional) Add variables in the "Variables" buffer
5. (Optional) Modify headers in the "Headers" buffer
6. Press `<C-y>` to execute the query
7. View the results in the "Results" buffer

## Commands

- `:Graphql`: Open the GraphQL interface
- `:CURL`: Perform a simple GET request to a specified URL
- `:GraphQLQuery`: Execute a single GraphQL query

## Configuration

Coming soon

You can customize the plugin by passing options to the setup function:

```lua
require('graphql').setup({
  -- Add your configuration options here
})
```

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
```

This README provides an overview of your plugin, its features, installation instructions for both Packer and Lazy, usage guidelines, available commands, and basic information about configuration, license, and contributing.

Remember to replace `'yourusername/graphql.nvim'` with the actual GitHub repository path where you'll host this plugin.

Also, consider adding more detailed configuration options, examples of usage, and any other relevant information as you continue to develop and expand the functionality of your plugin.
