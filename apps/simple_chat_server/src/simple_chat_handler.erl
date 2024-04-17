-module(simple_chat_handler).
-export([start_server/0]).

% Function to start the server
start_server() ->
    io:format("Starting TCP server on port 8080~n"),
    {ok, ListenSocket} = gen_tcp:listen(8080, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]),
    spawn(fun() -> accept_clients(ListenSocket) end),
    io:format("TCP server started successfully~n").


accept_clients(ListenSocket) ->
    {ok, ClientSocket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> accept_clients(ListenSocket) end),
    ask_for_username(ClientSocket).

ask_for_username(ClientSocket) ->
    gen_tcp:send(ClientSocket, "Enter your username: "),
    case gen_tcp:recv(ClientSocket, 0) of
        {ok, Username} ->
            io:format("Client ~s connected~n", [Username]),
            handle_client(ClientSocket, Username);
        {error, closed} ->
            ok
    end.

handle_client(ClientSocket, Username) ->
    WelcomeMessage = io_lib:format("Welcome to the chat!!! ~s", [Username]),
    gen_tcp:send(ClientSocket, WelcomeMessage),
    loop(ClientSocket, Username).

loop(ClientSocket, Username) ->
    case gen_tcp:recv(ClientSocket, 0) of
        {ok, _Data} ->
            loop(ClientSocket, Username);
        {error, closed} ->
            io:format("Client ~s closed connection~n", [Username])
    end.
