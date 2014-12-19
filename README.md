# Bash Websocket Server

This is a websocket server written in bash that uses `netcat` and `openssl`. I made it because I needed a way to send something like a push notification to a browser. That said, this server  not recieve messages, only sends them.

It works fine with chromium.

##Included files

* `index.html` - this is a sample web page that sets up a websocket connection and does stuff when it recieves a message.
* `pipe_to_websocket.sh` - this is the server that accepts a named pipe as its single argument. When a client connects to it, it does the websocket handshake then sends whatever data comes through the named pipe to the client.
* `run` - the script that runs the server. It sets up a named pipe and forwards any input from stdin to it.

##TODO

* Clean up the bash (it has some korn shell syntax in there)
* Maybe include functionality to receive messages?

##Credits

I found a lot of the code online and managed to hack it together so that it works for me. Here are the sites I used:

* [ssklogs](http://ssklogs.blogspot.com/2012/10/websockets-handshake-using-netcatbash.html) - the websocket handshake code
* [suxue's server](https://gist.github.com/suxue/9582117) - websocket frame encoding
