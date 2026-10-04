1. State

	chown and chmod u+s both succeeded, ls -l confirms rws is 
	genuinely set on backup.sh. But running the script as alice still printed Running as: alice, not root, so the privilege escalation itself did not happen.

2. Root Cause

	The file is a shell script, not a compiled binary.

3. Remediation

	Don't chase setuid on the script itself, instead grant a narrowly scoped sudoers rule 
	(via visudo/sudoers.d) that lets the developers group run only that one script as root, ideally with NOPASSWD if needed for automation, rather than full sudo access.

4. Verification

	First, sudo -l -U alice should show the specific backup.
	sh rule and nothing broader; second, running sudo /opt/scripts/backup.sh as alice should now print Running as: root, confirming the fix from both the policy side and the runtime side.


Reaching for the narrowest privilege-escalation mechanism matters more than "getting it to work," because a scoped sudoers rule limits root access to exactly one script
