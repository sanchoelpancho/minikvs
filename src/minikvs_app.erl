%%%-------------------------------------------------------------------
%% @doc minikvs public API
%% @end
%%%-------------------------------------------------------------------

-module(minikvs_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    kvs_db:initialize_db(),
    minikvs_sup:start_link().

stop(_State) ->
    kvs_db:stop_db(),
    ok.

%% internal functions
