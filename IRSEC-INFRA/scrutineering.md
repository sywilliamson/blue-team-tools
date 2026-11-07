## scrutineering (MariaDB) | Rocky 9
### IP: 192.168.15.3

## MariaDB
### Commands

### Configuration Files

# Rocky 9 Baseline

> It looks like Rocky stores system services in `/usr/lib/systemd/systsem` instead of `/etc/systemd/system`

## Accounts
|        |                |       |              |
|--------|----------------|-------|--------------|
|root    |mail            |rtkit  |libstoragemgmt|
|bin     |operator        |dbus   |pipewire      |
|daemon  |games           |sssd   |setroubleshoot|
|adm     |ftp             |geoclue|gdm           |
|lp      |nobody          |tss    |gnome-initial |
|sync    |systemd-coredump|colord |sshd          |
|shutdown|polkitd         |clevis |chrony        |
|halt    |avahi           |flatpak|dnsmasq       |
|tcpdump |                |       |              |

## Services
|               |                  |                          |                         |
|---------------|------------------|--------------------------|-------------------------|
|accounts-daemon|irqbalance        |NetworkManager-dispatcher |switcheroo-control       |
|atd            |iscsi-onboot      |NetworkManager-wait-online|systemd-boot-update      |
|auditd         |iscsi-starter     |NetworkManager            |systemd-network-generator|
|avahi-daemon   |kdump             |nis-domainname            |systemd-pstore           |
|bluetooth      |libstoragemgmt    |qemu-guest-agent          |tuned                    |
|chronyd        |low-memory-monitor|rsyslog                   |udisks2                  |
|crond          |lvm2-monitor      |rtkit-daemon              |upower                   |
|cups           |mcelog            |selinux-autorelabel-mark  |vgauthd                  |
|dbus-broker    |mdmonitor         |smartd                    |vmtoolsd                 |
|firewalld      |microcode         |sshd                      |getty@                   |
|gdm            |ModemManager      |sssd                      |multipathd               |

## Timers
|                |
|----------------|
|dnf-makecache   |
|logrotate       |
|mlocate-updatedb|
|raid-check      |

## Listening Ports

![](/images/scrutineering/default-listening-ports.png)

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
![](/images/scrutineering/tmp-directory.png)