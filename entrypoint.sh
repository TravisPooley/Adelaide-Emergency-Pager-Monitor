#!/bin/sh

# Initialize RTL-SDR receiver and decode FLEX pager messages
# Parameters for rtl_fm:
#   -f 148.8125M    = Tune to 148.8125 MHz frequency (common pager frequency)
#   -M fm           = Use FM demodulation mode
#   -s 22050        = Set sample rate to 22050 Hz
#   -r 22050        = Set resample rate to 22050 Hz (matching sample rate, it should by default but just making sure)
# 
# multimon-ng parameters:
#   -a FLEX         = Demodulator settigs to decode FLEX pager protocol
#   -t raw          = Input file tpye to expect raw input format
#   /dev/stdin      = Read input from standard input (piped from rtl_fm)
rtl_fm -f 148.8125M -M fm -s 22050 -r 22050 | multimon-ng -a FLEX -t raw /dev/stdin | while read -r line
do
    # Log each decoded message to console for debugging
    echo "Raw message: $line"
    
    # Forward each message to MQTT broker for integration with other systems
    # Parameters:
    #   -h 192.168.1.100    = MQTT broker hostname/IP
    #   -t pager/messages   = MQTT topic for pager messages
    #   -m "$line"          = Message payload (the decoded pager message)
    mosquitto_pub -h 192.168.1.100 -t pager/messages -m "$line"
done
