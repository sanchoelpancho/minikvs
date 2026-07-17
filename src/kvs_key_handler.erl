-module(kvs_key_handler).

-export([init/2]).

init(Req0, State) ->
    Method = cowboy_req:method(Req0),
    Key = cowboy_req:binding(key, Req0),
    Req1 = case Method of
        <<"GET">> ->
            Reply = case kvs_client:get(Key) of
                {ok, {GetKey, GetData}} -> {200, #{status => <<"found">>, key => GetKey, data => GetData}};
                {error, key_not_found}  -> {404, #{status => <<"key not found">>}}
            end,
            {Status, Map} = Reply,
            Body = json:encode(Map),
            cowboy_req:reply(
                Status,
                #{<<"content-type">> => <<"application/json">>},
                Body,
                Req0
            );
        <<"DELETE">> ->
            Reply = case kvs_client:remove(Key) of
                {ok, RemovedKey, removed} -> {200, #{status => <<"removed">>, key => RemovedKey}}
            end,
            {Status, Map} = Reply,
            Body = json:encode(Map),
            cowboy_req:reply(
                Status,
                #{<<"content-type">> => <<"application/json">>},
                Body,
                Req0
            );
        _ ->
            cowboy_req:reply(405, #{}, <<>>, Req0)
    end,
    {ok, Req1, State}.