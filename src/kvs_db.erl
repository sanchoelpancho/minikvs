-module(kvs_db).

-export([initialize_db/0, stop_db/0]).

-include("kvs_db.hrl").

initialize_db() ->
    application:set_env(mnesia, schema_location, ram),
    mnesia:start(), 
    mnesia:create_table(kvs, [ 
        {attributes, record_info(fields, entry)},
        {record_name, entry}
    ]).


stop_db() ->
    mnesia:stop().