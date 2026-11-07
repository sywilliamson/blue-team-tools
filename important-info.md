## Users
### Authorized Users
| Domain Admins | Domain Users | Local Admins | Local Users | Competition Users |
|---------------|--------------|--------------|-------------|-------------------|
| principal     | pitcrew      | scrutineer   | jackcrew    | whiteteam         |
| sportingdir   | mechanic     | techdirector | garagecrew  | 
| chiefeng      | analyst      | crewchief    | celebrity   |
| strategist    | driver       | firecrew     | pitlaner    |
|               | tireman      |              | reserve     |
|               | fuelman      |              | gunners     |

### User Information
- Change a user's password with `sudo passwd <user>`
- Lock a user's account with `sudo passwd -l <user>`
- Unlock a user's account with `sudo passwd -u <user>`
- Delete a user's account with `sudo userdel <user>`
- List all users and UIDs with `cat /etc/passwd`
    - A UID of 0 is recognized as a root account
    - All service accounts should have their shell listed as `/usr/sbin/nologin` or `/bin/false`
- User password hashes are stored in `/etc/shadow`
    - Date since last password change (time since epoch)
    - Hashes beginning with `!` mean that the account is locked/unable to login
- List users, their tty, and login time with `w`
    - You can use `w -p` to get the PID of their session and kill it with `sudo kill <pid>` :D

## Groups
### Sudo Group
Allows users to perform administrative commands.
- Get group members with `getent group sudo` (or `getent group wheel` for Red Hat)
- Check `/etc/sudoers` and `/etc/sudoers.d/` for configurations which give users sudo perms
- Delete files or configurations which give accounts admin perms when they shouldn't have them

### Docker Group
Allows users to run `docker` or `docker-compose` files without admin permissions.
- Get group members with `getent group sudo`
- Might be smart to just delete this group 

### Group Information
- Check the groups a user is in with `groups <user>`
- View a list of all groups in `/etc/groups` or with `getent group`
- Remove a user from a group with `gpasswd -d <user> <group>`
- Delete a group with `groupdel <group>`

## Services
Services are common methods that the Red Team uses to maintain persistence. Look through the services and disable or delete any that don't look ordinary.

### Service Information
- View all enabled service files with `systemctl list-unit-files --state=enabled --type=service`
- View a specific service file with `systemctl cat <service>`
- Manage a specific service with `systemctl [status|restart|start|enable|disable] <service>`
- Service files can run as a user or as a system
    - System service files can be found in `/etc/systemd/system`, `/run/systemd/system`, or `/lib/systemd/system`
    - User service files can be found in `~/.config/systemd/user`, `/etc/systemd/user`, `/run/systemd/user`, or `/usr/lib/systemd/user`

## Cron Jobs
There's really no legitimate use for cron jobs in this environment. If you find one, it's more likely malicious or not.
- Cron jobs can be found in `/etc/crontab`, `/etc/cron.d`, and `/var/spool/cron/crontabs`
- Anacron is another scheduling tool that can be included, so it's smart to check that

## Processes
- Show a tree view of processes with `ps -auxf`
    - Red team might hide processes from this view
- `top` provides a live view of resources and processes
- You can use `ls -la /proc/<pid>/exe to find the actual binary behind a process
- Any process runned with `netcat`, `socat`, `bash -i`, or `python -c` is SUPER suspicious
- Anything running with a source from `/tmp` is likely malicious
- Use `kill -9 <pid>` to kill a service
- **Make sure you investigate the chain to hit the persistence at the root!**

## Network
- I was told that red team has the ability to bypass ufw firewalls
- We not allowed to block entire subnets, but we can block individual IPs
- Using `ss -tulnp` is useful to view which processes are listening on which ports
- `ufw` and `iptables` serve as the default firewall for Linux
- You can deny all traffic from an IP with `ufw deny from <ip-address>`
### iptables
- Install persistent iptables rules with `sudo apt install iptables-persistent`
- Enable `netfilter-persistent` on restart with `sudo systemctl enable netfilter-persistent`
- Append rules to a table with `sudo iptables -A <table> -j <action>`
- Chains take priority by the order they're in (an ACCEPT above a DROP will override traffic that applies to it)

## Important Directories
- Pretty much the entirety of `/etc`
- `/var/www` or `/srv` if a website is being hosted
- Red team likes to use `/tmp`, `/dev/shm`, and `/var/tmp` as drop spots for malware
- `~/.bashrc*` and `~/.profile` contain user startup files
- Make a directory/file immutable with `chattr +i <path>`
- Check directory/file attributes, like immutability, with `lsattr <path>`
- Pluggable authentication modules in `/etc/pam.d/`. Can be used to completely bypass authentication.
    - `pam_unix.so` handles standard password authentication

## Binaries
Sometimes red team likes to poison binaries for persistence or to hide their persistence methods. Check binaries and see if any of them have been changed recently.
- You can check your path with `echo $PATH` to see where you pull binaries from
- Any path to the left will override a binary in a path to the right, so always double check
- Some really common binaries that are used are `cd`, `ls`, `ss` (to hide network info), `grep`, `systemctl`, and similar
- You can just `cat <binary>` to see if a binary has been poisoned
- If in doubt, you can download the binary again using a package manager like `apt` or `dnf`
- Check all files changed within the last X days with `find . -type f -mtime -X`

## Threat Hunting
- **LOBOTOMIZE EVERYTHING**
- Checking recently modified files can really help (`find . -type f -mtime -<days>`)
- Take baselines early and then compare states later
- Always try to follow a chain of events to its root
- Document anomalies!
- 