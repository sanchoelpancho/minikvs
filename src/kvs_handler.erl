-module(kvs_handler).

-export([init/2]).

init(Req0, State) -> 
    Method = cowboy_req:method(Req0),
    Key = cowboy_req:binding(key, Req0),
    Req1 = case Method of
        <<"GET">> -> 
            case kvs_client:get(Key) of
                {ok, {Key, Value}}      -> Reply = {200, #{status => <<"found">>, key => Key, value => <<Value>>}};
                {error, key_not_found}  -> Reply = {404, #{status => <<"key not found">>}}
            end,
            {Status, Body} = Reply,
        cowboy_req:reply(Status,
                #{<<"content-type">> => <<"application/json">>},
                Body,
                Req0);
        _ ->
            cowboy_req:reply(405, #{}, <<>>, Req0)
    end,
    {ok, Req1, State}.