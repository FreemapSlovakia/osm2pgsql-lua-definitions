# osm2pgsql Lua definitions for LuaLS

Lua type definitions for [osm2pgsql](https://osm2pgsql.org) designed for the
[Lua Language Server](https://luals.github.io). This provides completion,
hover docs, and diagnostics for the `osm2pgsql` Lua API when writing style
scripts.

## What's included

- `library/osm2pgsql.lua` type annotations for the public osm2pgsql Lua API.
- `config.json` LuaLS addon config to register the `osm2pgsql` global.

## Install

Clone the repo and point LuaLS at it.

Option A: use the addon config (recommended).

```json
{
  "Lua.workspace.userThirdParty": ["/path/to/osm2pgsql-lua-definitions"]
}
```

Option B: add the library folder directly.

```json
{
  "Lua.workspace.library": ["/path/to/osm2pgsql-lua-definitions/library"]
}
```

Restart the language server after updating settings.

## Example

```lua
local roads = osm2pgsql.define_table({
  name = "roads",
  ids = { type = "way", id_column = "osm_id" },
  columns = {
    { column = "name", type = "text" },
    { column = "geom", type = "linestring" },
  },
})

function osm2pgsql.process_way(object)
  if object.tags.highway then
    roads:insert({
      name = object.tags.name,
      geom = object:as_linestring(),
    })
  end
end
```

## License

MIT. See [LICENSE](./LICENSE).
