## garage (FTP) | Ubuntu 22.04
### IP: 10.15.1.5

## FTP
### Commands


### Configuration Files


# Ubuntu 22.04 Baseline
## Accounts
|      |        |                |              |                 |
|------|--------|----------------|--------------|-----------------|
|root  |news    |systemd-network |tcpdump       |sssd             |
|daemon|uucp    |systemd-resovle |avahi-autoipd |speech-dispatcher|
|bin   |proxy   |messagebus      |usbmux        |fwupd-refresh    |
|sys   |www-data|systemd-timesync|dnsmasq       |nm-openvpn       |
|sync  |backup  |syslog          |kernoops      |saned            |
|games |list    |_apt            |avahi         |colord           |
|man   |irc     |tss             |cups-pk-helper|geoclue          |
|lp    |gnats   |uuidd           |rtkit         |pulse            |
|mail  |nobody  |systemd-oom     |whoopsie      |hplip            |

## Services
|               |                |              |                              |                   |
|---------------|----------------|--------------|------------------------------|-------------------|
|accounts-daemon|e2scrub_reap    |snapd         |snapd.autoimport              |systemd-timesyncd  |
|anacron        |getty@          |snapd.seeded  |snapd.core-fixup              |thermald           |
|apparmor       |gpu-manager     |NetworkManager|snapd.recovery-chooser-trigger|ua-reboot-cmds     |
|avahi-daemon   |grub-common     |open-vm-tools |NetworkManager-wait-online    |ubuntu-advantage   |
|bluetooth      |systemd-pstore  |openvpn       |NetworkManager-dispatcher     |udisks2            |
|console-setup  |irqbalance      |systemd-oom   |snapd.system-shutdown         |ufw                |
|cron           |kerneloops      |rsyslog       |switcheroo-control            |unattended-upgrades|
|cups-browsed   |keyboard-setup  |secureboot-db |power-profiles-daemon         |vgauth             |
|cups           |ModemManager    |setvtrgb      |grub-initrd-fallback          |wpa_supplicant     |
|dmesg          |systemd-resolved|snapd.apparmor|networkd-dispatcher           |                   |

## Timers
|                 |             |                        |
|-----------------|-------------|------------------------|
|anacron          |e2scrub_all  |motd-news               |
|apport-autoreport|fstrim       |snapd.snap-repair       |
|apt-daily-upgrade|fwupd_refresh|ua-timer                |
|apt-daily        |logrotate    |update-notifier-download|
|dpkg-db-backup   |man-db       |update-notifier-motd    |
     
## Listening Ports
![](/images/garage/default-listening-ports.png)

> *Don't place blanket deny rules until a legitimate baseline for traffic is established.*

### Ingress
- `sudo iptables -A INPUT -p <protocol> --dport <port> -j ACCEPT`
- `sudo iptables -A INPUT -j LOG --log-prefix "dropped: "`
- `sudo iptables -A INPUT -j DENY`

### Egress
- `sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT`
- `sudo iptables -A OUTPUT -j LOG --log-prefix "dropped: "`
- `sudo iptables -A OUTPUT -j DENY`

## Directories
### `/tmp`
![](/images/garage/tmp-directory.png)