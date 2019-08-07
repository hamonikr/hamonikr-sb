#!/bin/bash

# hamonikr-secure-chain
# Copyright (C) 2019 HamoniKR (https://hamonikr.org)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# Make sure only root can run 
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Print help message
if [ -z "$1" ]
then
	echo "Usage : $0 create-key | upadte-chain | verify"
	echo "$0 create-key : Create RSA key pair for HamoniKR"		
	echo "$0 update-chain : Apply Secure Chain for HamoniKR"
	echo "$0 verify : Verify Secure Chain Sigining Files for HamoniKR"	
	exit
fi

# Run with options
case "$1" in
	create-key ) echo "Create RSA key pair for HamoniKR"
		openssl genrsa -out hamonikr.rsa 2048
		openssl req -new -x509 -sha256 -subj '/CN=HAMONIKR' -key hamonikr.rsa -out hamonikr.pem
		openssl x509 -in hamonikr.pem -inform PEM -out hamonikr.der -outform DER

		# guid=$(uuidgen)
		# //echo $guid	

		# sbsiglist --owner $guid --type x509 --output hamonikr.der.siglist hamonikr.der	

		# sudo mkdir -p /etc/secureboot/keys/{PK,KEK,db,dbx}
		# sudo cp *.PK.signed /etc/secureboot/keys/PK/
		# sudo cp *.KEK.signed /etc/secureboot/keys/KEK/
		# sudo cp *.db.signed /etc/secureboot/keys/db/	
		# for n in PK KEK db
		# do
		# 	sbvarsign --key hamonikr.rsa --cert hamonikr.pem \
		# 			--output hamonikr.der.siglist.$n.signed \
		# 				$n hamonikr.der.siglist
		# done	
		;;
	update-chain ) echo  "Apply Secure Chain for HamoniKR"
		sbkeysync --verbose --pk --dry-run

		# stage1 with shim
		sudo sbsign --key hamonikr.rsa --cert hamonikr.pem --output shimx64.efi /boot/efi/efi/ubuntu/shimx64.efi
		sudo cp /boot/efi/EFI/ubuntu/shimx64.efi{,.bak}
		sudo cp shimx64.efi /boot/efi/EFI/ubuntu/
		
		# stage2 with grub
		sudo sbsign --key hamonikr.rsa --cert hamonikr.pem --output grubx64.efi /boot/efi/efi/ubuntu/grubx64.efi
		sudo cp /boot/efi/EFI/ubuntu/grubx64.efi{,.bak}
		sudo cp grubx64.efi /boot/efi/EFI/ubuntu/
		;;
	verify ) echo  "Verify Secure Chain Sigining Files for HamoniKR"
		echo -e "${green}"	
		sudo sbverify --cert hamonikr.pem /boot/efi/efi/ubuntu/shimx64.efi     
		sudo sbverify --cert hamonikr.pem /boot/efi/efi/ubuntu/grubx64.efi 
		echo -e "${green}"				
		echo -e "Current System Secure Booting State"
		echo -e "${red}"		
		sudo mokutil --sb-state
		echo "${reset}"				
		;;
	*) echo "Check Program option"
		echo "Usage : $0 create-key | upadte-chain | verify"
		echo "$0 create-key : Create RSA key pair for HamoniKR"		
		echo "$0 update-chain : Apply Secure Chain for HamoniKR"
		echo "$0 verify : Verify Secure Chain Sigining Files for HamoniKR"			
	;;
esac
