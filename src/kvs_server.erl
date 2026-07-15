-module(kvs_server).
-export([start_link/0, loop/0]).

-include("kvs_db.hrl").

start_link() ->
    Pid = spawn_link(?MODULE, loop, []),
    register(kvs_server, Pid),
    {ok, Pid}.
    

loop() ->
    receive
        {Client, {get, Key}} -> 
            Reply = case mnesia:transaction(fun() -> mnesia:read(kvs, Key) end) of
                {atomic, [#entry{key = Key, data = Value}]}     ->      {ok, {Key, Value}};
                {atomic, []}                                    ->      {error, key_not_found}
            end,
            Client ! Reply,
            loop();
        {Client, {set, Entry}} ->
            Reply = case mnesia:transaction(fun() -> mnesia:write(kvs, Entry, write) end) of
                {atomic, ok}                                    ->      {ok, {Entry#entry.key, Entry#entry.data}, added}
            end,
            Client ! Reply,
            loop();
        {Client, {remove, Key}} ->
            Reply = case mnesia:transaction(fun() -> mnesia:delete({kvs, Key}) end) of
                {atomic, ok}                                    ->      {ok, Key, removed}
            end,
            Client ! Reply,
            loop();
        Other ->
            io:format("Unexpected message: ~p~n", [Other]),
            loop()
    end.