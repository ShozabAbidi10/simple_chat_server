all: compile release client

compile:
	rebar3	 compile

release:
	rebar3	 release

clean:
	rebar3	clean

console:
	_build/default/rel/simple_chat_server/bin/simple_chat_server console