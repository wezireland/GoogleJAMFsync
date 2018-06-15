#!/bin/sh
currentUser=`ls -l /dev/console | awk {' print $3 '}`
emailAddress0=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Default/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress1=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 1/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress2=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 2/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress3=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 3/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress4=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 4/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress5=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 5/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress6=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 6/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress7=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 7/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress8=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 8/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress9=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 9/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress10=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 10/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress11=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 11/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress12=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 12/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress13=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 13/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress14=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 14/Preferences | cut -d',' -f3 | cut -d'"' -f4)
emailAddress15=$(grep @ /Users/$currentUser/Library/Application\ Support/Google/Chrome/Profile\ 15/Preferences | cut -d',' -f3 | cut -d'"' -f4)

echo "$emailAddress0"
echo "$emailAddress1"
echo "$emailAddress2"
echo "$emailAddress3"
echo "$emailAddress4"
echo "$emailAddress5"
echo "$emailAddress6"
echo "$emailAddress7"
echo "$emailAddress8"
echo "$emailAddress9"
echo "$emailAddress10"
echo "$emailAddress11"
echo "$emailAddress12"
echo "$emailAddress13"
echo "$emailAddress14"
echo "$emailAddress15"

mkdir /Library/Application\ Support/JAMF/DOD
echo "$emailAddress0" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress1" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress2" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress3" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress4" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress5" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress6" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress7" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress8" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress9" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress10" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress11" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress12" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress13" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress14" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt
echo "$emailAddress15" >> /Library/Application\ Support/JAMF/DOD/.emailAddress.txt

emailAddress=$(grep doctorondemand.com /Library/Application\ Support/JAMF/DOD/.emailAddress.txt | head -1)
echo "$emailAddress"

## This installs required bash apps.
sudo -H easy_install pip
sudo -H /usr/local/bin/pip install --upgrade pip
sudo -H easy_install virtualenv

## This builds the virtual bash environment, activates the environment, and updates the Google API Python Client.
sudo -H /usr/local/bin/virtualenv /Applications/zz_GoogleJAMFsync.app/env
source /Applications/zz_GoogleJAMFsync.app/env/bin/activate
pip install --upgrade google-api-python-client
pip install --upgrade oauth2client

## This executes the locally installed Python app against our Google Admin API using the email address captured above and stores it in the variable "$OU".
Ginfo=$(python /Applications/zz_GoogleJAMFsync.app/google_v2.py $emailAddress)

## This cleans up the virtual environment.
sudo rm -rf /Applications/zz_GoogleJAMFsync.app/env
sudo rm -rf /Applications/zz_GoogleJAMFsync.app/google_v2.pyc

if [ "$Ginfo" == "" ];then
    echo "Error: Unable to retrieve Ginfo"
    echo "0" > /Library/Application\ Support/JAMF/DOD/.Ginfo.txt
    jamf recon
else

# This echoes the "$OU" variable back to the JAMF log.
echo "$Ginfo" | tr '[' '\n' | tr ']' '\n'
# This echoes the "$OU" variable back to a hidden text file.
echo "$Ginfo" | tr '[' '\n' | tr ']' '\n' > /Library/Application\ Support/JAMF/DOD/.Ginfo.txt

thumbnailPhotoUrl=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep thumbnailPhoto | awk -F"thumbnailPhotoUrl" '/thumbnailPhotoUrl/{print $2}' | awk -F"'" '{print $3}')
manager=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep manager | awk -F"manager" '/manager/{print $2}' | awk -F"'" '{print $5}')
orgUnitPath=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep orgUnitPath | awk -F"orgUnitPath" '/orgUnitPath/{print $2}' | awk -F"'" '{print $3}')
isEnforcedIn2Sv=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep isEnforcedIn2Sv | awk -F"isEnforcedIn2Sv" '/isEnforcedIn2Sv/{print $2}' | awk -F"'" '{print $2}' | cut -d' ' -f2 | cut -d',' -f1)
title=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep title | awk -F"title" '/title/{print $2}' | awk -F"'" '{print $3}')
costCenter=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep costCenter | awk -F"costCenter" '/costCenter/{print $2}' | awk -F"'" '{print $3}')
department=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep department | awk -F"department" '/department/{print $2}' | awk -F"'" '{print $3}')
fullName=$(cat /Library/Application\ Support/JAMF/DOD/.Ginfo.txt | grep fullName | awk -F"fullName" '/fullName/{print $2}' | awk -F"'" '{print $3}')

echo "Image: $thumbnailPhotoUrl"
echo "Manager: $manager"
echo "OU: $orgUnitPath"
echo "2FA: $isEnforcedIn2Sv"
echo "Title: $title"
echo "Cost Center: $costCenter"
echo "Department: $department"
echo "Full Name: $fullName"

echo "$thumbnailPhotoUrl" > /Library/Application\ Support/JAMF/DOD/.Ginfo_thumbnailPhotoUrl.txt
echo "$manager" > /Library/Application\ Support/JAMF/DOD/.Ginfo_manager.txt
echo "$orgUnitPath" > /Library/Application\ Support/JAMF/DOD/.Ginfo_orgUnitPath.txt
echo "$isEnforcedIn2Sv" > /Library/Application\ Support/JAMF/DOD/.Ginfo_isEnforcedIn2Sv.txt
echo "$title" > /Library/Application\ Support/JAMF/DOD/.Ginfo_title.txt
echo "$costCenter" > /Library/Application\ Support/JAMF/DOD/.Ginfo_costCenter.txt
echo "$department" > /Library/Application\ Support/JAMF/DOD/.Ginfo_department.txt
echo "$fullName" > /Library/Application\ Support/JAMF/DOD/.Ginfo_fullName.txt

jamf recon

fi

