-module(kvs_client).
-export([get/2, set/2]).

get(Server, Key) -> 
    Server ! {self(), {get, Key}},
    receive
        {ok, Value} -> 
            Value;
        {error} ->
            error
    end.

set(Server, {Key, Data}) ->
    Server ! {self(), {set, {Key, Data}}},
    receive
        {ok, {Key, Data}} ->
            {ok, {Key, Data}}
    end.

% delete(Server, Key) ->