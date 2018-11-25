# EnumScript
--- This script is used for OSCP exam. ---
To run the file you should get execute permission with the command:
chmod +x EnumerationScript.sh

How to work with this Script?

This script is going through deep investigation for network enumuration.
This script should run on background while the attacker is exploiting machines on the network, the script is simply used for advanced enum purpose which take time.

How to reduce execution time?

In the script there is build in brute force attack via NSE script for SSH and FTP protocols.
you may delete the lines with the brute force or alter thouse lines with comment.

What's the script contains?

1. Scan network segment ( should be change for your own needs inside the file [ line 25 ] )
2. enum4linux - check for each available machine
3. Faw NSE scripts which enumerate the following ports:
  A. 21
  B. 22
  C. 25
  D. 80
  E. 110
  F. 139
  G. 445
  H. 3389
  
Good luck focks
