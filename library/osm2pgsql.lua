---@meta

---@class Osm2pgsqlTable
local osm_table = {}

---Add data to a previously defined table
---@param row table<string, unknown>
---@return boolean, string, string, OsmObject
function osm_table:insert(row) end

---@class OsmGeometry
local osm_geometry = {}

---Returns the area of the geometry calculated on the projected coordinates.
---The area is calculated using the SRS of the geometry, the result is in map units.
---For any geometry type but (MULTI)POLYGON the result is always `0.0`.
---(See also `:spherical_area()`.)
---@return number
function osm_geometry:area() end

---Return the centroid (center of mass) of a geometry. Implemented for all geometry types.
---@return OsmGeometry
function osm_geometry:centroid() end

---Get the bounding box of this geometry.
---This function returns four result values: the lon/lat values for the bottom left corner of the bounding box, followed by the lon/lat values of the top right corner.
---Both lon/lat values are identical in case of points.
---Example: `lon, lat, dummy, dummy = object:as_polygon():centroid():get_bbox()`.
---If possible use the `get_bbox()` function on the OSM object instead, it is more efficient.
---@return number, number, number, number
function osm_geometry:get_bbox() end

---Returns an iterator for iterating over member geometries of a multi-geometry. See below for detail.
---@return unknown[]
function osm_geometry:geometries() end

---Returns the nth geometry (1-based) of a multi-geometry.
---@param index integer
---@return OsmGeometry
function osm_geometry:geometry_n(index) end

---Returns the type of geometry as a string.
---@return 'NULL' | 'POINT' | 'LINESTRING' | 'POLYGON' | 'MULTIPOINT' | 'MULTILINESTRING' | 'MULTIPOLYGON' | 'GEOMETRYCOLLECTION'
function osm_geometry:geometry_type() end

---Returns `true` if the geometry is a NULL geometry, `false` otherwise.
---@return boolean
function osm_geometry:is_null() end

---Returns the length of the geometry.
---For any geometry type but (MULTI)LINESTRING this is always `0.0`.
---The length is calculated using the SRS of the geometry, the result is in map units.
---@return integer
function osm_geometry:length() end

---Merge lines in a (MULTI)LINESTRING as much as possible into longer lines.
---@return OsmGeometry
function osm_geometry:line_merge() end

---Returns the number of geometries in a multi-geometry.
---Always 0 for NULL geometries and always 1 for non-multi geometries.
---@return integer
function osm_geometry:num_geometries() end

---Calculate “pole of inaccessibility” of a polygon, a point farthest away from the polygon boundary, sometimes called the center of the maximum inscribed circle.
---Note that for performance reasons this is an approximation.
---It is intended as a reasonably good labelling point.
---One optional parameter opts, which must be a Lua table with options.
---The only option currently defined is `stretch`.
---If this is set to a value larger than 1 an ellipse instead of a circle is inscribed.
---This might be useful for labels which usually use more space horizontally.
---Use a value between 0 and 1 for a vertical ellipse.
---@param opts? OsmPoleOptions
---@return OsmGeometry
function osm_geometry:pole_of_inaccessibility(opts) end

---Segmentize a (MULTI)LINESTRING, so that no segment is longer than max_segment_length.
---Result is a (MULTI)LINESTRING.
---@param max_segment_length? number
---@return OsmGeometry
function osm_geometry:segmentize(max_segment_length) end

---Simplify (MULTI)LINESTRING geometries with the Douglas-Peucker algorithm.
---(Currently not implemented for other geometry types.)
---@param tolerance? number
---@return OsmGeometry
function osm_geometry:simplify(tolerance) end

---Returns the area of the geometry calculated on the spheroid.
---The geometry must be in WGS 84 (4326).
---For any geometry type but (MULTI)POLYGON the result is always `0.0`. The result is in m². (See also `:area()`.)
---@return number
function osm_geometry:spherical_area() end

---Return SRID of the geometry.
---@return integer
function osm_geometry:srid() end

---Transform the geometry to the target SRS.
---@param target_srid? integer | string
---@return OsmGeometry
function osm_geometry:transform(target_srid) end

---@class OsmIdSpec
---@field type 'node' | 'way' | 'relation' | 'area' | 'any' | 'tile'
---@field id_column? string
---@field create_index? 'auto' | 'always' | 'unique' | 'primary_key'

---@class OsmColumnDef
---@field column string The name of the PostgreSQL column (required).
---@field type? 'text' | 'bool' | 'boolean' | 'int2' | 'smallint' | 'int4' | 'int' | 'integer' | 'int8' | 'bigint' | 'real' | 'hstore' | 'json' | 'jsonb' | 'direction' | 'geometry' | 'point' | 'linestring' | 'polygon' | 'multipoint' | 'multilinestring' | 'multipolygon' | 'geometrycollection' The type of the column (Optional, default `'text'`).
---@field sql_type? string The SQL type of the column (Optional, default depends on `type`, see next table).
---@field not_null? boolean Set to true to make this a `NOT NULL` column. (Optional, default `false`.)
---@field create_only? boolean Set to true to add the column to the `CREATE TABLE` command, but do not try to fill this column when adding data. This can be useful for `SERIAL` columns or when you want to fill in the column later yourself. (Optional, default `false`.)
---@field projection? integer | string On geometry columns only. Set to the EPSG id or name of the projection. (Optional, default web mercator, `3857`.)
---@field expire? Expire On geometry columns only. Set expire output.

---@class Expire
---@field string ExpireOutput The expire output defined with `osm2pgsql.define_expire_output()`.
---@field mode 'full-area' | 'boundary-only' | 'hybrid' How polygons are converted to tiles. Can be full-area (default), boundary-only, or hybrid.
---@field full_area_limit? number In `hybrid` mode, set the maximum area size for which a full-area expiry is done. Above this `boundary-only` is used.
---@field buffer number The size of the buffer around geometries to be expired as a fraction of the tile size.

---@class ExpireOutput

---@class ExpireConfig
---@field maxzoom? integer The maximum zoom level for which tile coordinates are written out. Default: `0`.
---@field minzoom? integer The minimum zoom level for which tile coordinates are written out. Optional. Default is the same as `maxzoom`.
---@field filename? string The filename of the output file. Optional.
---@field schema? string The database schema for the output table. The schema must exist in the database and be writable by the database user. Optional. By default the schema set with `--schema` is used, or `public` if that is not set.
---@field table? string The database table for the output. Optional.

---@class Index
---@field column? string | string[] The name of the column the index should be created on. Can also be an array of names. Required, unless `expression` is set.
---@field name? string Optional name of this index. (Default: Let PostgreSQL choose the name.)
---@field expression? string A valid SQL expression used for indexes on expressions. Can not be used together with `column`.
---@field include? string | string[] A column name or list of column names to include in the index as non-key columns. (Only available from PostgreSQL 11.)
---@field method? string The index method (‘btree’, ‘gist’, …). See the PostgreSQL docs for available types (required).
---@field tablespace? string The tablespace where the index should be created. Default is the tablespace set with `index_tablespace` in the table definition.
---@field unique? boolean Set this to `true` or `false` (default). Note that you have to make sure yourself never to add non-unique data to this column.
---@field where? string A condition for a partial index. This has to be set to a text that makes valid SQL if added after a `WHERE` in the `CREATE INDEX` command.

---@class OsmDefineTypeTableOpts
---@field schema? string                    Target PostgreSQL schema.
---@field data_tablespace? string           Tablespace for table data.
---@field index_tablespace? string          Tablespace for table indexes.
---@field cluster? "auto"|"no"              Clustering strategy; defaults to "auto".
---@field indexes? Index[]                  Index definitions; defaults to a GIST on first geometry column.

---@class OsmDefineTableOpts: OsmDefineTypeTableOpts
---@field name string                       The name of the table (without schema).
---@field columns OsmColumnDef[]            Column definitions.
---@field ids? OsmIdSpec                    Id handling; tables without ids cannot be updated.

---@class OsmPoleOptions
---@field stretch? number

---@class OsmMember
---@field type 'n' | 'w' | 'r'
---@field ref integer member ID
---@field role string

---@class OsmObject
---@field id integer
---@field type 'node' | 'way' | 'relation'
---@field tags table<string, string>
---@field version? integer
---@field timestamp? number
---@field changeset? integer
---@field uid? integer
---@field user? string
---@field is_closed boolean             Ways only: A boolean telling you whether the way geometry is closed, i.e. the first and last node are the same.
---@field nodes boolean                 Ways only: An array with the way node ids.
---@field members? OsmMember[]           Relations only: An array with member tables.
local osm_object = {}

---Create polygon geometry from OSM way object.
---@return OsmGeometry
function osm_object:as_polygon() end

---Create point geometry from OSM node object.
---@return OsmGeometry
function osm_object:as_point() end

---Create linestring geometry from OSM way object.
---@return OsmGeometry
function osm_object:as_linestring() end

---Create (multi)linestring geometry from OSM way/relation object.
---@return OsmGeometry
function osm_object:as_multilinestring() end

---Create (multi)polygon geometry from OSM way/relation object.
---@return OsmGeometry
function osm_object:as_multipolygon() end

---Create geometry collection from OSM relation object.
---@return OsmGeometry
function osm_object:as_geometrycollection() end

---@param key string
---@return string | nil
function osm_object:grab_tag(key) end

---@return number, number, number, number
function osm_object:get_bbox() end

---@class osm2pgsql
---@field stage number 1 or 2
osm2pgsql = {}

---@param opts OsmDefineTableOpts
---@return Osm2pgsqlTable
function osm2pgsql.define_table(opts) end

---@param name string
---@param columns OsmColumnDef[]
---@param options OsmDefineTypeTableOpts
---@return Osm2pgsqlTable
function osm2pgsql.define_node_table(name, columns, options) end

---@param name string
---@param columns OsmColumnDef[]
---@param options OsmDefineTypeTableOpts
---@return Osm2pgsqlTable
function osm2pgsql.define_way_table(name, columns, options) end

---@param name string
---@param columns OsmColumnDef[]
---@param options OsmDefineTypeTableOpts
---@return Osm2pgsqlTable
function osm2pgsql.define_area_table(name, columns, options) end

---@param name string
---@param columns OsmColumnDef[]
---@param options OsmDefineTypeTableOpts
---@return Osm2pgsqlTable
function osm2pgsql.define_relation_table(name, columns, options) end

---@param object ExpireConfig
---@return ExpireOutput
function osm2pgsql.define_expire_output(object) end

---Return VALUE if it is between MIN and MAX, MIN if it is smaller, or MAX if it is larger.
---All parameters must be numbers.
---If VALUE is `nil`, `nil` is returned.
---@param value number
---@param min number
---@param max number
---@return number
function osm2pgsql.clamp(value, min, max) end

---Returns `true` if the STRING starts with PREFIX.
---If STRING is `nil`, `nil` is returned.
---@param string string | nil
---@param prefix string
---@return boolean | nil
function osm2pgsql.has_prefix(string, prefix) end

---Returns `true` if the STRING ends with SUFFIX.
---If STRING is `nil`, `nil` is returned.
---@param string string | nil
---@param suffix string
---@return boolean | nil
function osm2pgsql.has_suffix(string, suffix) end

---Return a function that will check its only argument against the list of VALUES.
---If it is in that list, it will be returned, otherwise the DEFAULT (or nil) will be returned.
---@param values string[]
---@param default? string
---@return fun(string: string | nil): string | nil
function osm2pgsql.make_check_values_func(values, default) end

---Return a function that will remove all tags (in place) from its only argument if the key matches KEYS. KEYS is an array containing keys, key prefixes (ending in `*`), or key suffixes (starting with `*`).
---The generated function will return `true` if it removed all tags, `false` if there are still tags left.
---@param values string[]
---@return fun(tags: table<string, unknown>): nil
function osm2pgsql.make_clean_tags_func(values) end

---Split STRING on DELIMITER (default: ';' (semicolon)) and return an array table with the results.
---Items in the array will have any whitespace at beginning and end removed.
---If STRING is `nil`, `nil` is returned.
---@param string string| nil
---@param delimiter? string
---@return string[] | nil
function osm2pgsql.split_string(string, delimiter) end

---Split STRING of the form "VALUE UNIT" (something like "10 mph" or "20km") into the VALUE and the UNIT and return both.
---The VALUE must be a negative or positive integer or real number.
---The space between the VALUE and UNIT is optional.
---If there was no unit in the string, the DEFAULT_UNIT will be returned instead.
---Return `nil` if the STRING doesn't have the right pattern or is `nil`.
---@param string string | nil
---@param default_unit? string
---@return string | nil
function osm2pgsql.split_unit(string, default_unit) end

---Return STRING with whitespace characters removed from the beginning and end.
---If STRING is `nil`, `nil` is returned.
---@param string string: string | nil
---@return string | nil
function osm2pgsql.trim(string) end

---Return an array table with the ids of all node members of RELATION.
---@param relation OsmObject
---@return integer[]
function osm2pgsql.node_member_ids(relation) end

---Return an array table with the ids of all way members of RELATION.
---@param relation OsmObject
---@return integer[]
function osm2pgsql.way_member_ids(relation) end

---@class CommonGenOptions
---@field name string Identifier for this generalizer used for debug outputs and error message etc.
---@field debug? boolean Set to true to enable debug logging for this generalizer. Debug logging must also be enabled with `-l, --log-level=debug` on the command line.
---@field schema? string Database schema for all tables. Default: `public`.
---@field src_table string The table with the input data.
---@field dest_table string The table where generalizer output data is written to.
---@field geom_column? string The name of the geometry column in the input and output tables (default: geom). This is also used to find the extent of the input data.

---@class BuiltupGenOptions: CommonGenOptions
---@field src_tables string Comma-separated list of input table names in the order landuse layer, buildings layer, roads layer.
---@field image_extent? integer Width/height of the raster used for generalization (Default: 2048).
---@field image_buffer? integer Buffer used around the raster image (default: 0).
---@field min_area? number Drop output polygons smaller than this. Default: off
---@field margin? number The overlapping margin as a percentage of image_extent for raster processing of tiles.
---@field buffer_size? string Amount by which polygons are buffered in pixels. Comma-separated list for each input file.
---@field turdsize? integer
---@field zoom integer Zoom level.
---@field make_valid? boolean Make sure resulting geometries are valid.
---@field area_column? string Column name where to store the area of the result polygons.

---@class DiscreteIsolationGenOptions: CommonGenOptions
---@field id_column string The name of the id column in the source table.
---@field importance_column string The column in the source table with the importance metric. Column type must be a number type. Numbers must be positive, larger number means more important.

---@class RasterUnionGenOptions: CommonGenOptions
---@field image_extent? integer Width/height of the raster used for generalization (Default: 2048).
---@field margin? number The overlapping margin as a percentage of image_extent for raster processing of tiles.
---@field buffer_size? integer Amount by which polygons are buffered in pixels (Default: 10).
---@field zoom? integer Zoom level.
---@field group_by_column? string Name of a column in the source and destination tables used to group the geometries by some kind of classification (Optional).
---@field expire_list? string
---@field img_path? string Used to dump PNGs of the “before” and “after” images to a file for debugging.
---@field img_table? string Used to dump “before” and “after” raster images to the database for debugging. The table will be created if it doesn’t exist already.
---@field where? string Optional WHERE clause to add to the SQL query getting the input data from the database. Must be empty or a valid SQL snippet.

---@class RiversGenOptions: CommonGenOptions
---@field src_areas string Name of the input table with waterway areas.
---@field width_column string Name of the number type column containing the width of a feature.

---@class VectorUnionGenOptions: CommonGenOptions
---@field margin number
---@field buffer_size string Amount by which polygons are buffered in Mercator map units.
---@field group_by_column string Column to group data by. Same column is used in the output for classification.
---@field zoom integer Zoom level.
---@field expire_list string

---@class TileSqlGenOptions: CommonGenOptions
---@field sql string The SQL code to run.
---@field zoom integer Zoom level.

---@overload fun(strategy: 'builtup', options: BuiltupGenOptions): nil
---@overload fun(strategy: 'discrete-isolation', options: DiscreteIsolationGenOptions): nil
---@overload fun(strategy: 'raster-union', options: RasterUnionGenOptions): nil
---@overload fun(strategy: 'rivers', options: RiversGenOptions): nil
---@overload fun(strategy: 'vector-union', options: VectorUnionGenOptions): nil
---@overload fun(strategy: 'tile-sql', options: TileSqlGenOptions): nil
---@param strategy string Generalization strategy.
---@param options table
function osm2pgsql.run_gen(strategy, options) end

---@class RunSqlOptions
---@field description string Descriptive name or short text for logging.
---@field sql string The SQL command to run. The `sql` field can be set to a string or to an array of strings in which case the commands in those strings will be run one after the other.
---@field transaction? boolean Set to `true` to run the command(s) from the `sql` field in a transaction (Default: `false`).
---@field if_has_rows? string SQL command that is run first. If that SQL command returns any rows, the commands in `sql` are run, otherwise nothing is done. This can be used, to trigger generalizations only if something changed, for instance when an expire table contains something. Use a query like `SELECT 1 FROM expire_table LIMIT 1`. Default: none, i.e. the command in `sql` always runs.

---@param options RunSqlOptions
function osm2pgsql.run_sql(options) end

---@type fun(object: OsmObject): nil
osm2pgsql.process_relation = nil

---Called by osm2pgsql for each node.
---@type fun(object: OsmObject): nil
osm2pgsql.process_node = nil

---Called by osm2pgsql for each way.
---@type fun(object: OsmObject): nil
osm2pgsql.process_way = nil

---Called by osm2pgsql for each untagged node.
---@type fun(object: OsmObject): nil
osm2pgsql.process_untagged_node = nil

---Called by osm2pgsql for each untagged way.
---@type fun(object: OsmObject): nil
osm2pgsql.process_untagged_way = nil

---Called by osm2pgsql for each untagged relation.
---@type fun(object: OsmObject): nil
osm2pgsql.process_untagged_relation = nil

---@type fun(object: OsmObject): nil
osm2pgsql.process_deleted_node = nil

---@type fun(object: OsmObject): nil
osm2pgsql.process_deleted_way = nil

---@type fun(object: OsmObject): nil
osm2pgsql.process_deleted_relation = nil

---@type fun(): nil
osm2pgsql.process_gen = nil

---This function is called for every added, modified, or deleted relation.
---Its only job is to return the ids of all member ways of the specified relation we want to see in stage 2 again.
---It MUST NOT store any information about the relation!
---@type fun(relation: OsmObject): { ways?: number[], nodes?: number[] } | nil
osm2pgsql.select_relation_members = nil
