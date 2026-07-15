-module(kvs_client).
-export([get/1, set/2, remove/1]).

-include("kvs_db.hrl").

get(Key) -> 
    kvs_server ! {self(), {get, Key}},
    receive
        {ok, {Key, Value}} -> 
            {ok, {Key, Value}};
        {error, key_not_found} ->
            {error, key_not_found}
    end.

set(Key, Data) ->
    Entry = #entry{key = Key, data = Data},
    kvs_server ! {self(), {set, Entry}},
    receive
        {ok, {Key, Data}, added} ->
            {ok, {Key, Data}, added}
    end.

remove(Key) ->
    kvs_server ! {self(), {remove, Key}},
    receive
        {ok, Key, removed} ->
            {ok, Key, removed}
    end.