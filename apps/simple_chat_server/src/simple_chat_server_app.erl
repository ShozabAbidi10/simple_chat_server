%%%-------------------------------------------------------------------
%% @doc simple_chat_server public API
%% @end
%%%-------------------------------------------------------------------

-module(simple_chat_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _Args) ->
    simple_chat_server_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
