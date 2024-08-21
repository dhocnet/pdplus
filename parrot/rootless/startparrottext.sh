#!/data/data/com.termux/files/usr/bin/bash

echo -e "\nParrot Security OS failsafe mode ..."; sleep 1
echo "Using generic hardware driver ..."; sleep 1
echo -e "Entering Parrot OS ... \n"; sleep 1
pd login beo --shared-tmp -- /bin/bash -c login

echo -e "\nUnmounting devices ..."; sleep 0.5
echo -e "Leaving Parrot OS ... \n"; sleep 1
exit 1
