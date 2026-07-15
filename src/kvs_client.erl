-module(kvs_client).
-export([get/2, set/2, remove/2]).

get(Server, Key) -> 
    Server ! {self(), {get, Key}},
    receive
        {ok, {Key, Value}} -> 
            {ok, {Key, Value}};
        {error, key_not_found} ->
            {error, key_not_found}
    end.

set(Server, {Key, Data}) ->
    Server ! {self(), {set, {Key, Data}}},
    receive
        {ok, {Key, Data}, added} ->
            {ok, {Key, Data}, added}
    end.

remove(Server, Key) ->
    Server ! {self(), {delete, Key}},
    receive
        {ok, Key, removed} ->
            {ok, Key, removed}
    end.