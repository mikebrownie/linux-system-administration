# Networking in the UNIX Operating System

## TCP/IP Fundamentals


### Internet Protocol Suite

Communication is nested. E.g. layer 2 is inside of layer 1.

Layer 1 link: Physical Connectivity
Layer 2 Internet: Global address and routing
Layer 3 Transport: Process comunication
Layer 4 Application: Application specific data

There also the ISO 70 model, more fine grained

## Layer 1

Communicating over LAN

### Ethernet frame

- Composed of macsource, mac destination, and a payload (42 byts to 9000 bytes)

#### MAC address

- 48 bits to uniquely identify each device on LAN

## Layer 2 IP

Used for communicating over the wider internet

### IP Packet  

- Contains source and destination
- Variable length data

## Layer 3 

Used for communications between processes

### UDP Packet
User data protocol
- Pretty simple, composed of: source port, dest port, length, checksup, data
- No way of knowing that it makes it

### TCP Packet

Transmission control protocol

- More fields than UDP
- There is acknowledgment and sequence information *More reliable*

## Layer 4

Application specific data

