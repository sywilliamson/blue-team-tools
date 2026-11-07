# grandstand (Docker Compose / IRC) | Ubuntu 24.04
### IP: 10.15.1.6

## Docker-Compose
### Commands
- Build and start all services in detatched mode with `docker-compose up -d`
- Stops and removes resources in use with `docker-compose down`
- List all containers in the current application with `docker-compose ps`
- Display logs from a service with `docker-compose logs <service>`
- Run a command inside of a service with `docker-compose exec <service> <command>`
- Start existing stopped containers with `docker-compose start`
- Stop running containers while preserving resources with `docker-compose stop`
- Validate and display the configuration with `docker-compose config`

### Configuration Files


## IRC

# Ubuntu 24.04 Baseline

## Accounts
|             |                    |                 |                    |
|-------------|--------------------|-----------------|--------------------|
|root         |daemon              |bin              |sys                 |
|sync         |games               |man              |lp                  |
|mail         |news                |uucp             |fwupd-refresh       |
|www-data     |backup              |list             |systemd-network     |
|_apt         |nobody              |irc              |systemd-timesync    |
|dhcpcd       |messagebus          |syslog           |systemd-resolve     |
|uuidd        |usbmux              |tss              |systemd-oom         |
|kernoops     |whoopsie            |dnsmasq          |speech-dispatcher   |
|tcpdump      |sssd                |avahi            |cups-pk-helper      |
|proxy        |saned               |geoclue          |cups-browsed        |
|hplip        |rtkit               |polkitd          |gnome-remote-desktop|
|colord       |nm-openvpn          |gdm              |gnome-initial-setup |
|sshd

## Services
|       |           |              |                |                              |
|-------|-----------|--------------|----------------|------------------------------|
|ssh    |anacron    |cloud-final   |snapd.apparmor  |systemd-timesyncd             |
|ufw    |rsyslog    |cloud-config  |NetworkManager  |switcheroo-control            |
|cron   |thermald   |avahi-daemon  |ua-reboot-cmds  |networkd-dispatcher           |
|cups   |apparmor   |e2scrub_reap  |wpa_supplicant  |unattended-upgrades           |
|sssd   |ssl-cert   |ModemManager  |systemd-pstore  |gnome-remote-desktop          |
|snapd  |setvtrgb   |snapd.seeded  |accounts-daemon |grub-initrd-fallback          |
|dmesg  |bluetooth  |systemd-oomd  |cloud-init-local|power-profiles-daemon         |
|apport |cloud-init |cups-browsed  |snapd.autoimport|snapd.system-shutdown         |
|getty@ |kerneloops |console-setup |snapd.core-fixup|NetworkManager-dispatcher     |
|udisks2|gpu-manager|secureboot-db |ubuntu-advantage|NetworkManager-wait-online    |
|sysstat|grub-common|keyboard-setup|systemd-resolved|snapd.recovery-chooser-trigger|
|openvpn|           |              |                |                              |

## Timers
|         |             |                 |                        |
|---------|-------------|-----------------|------------------------|
|fstrim   |logrotate    |sysstat-collect  |snapd.snap-repair       |
|man-db   |apt-daily    |sysstat-summary  |update-notifier-motd    |
|anacron  |e2scrub_all  |apport-autoreport|update-notifier-download|
|ua-timer |fwupd-refresh|apt-daily-upgrade|motd-news               |

## Listening Ports
![](/images/grandstand/default-listening-ports.png)
I didn't find a set port that IRC communicates, but it can range from 6665 to 6669.
We can probably check what port Docker is using for IRC by checking the Dockerfile or compose.yaml

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