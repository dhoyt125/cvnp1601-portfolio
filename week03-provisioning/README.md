# CVNP1601-W3-003 — devuser Provisioning

## Ticket Details

| Field | Value |
|---|---|
| Ticket ID | CVNP1601-W3-003 |
| Submitted by | Engineering manager |
| Affected system | Linux user account, developers group, sudoers policy |
| Reported request | Provision `devuser` with group membership and targeted service restart access |
| Business impact | Medium |
| Security consideration | Full sudo would over-grant access. The sudo rule must allow one exact service action and deny unrelated privileged actions |
| Required outcome | Account, group, sudo rule, allowed command, denied command, and `sudo -l` verification documented |

## 1. Create the Group

```bash
sudo groupadd developers
```

Creates the `developers` group if it does not already exist.

## 2. Create the User

```bash
sudo useradd -m -G developers -s /bin/bash devuser
sudo passwd devuser
```

- `-m` — creates a home directory (`/home/devuser`)
- `-G developers` — adds `devuser` as a supplementary member of `developers`
- `-s /bin/bash` — sets a usable login shell

**Verification:**

```bash
id devuser
grep devuser /etc/passwd
grep developers /etc/group
```

Confirms the account exists and that `devuser` is listed in the `developers` group's supplementary member list.

## 3. Write the Scoped Sudo Rule

```bash
sudo visudo -f /etc/sudoers.d/devuser-service-restart
```

Rule contents:

```
devuser ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx
```

**Why this satisfies the security requirement:**
- Full path to the binary (`/usr/bin/systemctl`) prevents PATH-hijacking tricks
- Exact argument string (`restart nginx`) — no wildcard — means `devuser` cannot restart, stop, or start any other unit
- No `ALL` anywhere in the command field, so the grant is a single exact action, not a category of actions

`visudo` (rather than editing `/etc/sudoers` directly) validates syntax before saving, preventing a lockout from a malformed file.

## 4. Test the Allowed Command

```bash
sudo -u devuser sudo /usr/bin/systemctl restart nginx
echo $?
```

Expected: exit code `0`, service restarts successfully.

## 5. Test Denied Commands

```bash
sudo -u devuser sudo /usr/bin/systemctl restart sshd
sudo -u devuser sudo /usr/bin/systemctl stop nginx
```

Both are expected to be rejected with `... is not allowed to execute ...`. This proves the rule is scoped to one exact action on one exact service, not the whole service or command family.

## 6. Verify with `sudo -l`

```bash
sudo -u devuser sudo -l
```

Expected output:

```
User devuser may run the following commands on this-host:
    (root) NOPASSWD: /usr/bin/systemctl restart nginx
```

A single line, no `ALL`, confirms no over-grant of privilege.

## Troubleshooting Log

| # | Symptom | Cause | Fix / Explanation |
|---|---|---|---|
| 1 | `ls /home/devuser` → `Permission denied` (run as non-owner) | Home directory created with mode `700`, owned by `devuser` | Expected behavior, not a misconfiguration — use `sudo ls -ld /home/devuser` or `sudo ls -la /home/devuser` to inspect as admin instead of loosening permissions |
| 2 | `visduo` → command not found | Typo | Corrected to `visudo` |
| 3 | `visudo` (without `sudo`) | Editing `/etc/sudoers` requires root privileges | Re-ran as `sudo visudo` |
| 4 | `sudo -u devuser` alone | No command/shell specified after `-u devuser`, so it did not produce a usable session on its own | Follow with an explicit command (`sudo -u devuser sudo -l`) or drop into a shell (`sudo -u devuser bash`) to test interactively |
| 5 | `sudo -l` (without `-u devuser`) | Checks the *current* user's (`dhoyt`'s) sudo rules, not `devuser`'s | Use `sudo -u devuser sudo -l` to check the target account's rules |

## Optional Cleanup

Once documentation is complete, the lab environment can be torn down:

```bash
sudo visudo -f /etc/sudoers.d/devuser-service-restart   # remove the rule (or delete the file)
sudo userdel -r devuser
sudo groupdel developers
```

- Removing the sudoers rule first prevents any dangling privilege grant tied to an account that's about to be deleted
- `userdel -r` removes the account and its home directory
- `groupdel developers` removes the now-unused group

## Outcome Summary

| Requirement | Evidence |
|---|---|
| Account | `id devuser` output |
| Group | `developers` present in `id devuser` groups list |
| Sudo rule | `/etc/sudoers.d/devuser-service-restart` contents |
| Allowed command | `systemctl restart nginx` succeeds (exit 0) |
| Denied command | `systemctl restart sshd` and `systemctl stop nginx` both rejected |
| `sudo -l` verification | Single matching line, no `ALL` present |
