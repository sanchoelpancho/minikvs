%%%-------------------------------------------------------------------
%% @doc minikvs public API
%% @end
%%%-------------------------------------------------------------------

-module(minikvs_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    minikvs_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
