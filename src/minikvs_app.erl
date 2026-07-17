%%%-------------------------------------------------------------------
%% @doc minikvs public API
%% @end
%%%-------------------------------------------------------------------

-module(minikvs_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    kvs_db:initialize_db(),
    {ok, _SupPid} = minikvs_sup:start_link(),
    %%%%%%%%%%%%%%%%% Cowboy HTTP listener code %%%%%%%%%%%%%%%%%%%%%%%%%%%
    Dispatch = cowboy_router:compile(kvs_router:routes()),
    cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ).

stop(_State) ->
    cowboy:stop_listener(my_http_listener),
    kvs_db:stop_db(),
    ok.

%% internal functions
