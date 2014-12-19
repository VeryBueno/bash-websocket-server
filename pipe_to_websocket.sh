#!/bin/bash
# A websocket server that sends stuff from a given pipe
# to a client. Usage: pipe_to_websocket.sh /path/to/pipe

# The pipe that is used to send stuff to the socket
IN_PIPE=$1;

function Dec2Hex {
   typeset num=`echo 'obase=16; ibase=10; '"$1" | bc`
   if ((${#num} == 1)); then
      num=0"$num"
   fi
   printf "0x%s" $num
}

function send_encoded_frame {
   typeset data="$1"
   # 1st nible: 0x8 -> the final frame
   # 2nd bible: 0x1 -> textual frame
   typeset first_byte="0x81"
   typeset payload_length=${#data}
   typeset second_byte=`Dec2Hex $payload_length` # no mask
   printf "%s%s" $first_byte $second_byte | xxd -r -p
   printf "%s" "$data"
}

function handshake {
   rm -rf t
   while true
   do
      read packet
      echo $packet >> t
      cnt=`echo $packet | wc -c`
      if [ $cnt == 2 ] #end of message
      then
         key=`cat t | grep "Sec-WebSocket-Key:" | cut -f2 -d " "`
         keylen=`echo -n $key | wc -c`
         keylen=`expr $keylen - 1`
         key2=`echo -n $key | cut -c -$keylen`
         magic="258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
         resp=`echo -n $key2$magic | openssl sha1 -binary | base64`
         echo   -ne "HTTP/1.1 101 Switching Protocols\r\n"
         echo   -ne "Connection: Upgrade\r\n"
         echo   -ne "Upgrade: websocket\r\n"
         echo   -ne "Sec-WebSocket-Accept: $resp\r\n\r\n"
         break
      fi
   done
   rm -rf t
}

# perform handshake
handshake;

# input loop
while true
do
   read input < $IN_PIPE;
   send_encoded_frame "$input";
done
