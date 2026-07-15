-module(kvs_server).
-export([start/0, loop/1]).

% -record(key_value_pair, {key, data}).

start() ->
    spawn(?MODULE, loop, [maps:new()]).
    

loop(Store) ->
    receive
        {Client, {get, Key}} -> 
            Reply = case maps:find(Key, Store) of
                {ok, Value} -> {ok, {Key, Value}};
                error -> {error, key_not_found}
            end,
            Client ! Reply,
            loop(Store);
        {Client, {set, {Key, Data}}} ->
            UpdatedStore = maps:put(Key, Data, Store),
            Client ! {ok, {Key, Data}, added},
            loop(UpdatedStore);
        {Client, {remove, Key}} ->
            UpdatedStore = maps:remove(Key, Store),
            Client ! {ok, Key, removed},
            loop(UpdatedStore)
    end.