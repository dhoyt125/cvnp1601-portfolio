What went wrong: Setuid was correctly configured, but the kernel ignores it on interpreted scripts, so the script ran as the invoking user.

What I tried: Verified ownership and permissions, ruling out configuration errors.

Fix: Added a scoped sudoers rule allowing the developers group to run only backup.sh as root.

Verification: Confirmed sudo -l -U alice lists the rule and running the script prints Running as: root.

Security impact: Limits root access to the specific backup script instead of granting broader privileges through sudo group membership.
