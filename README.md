This bash script is meant to run as a script (Settings -> Computer Management -> Scripts) to collect the user’s current Google account information on the machine and push it to Jamf `1`.

`1` You must set up attribute extensions for `jamf recon` to work. For example create an extension attribute named `Ginfo_OU` that runs the following script and places it into the User and Location Inventory.

```
#!/bin/sh
RESULT=$(grep '' /Library/Application\ Support/JAMF/DOD/.Ginfo_orgUnitPath.txt | head -1)
echo "<result>$RESULT</result>"
```

Also, `zz_GoogleJAMFsync.app` must be set up to be installed into the Applications folder. This is where the Python script that is located which scrapes the Google information and outputs it to standard out, ultimately being saved to /Library/Application\ Support/JAMF/DOD/.Ginfo.txt.

