# simple-upnpd

UPnP daemon which only announces the presence of the device

Well the title says it all. The only thing this program can do is announce its
presence on the network by UPnP. It will appear e.g. in the "Network Connections"
in Windows and redirected to a customizable url. That should be it, if it can do
more it is likely a BUG..

It is made to run on a linux machine, but likely runs anywhere where glib, gobject,
gupnp function properly..

This fork adds the ability to specify the port it will be listening on and to also use IPv6 (requires `gupnp-1.2-dev` to build).

## Requirements

- systemd

## Installation

**This program installs into `/usr/local/bin`.**

- Copy this whole directory and transfer it to the device
- Install `build-essential`, `make`, and `gupnp-1.2-dev` or `gupnp-1.0-dev` packages
- Run `install.sh` as root

If your custom `simple-upnpd.xml` is present during execution of `install.sh` then it will be copied to `/etc/simple-upnpd.xml` instead of `description.xml`.
If the configuration file does not contain UUID in `UDN` field then it will be generated automatically.

Set custom port and enable IPv6 in `/etc/default/simple-upnpd`
```
ARGUMENTS="--port 1337 --ipv6"
```
