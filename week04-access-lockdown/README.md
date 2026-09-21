CVNP1601-W4-004 — Shared Directory Lockdown (/project)
	
Affected system	Shared Linux directory /project
Business impact	High
Security consideration	Overly broad permissions can expose or destroy team files. Contractor access must be specific and removable.
Required outcome	Sticky bit, SGID, and ACL controls configured and verified with before/after evidence.
Table of Contents
Before State
Controls Applied
1. SGID
2. Sticky Bit
3. ACL for Contractor Access
After State / Verification
Remaining Risk / Cleanup
Related: Task 6 Break/Fix Diagnostic
Before State
bash
/project:
drwxr-xr-x  2 root developers 4096 Sep 21 01:33 .
Gap	Consequence
No SGID	New files inherit the creator's personal group, not developers
No sticky bit	Any group member with write access could delete or rename anyone else's files
other: r-x	Any local user can browse the directory, not just the team
Group has no write	Team can't actually create files yet
Controls Applied
1. SGID
bash
sudo chmod g+s /project
ls -ld /project

Makes every new file or subdirectory inherit the developers group automatically, instead of the creator's own primary group. Without this, teammates end up locked out of files their own colleagues create, because by default a new file takes the creator's personal group.

2. Sticky Bit
bash
sudo chmod +t /project
ls -ld /project

Restricts delete/rename of a file to its owner (or root), even though the whole group can write to the directory. Without this, anyone with write access to /project could delete or overwrite anyone else's files.

3. ACL for Contractor Access
bash
sudo apt-get install acl
getfacl /project > acl-audit.txt
sudo setfacl -m u:carlos:rx /project
getfacl /project >> acl-audit.txt
sudo setfacl -m g:developers:rw /project
getfacl /project >> acl-audit.txt
touch /project/acl-test.txt
getfacl /project/acl-test.txt >> acl-audit.txt
sudo setfacl -x u:carlos /project
getfacl /project >> acl-audit.txt

Contractor carlos was granted read+execute only via ACL — not write, and not added to the developers group. The developers group itself got read/write via ACL. A test file (acl-test.txt) was created to confirm inheritance behaved correctly. carlos's ACL entry was then removed entirely, with getfacl output logged before and after to prove the access was both scoped and fully revocable.

Standard group permissions only give one group slot per directory — everyone in that group gets identical access. ACLs let one user get a different permission level layered on top of the existing group setup, without changing anything for the rest of the team.

After State / Verification

All states below are logged in acl-audit.txt, captured with getfacl before granting access, after granting carlos read+execute, after granting developers read/write, and after revoking carlos.

bash
ls -ld /project
getfacl /project
 ls -ld shows s in the group execute position (SGID) and t in the other execute position (sticky bit)
 getfacl shows carlos granted r-x, then removed entirely in the final log entry — proving the access was specific and could be pulled cleanly
 acl-test.txt, created inside /project after SGID was set, came out owned by group developers rather than the creating user's personal group
 A non-owner attempting to delete another user's file inside /project gets denied, confirming the sticky bit
Remaining Risk / Cleanup

ACL entries don't expire on their own. The contractor's ACL entry needs to be pulled manually once their work is done, or it sits there indefinitely as leftover access.

Related: Task 6 Break/Fix Diagnostic

See week4-diagnosis.md. Covers a separate issue where setuid was set on a shell script expecting root privileges — the kernel ignores setuid on interpreted scripts, so the fix was a scoped sudoers rule instead, not a chmod problem.
