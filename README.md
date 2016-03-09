# PIMP
Participating in Musical Performances (PIMP)

## What is the purpose of PIMP?
PIMP allows people to participate in musicial performances / jam sessions in ways other than playing an instrument. The user can remotely control vivid visualizations simply by using their fingers. 

## How does PIMP work?
Project PIMP relies on the following technologies
*  Processing https://processing.org/
*  OSC Protocol http://opensoundcontrol.org/introduction-osc
*  TouchOSC iOS Application http://hexler.net/software/touchosc
*  Bluetooth

The visualizations were built using Processing, and the program utilizes the oscP5 and netP5 libraries. The user must connect their iOS device and their computer to the same wifi, then the user can connect their iOS device to the host computer via bluetooth. Performing both of these steps ensures that both devices are assigned unique IP addresses by the router's DHCP service, and that the two devices can speak to each other over a TCP socket. The Processing sketch is configured to receive messages from TouchOSC's its "Simple" layout, and can receive values from faders 1-5, and toggle buttons 1-4.

## How do I use PIMP?
### Software Setup
* Clone this repository
* Connect your iOS device and computer to the same wifi network
* Pair the two devices via bluetooth
* Open up the TouchOSC app on your iOS device
* Open up TouchOSC's settings page and click on the OSC menu under the "Connections" section
* Make sure "Enabled" is set to on
* Change "Host" to the IP address of your host computer (on Linux this address can be found using the `ifconfig` command)
* Change "Port (outgoing)" to the port your host computer will be listening for messages on
* Change "Port (incomnig) to the port you want you iOS device to listen for messages on
* If the bluetooth pairing and wifi connections are working, the "Local IP address" will be on the same subnet as your "Host" IP address
* Go back to TouchOSC's main settings page
* Change "Layout" to Simple
* Press "Done", you should see a screen with 4 vertical faders (these are the sliders), 1 horizontal fader, and 4 toggle buttons
* Open up the pimp.pde sketch in the Processing IDE, or if you install a plugin you can build/edit Processing sketches from Sublime Text
* In `void setup()` you will see `oscP5 = new OscP5(this, <PORT_NO>);`. Change PORT_NO to the "Port (outgoing)" port you configured in TouchOSC earlier
* On the next line you will see `dest = new NetAddress("IP_ADDRESS", <PORT_NO>);` and you should change IP_ADDRESS to the "Local IP address" in the TouchOSC app, and PORT_NO to the same port you configured as "Port (incoming)"
* Run the processing sketch and if all is configured properly you should see the visualizations dynamically change as you mess around with the TouchOSC interface!

### Controls
####Visualization 1
Fader 1 : colors of main circle grid
Fader 2 : amount of circle beams shooting from border of circle grid
Fader 3 : transparency of small floating dots
Fader 4 : speed of small floating dots
Fader 5 : frequency of background flashing mode
Toggle 1 : enable/disable background flashing mode
Toggle 2 : switch to visualization 2
Toggle 3 : enable/disable sketch rotating
Toggle 4 : not implemented
Accelerometer : control tilt of sketch using x vector

####Visualization 2
Fader 1 : lightning strike frequency
Fader 2 : background red value
Fader 3 : background green value
Fader 4 : background blue value
Fader 5 : not implemented
Toggle 1 : not implemented
Toggle 2 : switch to visualization 1
Toggle 3 : not implemented
Toggle 4 : not implemented
Accelerometer : not implemented

## Future Work
#### Visualization Options
So far there are two visualization options, one is a colorful geometric visualizer that pairs well with electronic music, pop, and even fast-paced alternative rock. The second is a lightning storm that looks awesome behind some heavy metal jams. I am hoping to expand eventually to add many more options to accomadate several different styles of music.
#### Web Application
Ideally I would also like to port my Processing sketch over to P5.js so I could host this on my website and have people be able to connect that way.
#### Flexibility for changing Hardware Input
Right now the Processing sketch could theoretically take input from anything -- accelerometers, microphones, etc. However there needs to be a way to wrap that data in OSC messages. I would like to make an intermediate OSC forwarder that could take input from a variety of different tool and then forward it to the program in OSC messages that it can interpret and understand.
