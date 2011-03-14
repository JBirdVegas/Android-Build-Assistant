#!/bin/bash

#chmod a+x <filename>
# ! run as root !
#

#we need this later
REPO="git://github.com/CyanogenMod/android.git"
echo "Source repositorty = "$REPO

	#check for 32/64 bit enviroment
	if [ `uname -a | grep -o "x86_64"` ]; then
		echo "64 bit system present"
		BIT="64bit"
	  else
		echo "32 bit system present"
		BIT="32bit"
	fi

	#check for root
	if [ $USER = "root" ]; then
		echo "good $SUDO_USER root detected"
		echo ""
	  else
		echo "try running as root"
		exit 0
	fi
		
#What CyanogenMod supported device
echo "1  -Commitiva Z71"
echo "2  -Geeksphone One"
echo "3  -HTC Ace"
echo "4  -HTC Aria"
echo "5  -HTC Desire CDMA"
echo "6  -HTC Desire GSM"
echo "7  -HTC Dream"
echo "8  -HTC Evo 4G"
echo "9  -HTC Glacier"
echo "10 -HTC Hero CDMA"
echo "11 -HTC Hero GSM"
echo "12 -HTC Incredible"
echo "13 -HTC Legend"
echo "14 -HTC Magic"
echo "15 -HTC Passion"
echo "16 -HTC Slide"
echo "17 -HTC Vision"
echo "18 -HTC Wildfire"
echo "19 -Motorola Droid"
echo "20 -Samsung Galaxy S"
echo "21 -Samsung Nexus S"
echo "22 -Viewsonic G Tablet"
echo "23 -ZTE G Tablet"
echo "24 -Bn Encore"
echo "*************************"
echo ""
	read WHAT

	#set variables for build
	if [ "$WHAT" = "1" ]; then
		MAKE="commtiva"
		MODEL="z71"
	elif [ "$WHAT" = "2" ]; then
		MAKE="geeksphone"
		MODEL="one"
	elif [ "$WHAT" = "3" ]; then
		MAKE="htc"
		MODEL="ace"
	elif [ "$WHAT" = "4" ]; then
		MAKE="htc"
		MODEL="liberty"
	elif [ "$WHAT" = "5" ]; then
		MAKE="htc"
		MODEL="bravoc"
	elif [ "$WHAT" = "6" ]; then
		MAKE="htc"
		MODEL="bravo"
	elif [ "$WHAT" = "7" ]; then
		MAKE="htc"
		MODEL="dream_sapphire"
	elif [ "$WHAT" = "8" ]; then
		MAKE="htc"
		MODEL="supersonic"
	elif [ "$WHAT" = "9" ]; then
		MAKE="htc"
		MODEL="glacier"
	elif [ "$WHAT" = "10" ]; then
		MAKE="htc"
		MODEL="heroc"
	elif [ "$WHAT" = "11" ]; then
		MAKE="htc"
		MODEL="hero"
	elif [ "$WHAT" = "12" ]; then
		MAKE="htc"
		MODEL="inc"
	elif [ "$WHAT" = "13" ]; then
		MAKE="htc"
		MODEL="legend"
	elif [ "$WHAT" = "14" ]; then
		MAKE="htc"
		MODEL="dream_sapphire"
	elif [ "$WHAT" = "15" ]; then
		MAKE="htc"
		MODEL="passion"
	elif [ "$WHAT" = "16" ]; then
		MAKE="htc"
		MODEL="espresso"
	elif [ "$WHAT" = "17" ]; then
		MAKE="htc"
		MODEL="vision"
	elif [ "$WHAT" = "18" ]; then
		MAKE="htc"
		MODEL="buzz"
	elif [ "$WHAT" = "19" ]; then
		MAKE="motorola"
		MODEL="sholes"
	elif [ "$WHAT" = "20" ]; then
		MAKE="samsung"
		MODEL="vibrant"
	elif [ "$WHAT" = "21" ]; then
		MAKE="samsung"
		MODEL="crespo"
	elif [ "$WHAT" = "22" ]; then
		MAKE="nvidia"
		MODEL="harmony"
	elif [ "$WHAT" = "23" ]; then
		MAKE="zte"
		MODEL="blade"
	elif [ "$WHAT" = "24" ]; then
		MAKE="bn"
		MODEL="encore"
	  else
		echo "Unknown selection"
	fi

	
		
#MAIN MENU
GO="4"
clear
echo "Building for :"
echo $MODEL
echo $MAKE
echo ""
echo "1 -Setup build enviroment"
echo "*** dependant on propper build enviroment"
echo "2 -Sync and build CyanogenMod Nightly"
echo "3 -Just build CyanogenMod Nightly"
echo "4 -Exit"
echo ""
echo "1,2,3,4"
echo "*****************************************"
read GO

#setup (1)menu goes first build(2) && build(3) will wait

if [ "$GO" = "1" ]; then
	clear	
	echo ""
	echo "1 -Full Setup"
	echo "*** Individual setup commands"
	echo "*** if doing full install via each step then go in order"
	echo "2 -Make directories"
	echo "3 -Get build packages"
	echo "4 -Curl Repo"
	echo "5 -Install SDK and ADB (now a 2 part process)"
	echo "6 -Repo CyanogenMod's github"
	echo "7 -Copy proprietary files"
	echo "8 -Get RomManager"
	echo "********************************************************"
	read SETUP
	SETUP=$SETUP
	clear

	#full setup
	if [ "$SETUP" = "1" ]; then
		sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush schedtool
		add-apt-repository "deb http://archive.canonical.com/ maverick partner"		
		if [ "$BIT" = "bit64" ]; then
			sudo apt-get install g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline5-dev gcc-4.3-multilib g++-4.3-multilib
		fi
		mkdir /home/$SUDO_USER/dev
		mkdir /home/$SUDO_USER/dev/android-sdk-linux_x86
		cd /home/$SUDO_USER/dev/android-sdk-linux_x86
		wget http://dl.google.com/android/android-sdk_r10-linux_x86.tgz -O - | tar -zxvf -
		echo "changing ownership of sdk"		
		chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86		
		/home/$SUDO_USER/dev/android-sdk-linux_x86/tools/android update adb
		echo "changing ownership of adb update"
		chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86
		export PATH=$PATH:/home/$SUDO_USER/bin:/home/$SUDO_USER/dev/android-sdk-linux_x86/platform-tools
		~/android/system/vendor/cyanogen/get-rommanager
		cd /home/$SUDO_USER/android/system
		repo init -u $REPO -b gingerbread
		repo sync
		echo "Enter to continue"		
		read -p "Connect your device loaded with a CyanogenMod ROM with usb debugging enabled"
		adb kill-server
		adb start-server
		cd /home/$SUDO_USER/android/system/device/$MAKE/$MODEL
		./extract-files.sh
		echo ""
		echo "if any errors try #6 under setup for a second chance"

	#make directories
	elif [ "$SETUP" = "2" ]; then
		mkdir -pv /home/$SUDO_USER/android/system
		mkdir -pv /home/$SUDO_USER/dev/android-sdk-linux_x86
		echo "made directories"; echo "~/android/system"; echo "~/dev/android-sdk-linux_x86"; echo "and parent directories as needed"

	#get build packages
	elif [ "$SETUP" = "3" ]; then
		sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush schedtool
		add-apt-repository "deb http://archive.canonical.com/ maverick partner"		
		if [ "$BIT" = "bit64" ]; then
			sudo apt-get install g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline5-dev gcc-4.3-multilib g++-4.3-multilib
		fi

	#get repo
	elif [ "$SETUP" = "4" ]; then
		mkdir -p ~/bin
		mkdir -p ~/android/system
		curl http://android.git.kernel.org/repo > ~/bin/repo
		chmod a+x ~/bin/repo
		export PATH=$PATH:/home/$SUDO_USER/bin
		
	#install sdk
	elif [ "$SETUP" = "5" ]; then
		mkdir -p /home/$SUDO_USER/dev/android-sdk-linux_x86
		cd /home/$SUDO_USER/dev/android-sdk-linux_x86
		wget http://dl.google.com/android/android-sdk_r10-linux_x86.tgz -O - | tar -zxf -
		echo "Changing ownership of sdk step 1"
		chown -R $SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86
		#cli trigger for sdk update required since it brings down adb (android developement bridge) doccumented ~/dev/android-sdk-linux_x86/SDK Readme.txt
		tools/android update adb
		echo "Changing ownership of adb update"
		chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86
		export PATH=$PATH:/home/$SUDO_USER/dev/android-sdk-linux_x86/platform-tools
		adb kill-server
		adb start-server

	#repo git://github.com/CyanogenMod/android.git address represented by $REPO
	elif [ "$SETUP" = "6" ]; then
		cd /home/$SUDO_USER/android/system
		repo init -u $REPO -b gingerbread
		repo sync

	#Copy proprietary files manufacturer=$MAKE device=$MODEL
	elif [ "$SETUP" = "7" ]; then
		cd /home/$SUDO_USER/android/system/device/$MAKE/$MODEL
		./extract-files.sh

	#Get rommanager
	elif [ "$SETUP" = "8" ]; then
		/home/$SUDO_USER/android/system/vendor/cyanogen/get-rommanager
	  else 
		echo "Unknown Responce"	
	fi

#MAIN MENU sync and build(2) assumes step 1 was completed ...duh
elif [ "$GO" = "2" ]; then
	cd /home/$SUDO_USER/android/system
	repo init -u $REPO -b gingerbread
	repo sync
	. build/envsetup.sh && brunch $MODEL

#MAIN MENU no sync just build(3) assumes step 1 was completed ... duh
elif [ "$GO" = "3" ]; then
	cd /home/$SUDO_USER/android/system
	. build/envsetup.sh && brunch $MODEL

#MAIN MENU exit option
elif [ "$GO" = "4" ]; then
	exit
  else
	echo "Unknown Responce"
fi
####### CREDIT#########
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "|                                                                   |"
echo "|         Hope you this worked for you                              |"
echo "|            any questions let me know                              |"
echo "|                           ~JBirdVegas@gmail.com                   |"
echo "|                                                                   |"
echo "|  *** want to donate? go to www.cyanogenmod.com they earn it  ***  |"
echo "|                                                                   |"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
exit
