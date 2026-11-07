#!/bin/bash

set -o nounset

HOSTNAME=$(hostname -s)
CUSTOM_WHITELIST=""

# parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --hostname)
            [[ $# -ge 2 ]] || {
                echo "ERROR: Missing hostname argument"
                exit 2
            }
            HOSTNAME="$2"
            shift 2
            ;;

        --help|-h)
            echo "Usage: $0 [--hostname HOSTNAME] [WHITELIST_FILE]"
            exit 0
            ;;
        -*)
            echo "ERROR: Unknown option: $1"
            exit 2
            ;;
        
        *)
            if [[ -n "$CUSTOM_WHITELIST" ]]; then
                echo "ERROR: Multiple whitelist files are not supported."
                exit 2
            fi

            CUSTOM_WHITELIST="$1"
            shift
            ;;
    esac
done

# list of whitelisted services
case "$HOSTNAME" in 

    pitlane)
        WHITELIST=(
            accounts-daemon anacron apparmor avahi-daemon bluetooth
            console-setup cron cups-browsed cups e2scrub_reap getty@
            keyboard-setup low-memory-monitor ModemManager networking
            NetworkManager-dispatcher NetworkManager-wait-online
            NetworkManager open-vm-tools power-profiles-daemon ssh
            switcheroo-control systemd-pstore systemd-timesyncd 
            udisks2 vgauth wpa_supplicant datadog-agent
        )
        ;;

    garage)
        WHITELIST=(
            accounts-daemon anacron apparmor avahi-daemon bluetooth
            console-setup cron cups-browsed cups dmesg e2scrub_reap
            getty@ gpu-manager grub-common grub-initrd-fallback
            irqbalance kerneloops keyboard-setup ModemManager 
            networkd-dispatcher NetworkManager-dispatcher 
            NetworkManager-wait-online NetworkManager open-vm-tools
            openvpn power-profiles-daemon rsyslog secureboot-db 
            setvtrgb snapd.apparmor snapd.autoimport snapd.core-fixup
            snapd.recovery-chooser-trigger snapd.seeded snapd
            snapd.system-shutdown switcheroo-control systemd-oomd 
            systemd-pstore systemd-resolved systemd-timesyncd 
            thermald ua-reboot-cmds ubuntu-advantage udisks2 ufw
            unattended-upgrades vgauth wpa_supplicant vsftpd
            datadog-agent
        )
        ;;
    
    grandstand)
        WHITELIST=(
            accounts-daemon anacron apparmor apport avahi-daemon
            bluetooth cloud-final cloud-init-local cloud-init
            console-setup cron cups-browsed cups dmesg e2scrub_reap
            getty@ gnome-remote-desktop gpu-manager grub-common
            grub-initrd-fallback kerneloops keyboard-setup ModemManager
            netfilter-persistent networkd-dispatcher
            NetworkManager-dispatcher NetworkManager-wait-online
            NetworkManager openvpn power-profiles-daemon rsyslog
            secureboot-db setvtrgb snapd.apparmor snapd.autoimport
            snapd.core-fixup snapd.recovery-chooser-trigger
            snapd.seeded snapd snapd.system-shutdown ssh ssl-cert
            sssd switcheroo-control sysstat systemd-oom
            systemd-pstore systemd-resolved systemd-timesyncd
            thermald ua-reboot-cmds ubuntu-advantage udisks2
            unattended-upgrades wpa_supplicant datadog-agent
            docker
        )
        ;;

    scrutineering)
        WHITELIST=(
            accounts-daemon atd auditd avahi-daemon bluetooth
            chronyd crond cups dbus-broker firewalld gdm
            getty@ irqbalance iscsi-onboot iscsi-starter kdump
            libstoragemgmt low-memory-monitor lvm2-monitor mcelog
            mdmonitor microcode ModemManager multipathd 
            NetworkManager-dispatcher NetworkManager-wait-online
            NetworkManager nis-domainname nvmefc-boot-connections
            ostree-remount qemu-guest-agent rsyslog rtkit-daemon
            selinux-autorelabel-mark smartd sshd sssd 
            switcheroo-control systemd-boot-update 
            systemd-network-generator systemd-pstore tuned 
            udisks2 upower vgauthd vmtoolsd datadog-agent 
        )
        ;;

    *)
        echo "ERROR: No whitelist defined for hostname: $HOSTNAME"
        exit 2
        ;;

esac

# load whitelist file if provided
if [[ -n "$CUSTOM_WHITELIST" ]]; then
    if [[ ! -f "$CUSTOM_WHITELIST" || ! -r "$CUSTOM_WHITELIST" ]]; then
        echo "ERROR: Cannot read whitelist file: $CUSTOM_WHITELIST"
        exit 2
    fi

    while IFS= read -r service || [[ -n "$service" ]]; do
        [[ -z "$service" || "$service" =~ ^[[:space:]]*# ]] && continue

        service="${service#"${service%%[![:space:]]*}"}"
        service="${service%"${service##*[![:space:]]}"}"

        service="${service% }"

        if [[ ! "$service" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
            echo "ERROR: Invalid service in whitelist: $service"
            exit 2
        fi

        WHITELIST+=("$service")
    
    done < "$CUSTOM_WHITELIST"
fi

# whitelist lookup
declare -A ALLOWED_SERVICES

for service in "${WHITELIST[@]}"; do
    service="${service% }"
    ALLOWED_SERVICES["$service"]=1
done

# fetch all enabled system services from systemctl
UNKNOWN_SERVICES=()

while IFS= read -r service; do
    service="${service% }"

    [[ -z "$service" ]] && continue

    if [[ -z "${ALLOWED_SERVICES[$service]+x}" ]]; then
        UNKNOWN_SERVICES+=("$service")
    fi

done < <(
    systemctl list-unit-files \
        --type=service \
        --state=enabled \
        --no-legend \
        --no-pager |
    awk -F '.service' '{print $1}'
)

# report findings
if [[ ${#UNKNOWN_SERVICES[@]} -eq 0 ]]; then
    echo "All services whitelisted for $HOSTNAME."
    echo ""
    exit 0
else
    echo "Found ${#UNKNOWN_SERVICES[@]} non-whitelisted service(s):"
    echo

    for service in "${UNKNOWN_SERVICES[@]}"; do
        echo "  $service"
        done

    echo ""
    exit 1
fi