# PIMP
Participate in Musical Performances (PIMP)

## What is the purpose of PIMP?
PIMP allows people to participate in musicial performances / jam sessions in ways different than playing an instrument. The user can remotely control vivid visualizations simply by using their fingers. 

## How does PIMP work?
Project PIMP relies on the following technologies
*  Processing
*  OSC Protocol
*  TouchOSC iOS Application
*  Bluetooth

The visualizations were built using Processing, and the program utilizes the oscP5 and netP5 libraries. The user must connect their iOS device and their computer to the same wifi, then the user can connect their iOS device to the host computer via bluetooth. Performing both of these steps ensures that both devices are assigned unique IP addresses by the router's DHCP service, and that the two devices can speak to each other over a TCP socket. The Processing sketch is configured to receive messages from TouchOSC's its "Simple" layout, and can receive values from faders 1-5, and toggle buttons 1-4.
