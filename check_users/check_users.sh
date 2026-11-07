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

# list of whitelisted users
case "$HOSTNAME" in 

    pitlane)
        WHITELIST=(
            root daemon bin sys sync games man lp
            mail news uucp proxy www-data backup
            list irc _apt nobody systemd-network
            systemd-resolve systemd-timesync systemd-oom
            sshd polkitd avahi dnsmasq usbmux chrony
            nm-openvpn rtkit pipewire geoclue scrutineer
            techdirector crewchief firecrew jackcrew
            garagecrew celebrity pitlaner reserve gunners
            whiteteam dd-agent ddagentuser tss messagebus
            speech-dispatcher fwupd-refresh saned colord
            gnome-initial-setup Debian-gdm blackteam
        )
        ;;

    garage)
        WHITELIST=(
            root daemon bin sys sync games man lp mail
            news uucp proxy www-data backup list irc
            _apt nobody systemd-network systemd-resolve
            systemd-timesync systemd-oom syslog uuidd
            tcpdump polkitd ftp avahi scrutineer
            techdirector crewchief firecrew jackcrew 
            garagecrew celebrity pitlaner reserve gunners
            whiteteam dd-agent ddagentuser blackteam
            gnats messagebus tss avahi-autoipd usbmux
            dnsmasq kernoops cups-pk-helper rtkit whoopsie
            sssd speech-dispatcher fwupd-refresh nm-openvpn
            saned colord geoclue pulse gnome-initial-setup
            hplip gdm
        )
        ;;
    
    grandstand)
        WHITELIST=(

            root daemon bin sys sync games man lp mail
            news uucp proxy www-data backup list irc _apt
            nobody systemd-network systemd-resolve
            dhcpcd messagebus usbmux tss kernoops whoopsie
            dnsmasq sssd speech-dispatcher cups-pk-helper
            fwupd-refresh saned geoclue cups-browsed hplip
            gnome-remote-desktop polkitd rtkit colord
            gnome-initial-setup gdm nm-openvpn sshd
            systemd-timesync systemd-oom syslog uuidd
            tcpdump avahi scrutineer techdirector 
            crewchief firecrew jackcrew garagecrew
            celebrity pitlaner reserve gunners
            whiteteam dd-agent ddagentuser
        )
        ;;

    scrutineering)
        WHITELIST=(
            ftp rtkit sssd geoclue tss colord clevis
            flatpak libstoragemgmt pipewire setroubleshoot
            gdm gnome-initial-setup sshd dnsmasq tcpdump
            root bin daemon adm lp sync shutdown halt
            mail operator games nobody systemd-network
            systemd-resolve systemd-timesync systemd-oom
            dbus polkitd chrony avahi scrutineer
            techdirector crewchief firecrew jackcrew
            garagecrew celebrity pitlaner reserve gunners
            whiteteam dd-agent ddagentuser systemd-coredump
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

    while IFS= read -r username || [[ -n "$username" ]]; do
        [[ -z "$username" || "$username" =~ ^[[:space:]]*# ]] && continue

        username="${username#"${username%%[![:space:]]*}"}"
        username="${username%"${username##*[![:space:]]}"}"

        if [[ ! "$username" =~ ^[a-zA-Z0-9_.-]+$ ]]; then
            echo "ERROR: Invalid username in whitelist: $username"
            exit 2
        fi

        WHITELIST+=("$username")
    
    done < "$CUSTOM_WHITELIST"
fi

# whitelist lookup
declare -A ALLOWED_USERS

for user in "${WHITELIST[@]}"; do
    ALLOWED_USERS["$user"]=1
done

# fetch all system users from /etc/passwd
UNKNOWN_USERS=()

while IFS=: read -r username password uid gid gecos home shell; do
    if [[ -z "${ALLOWED_USERS[$username]+x}" ]]; then
        UNKNOWN_USERS+=("$username (UID: $uid, HOME: $home, SHELL: $shell)")
    fi

done < /etc/passwd

# report findings
if [[ ${#UNKNOWN_USERS[@]} -eq 0 ]]; then
    echo "All system users whitelisted for $HOSTNAME."
    echo ""
    exit 0
else
    echo "Found ${#UNKNOWN_USERS[@]} non-whitelisted user(s):"
    echo

    for user in "${UNKNOWN_USERS[@]}"; do
        echo "  $user"
        done

    echo ""
    exit 1
fi