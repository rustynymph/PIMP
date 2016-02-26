# PIMP
Participating in Musical Performances (PIMP)

## What is the purpose of PIMP?
PIMP allows people to participate in musicial performances / jam sessions in ways other than playing an instrument. The user can remotely control vivid visualizations simply by using their fingers. 

## How does PIMP work?
Project PIMP relies on the following technologies
*  Processing
*  OSC Protocol
*  TouchOSC iOS Application
*  Bluetooth

The visualizations were built using Processing, and the program utilizes the oscP5 and netP5 libraries. The user must connect their iOS device and their computer to the same wifi, then the user can connect their iOS device to the host computer via bluetooth. Performing both of these steps ensures that both devices are assigned unique IP addresses by the router's DHCP service, and that the two devices can speak to each other over a TCP socket. The Processing sketch is configured to receive messages from TouchOSC's its "Simple" layout, and can receive values from faders 1-5, and toggle buttons 1-4.

## How do I use PIMP?
* Connect your iOS device and computer to the same wifi network
* Pair the two devices via bluetooth
* Open up the TouchOSC app on your iOS device
* Open up TouchOSC's settings page and click on the OSC menu under the "Connections" section
* Make sure "Enabled" is set to on
* Change "Host" to the IP address of your host computer (on Linux this address can be found using the "ifconfig" command)
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
