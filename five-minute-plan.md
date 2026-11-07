- Take backups of service and system configs
    - `/etc/ssh/*` (pitlane)
    - `/etc/rc.initial` (pfSense)
    - `/srv/ftp` (garage)
    - `/var/lib/mysql` (scrutineering)
    - Exfiltration is not allowed, but screenshots of configs are!
    
- Record baseline activity
    - `sudo ss -tulnp`
    - `sudo ps auxf`
    - `sudo nethogs`

- Search common locations for malware/persistence.
    - `/tmp`
    - `/var/tmp`
    - `/etc/profile`
    - `/etc/profile.d/*`
    - `/etc/shells`
    - `/etc/hosts`
    - `/etc/hosts.allow`
    - `/etc/hosts.deny`
    - `/etc/sudoers`
    - `/etc/sudoers.d/*`
    - `/etc/sudo.conf`
    - `/etc/crontab`
    - `/etc/cron.d/*`
    - `for file in /home/*/.ssh/authorized_keys; do cat "$homedir"; done`
    - `lsmod` (`sudo modinfo <module>` to get more info)

- Rotate passwords

- Harden boxes
    - KILL PYTHON `which python3` / `which python` (check & kill processes still running under python later!)
    - `sudo chattr +i -r /etc/ssh/`
    - `sudo chattr +i /etc/profile`
    - `sudo chattr +i /etc/shells`
    - `sudo chattr +i /etc/hosts`
    - `sudo chattr +i /etc/hosts.allow`
    - `sudo chattr +i /etc/hosts.deny`
    - `sudo chattr +i /etc/sudoers`
    - `sudo chattr +i -r /etc/sudoers.d/`
    - `sudo chattr +i /etc/sudo.conf`
    - `sudo chattr +i -r /tmp`
    - `sudo chattr +i -r /bin`
    - `sudo chattr +i -r /usr/bin`
    - `sudo chattr +i -r /usr/local/bin`
    - `for file in /home/*/.ssh/authorized_keys; do sudo chattr +i "$file"; done`
    - Implement DenyUsers in `/etc/ssh/sshd_config`. *(This keyword can be followed by a list of user name patterns, separated by spaces.  Login is disallowed for user names that match one of the patterns)*
    