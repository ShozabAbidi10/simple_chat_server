# Simple Chat Server

This repository contains the code for a simple chat sever application developed in erlang using rebar3.

## How to build the application
1. Start with clone this repository to your local directory where you want to store the application code.

    ```bash
    git clone https://github.com/ShozabAbidi10/simple_chat_server.git
    ```

3. Make sure you are inside the project directory. Compile the application and build its release using the following command. 

    ```bash
    make
    ```

## How to run the application
To run the application follow the steps mentioned below.

1. Run the application using the following comamnd.

     ```bash
     make console
     ```
2. This will open the erlang shell where you can write erlang commands. Lets start the server
   
    ```erlang
    ServerState = simple_chat_handler:start_server().
    ```
   When the server has started successfully it will give you a success message on the shell.
   
4. Now, the server is started and we can connect to it. Open another tab on your terminal and run the following command.

   ```bash
   telnet localhost 8080
   ```
   Once you connect the chat server, it will ask you to enter for your name. Specify your name and join the server.

5. To have anotehr client of the chat server open another tab in your terminal and repeat the step 3.

6. To stop the server, go to the same terminal tab where you start the server. The erlang shell will still be running. Enter this comand to stop the server.

    ```erlang
    simple_chat_handler:stop_server(ServerState).
    ```
