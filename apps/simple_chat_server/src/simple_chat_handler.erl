-module(simple_chat_handler).
-export([start_server/0, stop_server/1]).

% Server state
-record(server_state, {
    listen_socket :: inet:socket(),
    clients :: [pid()]
}).

% Function to start the server
start_server() ->
    io:format("Starting TCP server on port 8080~n"),
    {ok, ListenSocket} = gen_tcp:listen(8080, [
        binary, {packet, 0}, {active, false}, {reuseaddr, true}
    ]),
    ServerState = #server_state{listen_socket = ListenSocket, clients = []},
    accept_clients(ServerState),
    io:format("TCP server started successfully~n"),
    ServerState.

accept_clients(ServerState) ->
    spawn(fun() -> loop_accept(ServerState) end).

loop_accept(ServerState) ->
    case gen_tcp:accept(ServerState#server_state.listen_socket) of
        {ok, ClientSocket} ->
            NewServerState = ServerState#server_state{clients = [ClientSocket | ServerState#server_state.clients]},
            spawn(fun() -> accept_clients(NewServerState) end),
            ask_for_username(ClientSocket);
        {error, closed} ->
            ok
    end.

% Function to stop the server
stop_server(ServerState) ->
    io:format("Stopping TCP server~n"),
    stop_accepting_clients(ServerState),
    close_clients(ServerState#server_state.clients),
    gen_tcp:close(ServerState#server_state.listen_socket).

% Function to stop accepting new client connections
stop_accepting_clients(ServerState) ->
    gen_tcp:close(ServerState#server_state.listen_socket).

% Function to close existing client connections
close_clients([]) ->
    ok;
close_clients([ClientSocket | Rest]) ->
    gen_tcp:send(ClientSocket, "We are closing the chat. Thanks for joining!"),
    gen_tcp:close(ClientSocket),
    close_clients(Rest).

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
