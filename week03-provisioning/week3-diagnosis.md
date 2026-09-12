# Week 3 Diagnosis 


# 1. State:
The trainess was able to create another user,
but cannot run any sudo commands. 

# 2. Cause:
The file was created with a plain text editor, 
so it has normal file permissions 
(readable by everyone) instead of the strict 
permissions sudo requires for files in
 /etc/sudoers.d/. 
Because the file is more open than sudo 
allows, sudo ignores it entirely 
without saying why.

# 3. Remediation:
Using visudo instead to set permissions automatically

# 4. Verification:
Two checks confirm it's fixed: running sudo -l as contractor should now show the rule, and actually running the allowed restart command as contractor should succeed instead 
of being denied.


# 5. :
Sudo reads rules files fresh every time. 
Sudo is strict about file permissions, rebooting
wouldn't solve the problem at all and assuming it would hide the real problem. 
