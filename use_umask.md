# umask nutzen

In short, umask is used to restrict the access rights of new folders and files in such a way that only authorized users can have read, write and execute access.

A simple application is to protect new files and directories against third parties as soon as they are created.

## Default Values

Default umask for user root on Ubuntu systems:
```
octal   | 0022
binary  | 000,010,010
acl     | ---,-w-,-w-
```

Default umask for *normal* users on Ubuntu systems:
```
octal   | 0002
binary  | 000,000,010
acl     | ---,---,-w-
```  

Default directory base permissions:
```
octal   | 0777
binary  | 111,111,111
acl     | rwx,rwx,rwx
```

Default file base permissions:
```
octal   | 0666
binary  | 110,110,110
acl     | rw-,rw-,rw-
```

## General Calculations

```
[new created directory permission] = [directory base permission] !& [umask]
[new created file permission]      = [file base permission]      !& [umask]
```

Example: user root creates a new directory.

Calculation:
```
   111111111 | 0777 | rwxrwxrwx
!& 000010010 | 0022 | ----w--w-
   ----------------------------
   111101101 | 0755 | rwxr-xr-x
   ============================
```

The new directory has permission **user::rwx,group::r-x,other::r-x**

## Further Example

The console command:
```
umask 0027
```

sets the umask to **0027** aka **000010111** aka **----w-rwx**

This setting results in this *new created directory permission*:
```
   111111111 | 0777 | rwxrwxrwx
!& 000010111 | 0027 | ----w-rwx
   ----------------------------
   111101000 | 0750 | rwxr-x---
   ============================
```

and that *new created file permission*:
```
   110110110 | 0666 | rw-rw-rw-
!& 000010111 | 0027 | ----w-rwx
   ----------------------------
   110100000 | 0640 | rw-r-----
   ============================
```
