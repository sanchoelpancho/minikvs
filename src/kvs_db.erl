-module(kvs_db).

-export([initialize_db/0, stop_db/0]).

-include("kvs_db.hrl").

initialize_db() ->
    case mnesia:create_schema([node()]) of
        ok -> ok;
        {error, {_, {already_exists, _}}} -> ok
    end, 
    mnesia:start(), 
    case mnesia:create_table(kvs, [ 
        {attributes, record_info(fields, entry)},
        {record_name, entry}
    ]) of
        {atomic, ok} -> ok;
        {aborted, {already_exists, kvs}} -> ok
    end.


stop_db() ->
    mnesia:stop().