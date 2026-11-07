# blue-team-tools
A collection of miscellaneous tools that will hopefully help my team and I perform well in Blue vs Red team engagements.

**check_services**
- Audits active systemd service files against a whitelist
- Accepts user-provided whitelists
- Hostname-based whitelist capabilities

**check_users**
- Audits system users against a whitelist
- Accepts user-provided whitelists
- Hostname-based whitelist capabilities
- Provides user info (uid, homedir, shell)

**ssh_harden**
- Flushes all authorized public keys in `/home` and `/root`
- Enforces strong security rules for `sshd_config`
- Automatically restarts the ssh service to apply changes

**rotate_passwords**
- Pulls random words from a dictionary file to create cryptographically strong passwords

## Usage
### check_services
```
$ chmod +x check_services.sh
$ ./check_services.sh
All services whitelisted for hostname.

$ ./check_services.sh --hostname hostname
Found 1 non-whitelisted services:

  sshd

$ echo "sshd" > services.allow
$ ./check_services.sh --hostname hostname services.allow
All services whitelisted for hostname.

$ ./check_services.sh --help
Usage: ./check_services.sh [--hostname HOSTNAME] [WHITELIST_FILE]
```

### check_users
```
$ chmod +x check_users.sh
$ ./check_users.sh
All system users whitelisted for hostname.

$ ./check_users.sh --hostname hostname
Found 1 non-whitelisted users:

  test (UID: 1000, HOME: /home/test, SHELL: /bin/bash)

$ echo "test" > users.allow
$ ./check_users.sh --hostname hostname users.allow
All system users whitelisted for hostname.

$ ./check_users.sh --help
Usage: ./check_users.sh [--hostname HOSTNAME] [WHITELIST_FILE]
```

### ssh_harden
```
$ chmod +x ssh_harden.sh
$ ./ssh_harden.sh
"Please run as root"
$ sudo ./ssh_harden.sh
FLUSHED: /home/user1/.ssh/authorized_keys
FLUSHED: /home/user2/.ssh/authorized_keys
FLUSHED: /home/user3/.ssh/authorized_keys
FLUSHED: /root/.ssh/authorized_keys
```

### rotate_passwords
```
$ python3 rotate_passwords.py
Can't find the dictionary. Change into the directory with the 'data' directory.

$ cd rotate_passwords/
$ python3 rotate_passwords.py
ainsell-variancy-sabbathaic-unfoliaged

$ python3 rotate_passwords.py
chortle-tatterdemalion-fiords-pisanello

$ python3 rotate_passwords.py
iodoform-neoplasms-worsement-ingurgitating
```
---
### Used In
- IRSeC 2026