## pitlane (SSH) | Debian 12
### IP: 10.15.1.4

## SSH
### Commands
- Connect to `user` at `destination` with `ssh user@destination` 
- To show verbose logs use `ssh -v user@destination`, useful for troubleshooting connection errors

### Configuration Files
- `/etc/ssh/ssh_config`
- `/etc/ssh/ssh_config.d/*`

SSH can really be targeted in two ways: malicious keys and misconfigurations.
- SSH keys can be found in `~/.ssh/authorized_keys`
- SSH config files can be found in `/etc/ssh/ssh_config`, `/etc/ssh/sshd_config`, `/etc/ssh/ssh_config.d`
    - Pay attention to stuff like `PasswordAuthentication`, `PermitRootLogin`, and possibly `IdentityFile`

A really good way to secure this box is to disable all unnecessary services and use firewalls with explicit deny rules.
- `sudo ufw enable`
- `sudo ufw allow 22`
- `sudo systemctl disable <service>`

# Debian 12 Baseline

## Accounts
|      |        |                 |             |
|------|--------|-----------------|-------------|
|root  |news    |systemd-network  |fwupd-refresh|
|daemon|uucp    |tss              |saned        |
|bin   |proxy   |systemd-timesync |geoclue      |
|sys   |www-data|messagebus       |polkitd      |
|sync  |backup  |usbmux           |rtkit        |
|games |list    |dnsmasq          |colord       |
|man   |irc     |avahi            |Debian-dbm   |
|lp    |_apt    |speech-dispatcher|sshd         |
|mail  |nobody  |                 |             |

## Services
|               |                  |                          |
|---------------|------------------|--------------------------|
|accounts-daemon|e2scrub_reap      |open-vm-tools             |
|anacron        |getty@            |power-profiles-daemon     |
|apparmor       |keyboard-setup    |ssh                       |
|avahi-daemon   |low-memory-monitor|switcheroo                |
|bluetooth      |ModemManager      |systemd-pstore            |
|console-setup  |networking        |systemd-timesyncd         |
|cron           |udisks2           |NetworkManager-dispatcher |
|cups-browsed   |vgauth            |NetworkManager-wait-online|
|cups           |NetworkManager    |wpa_supplicant            |

## Timers
|                 |              |             |
|-----------------|--------------|-------------|
|anacron          |dpkg-db-backup|fwupd-refresh|
|apt-daily-upgrade|e2scrub_all   |logrotate    |
|apt-daily        |fstrim        |man-db       |

## Listening Ports
![](/images/pitlane/default-listening-ports.png)

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
![](/images/pitlane/tmp-directory.png)
