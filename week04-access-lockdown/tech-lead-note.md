
Controls applied to /project: Configured SGID, sticky bit, and ACLs for the contractor.

SGID: New files inherit the developers group, preventing access issues. Verified with ls -ld and test files.

Sticky bit: Prevents users from deleting or renaming others’ files. Verified with ls -ld and a denied deletion attempt.

ACLs: Grant the contractor access without developers group membership. Verified with getfacl; removable using setfacl -x.

Leftover risk: Contractor ACLs don’t expire automatically and must be manually removed when the contract ends.
