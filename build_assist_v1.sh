#!/bin/bash
motorola=$make
sholes=$model

########################
# chmod a+x menu-cm.sh #
# Script must be root  #
########################
	if [ $USER = "root" ]; then
		echo "good you have root"
	  else
		echo "must be root to continue"
		echo "run script as root"
		echo "try: sudo ./menu-cm.sh"		
		exit
	fi
echo "man it's late "
echo "so $SUDO_USER the chef is still up"
echo ""
	
echo "what do you want from the kitchen"
echo ""
echo "i want ..."
echo "1 -Red Bull because I'm just getting started"
echo "	Initial download/install (sdk, repo, build packages" 
echo "	and pulls proprietary files from 'phone')"
echo "	***this must only be done once***"
echo ""
echo "2 -Just a snack"
echo "	this just brings down the source to ~/android/system"
echo ""
echo "3 -Nightcap before bed I'm a Guinness with a Grand Marnier kind of guy"
echo "	checks for updates in build packages and sync's with CM's github"
echo ""
echo "4 -Fourth Meal"
echo "	this will sync and build for "$make" / "$model
echo ""
echo "5 -Repair"
echo "	cleans /home/$SUDO_USER/.repo && /home/$SUDO_USER/android/system/.repo"
echo "	allows repo to reconfigure automatically it seems to help with repo problems"
echo "	"
echo "1,2,3,4,5"
#TODO add option 1a  -just update proprierary files if files fail
read CHEF
CHEF=$CHEF
if [ "$CHEF" = "1" ]; then
	#TODO add splash about why we need root
	echo ""
	echo "ok here is your liquid crack"
	sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush schedtool
	add-apt-repository "deb http://archive.canonical.com/ maverick partner"
	echo "looking for x86_64 architecture"
	if [ `uname -a | grep -o "x86_64"` ]; then
		echo "x86_64!!!"
        	echo "installing 32bit library files for 64bit architecture"
        	sudo apt-get install g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline5-dev gcc-4.3-multilib g++-4.3-multilib
 	  else 
		echo "not x86_64"
	fi
	echo "making android's home"
	echo "mkdir ~/android"
	mkdir ~/android
	echo "mkdir ~/android"
	mkdir ~/android/system
	echo "using curl to get repo and chmod to make executable"
	echo ""
	mkdir ~/bin
	curl http://android.git.kernel.org/repo > ~/bin/repo
	chmod a+x ~/bin/repo

#TODO this sucks; code just doesn't flow
	echo "let's swing by google and get the sdk"
	mkdir /home/$SUDO_USER/dev	
	mkdir /home/$SUDO_USER/dev/android-sdk-linux_x86
	cd /home/$SUDO_USER/dev
	echo "Downloading SDK and extracting..........."
	wget http://dl.google.com/android/android-sdk_r10-linux_x86.tgz -O - | tar -zxvf -
	echo ""
	echo "root owns the sdk let's fix that so we can use platform tools"
	chown -Rv $SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86
	echo "*************************************"	
	echo "* the SDK is now a two step process *"
	echo "*************************************"
	echo "as doccumented /home/$SUDO_USER/dev/android-sdk-linux_x86/SDK Readme.txt"
	echo "$ /home/$SUDO_USER/dev/android-sdk-linux_x86/tools/android update sdk"
	echo "script will continue when you close the window"
	echo ""
#TODO this is the problem bash CLI returns error and launches GUI I'm sure we can fix this I'm just not sure how ... yet.
	/home/$SUDO_USER/dev/android-sdk-linux_x86/tools/android -v update sdk	
	echo "DONE with two stage install of SDK"
	echo "just to be sure $SUDO_USER owns the sdk and not root"
	chown -Rv $SUDO_USER:$SUDO_USER /home/$SUDO_USER/dev/android-sdk-linux_x86
	
	echo "updating PATH -must be done by root or sudo"
	PATH=$PATH:/home/$SUDO_USER/bin:/home/$SUDO_USER/dev/android-sdk-linux_x86/platform-tools
	export $PATH
	echo "updated PATH:"
	echo $PATH
	sudo echo $PATH
#TODO fix: this returns error ':not a valid identifier	echo "now we are going to export the PATH to /etc/bash.bashrc"
	#echo "to make the PATH to repo and sdk persistant"
	#sudo echo "export PATH=$PATH:/home/$SUDO_USER/bin:/home/$SUDO_USER/dev/android-sdk-linux_86/platform-tools" >> /etc/bash.bashrc

	echo "now we need to get rommanager's latest and greatest"
	~/android/system/vendor/cyanogen/get-rommanager
	echo ""
	echo "time to get CM's source"
	cd /home/$SUDO_USER/android/system
	repo init -u git://github.com/CyanogenMod/android.git -b gingerbread	
	sudo repo sync
	echo ""
	echo "restarting adb server"
	sudo adb kill-server
	sudo adb start-server
	echo "ok now lets get use adb to pull proprietary files"
	echo "CM and his team has made this SUPER simple"
	echo "go get your phone. reboot into recovery and mount the system; this option is under advanced.  Connect your phone via USB"
	echo " . . . waiting for you . . ."
	read -p "press a button get a treat"
	echo ". ~/android/system/device/$make/$model/extract-files.sh"
	
	cd ~/android/system/device/$make/$model
	./extract-files.sh
	echo "did you see any failed file transfers?"
	echo "if the output shows any errors you should stop"
	echo "this will cause the default build to fail"
	echo "if you need special build specs modify:"
	echo "~/android/system/device/$make/$model"
		read ERR
			ERR=$ERR
			if [ $ERR = "y"]; then
				echo "It's the easiest build error to troubleshoot"
				echo "just change ROMs anyone of CyanogenMod's gingerbread editions will work"
				echo "***because devs change default values to suit their needs not all Roms contain all default proprietary files"
			exit
			fi
	echo "ok so to claify... this is what we did"
	echo "we installed:"
	echo "git-core"
	echo "gnupg"
	echo "flex"
	echo "bison"
	echo "gperf"
	echo "libsdl1.2-dev"
	echo "libesd0-dev"
	echo "libwxgtk2.6-dev"
	echo "squashfs-tools"
	echo "build-essential"
	echo "zip"
	echo "curl"
	echo "libncurses5-dev"
	echo "zlib1g-dev"
	echo "sun-java6-jdk"
	echo "pngcrush"
	echo "schedtool"
	echo "g++-multilib"
	echo "lib32z1-dev"
	echo "lib32ncurses5-dev"
	echo "lib32readline5-devgcc-4.3-multilib"
	echo "g++-4.3-multilib"
	echo "repo >> ~/bin SDK installed to ~/android-sdk-linux_86/"
	echo "we got the latest ROM Manager"
	echo "then we pulled the proprietary files from your phone"	
	echo ""
	echo "now it is recommended you reboot"
	echo "do you want me to reboot for you?"
	echo ""	
	echo "fyi 'y' won't cut it I need a full 'yes' anything else exits"
	echo "[yes/no]"
	read DOIT
	DOIT=$reboot
	if [ "$reboot" = "yes" ]; then
	reboot
	  else exit
	fi
fi
if [ "$CHEF" = "2" ]; then
	echo ""
	echo "commands about to be executed"
	echo "cd ~/android/system"
	echo "repo init -u git://github.com/CyanogenMod/android.git"
	echo "repo sync"
	cd /home/$SUDO_USER/android/system
	repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
	sudo repo sync
fi
if [ "$CHEF" = "3" ]; then
	echo ""
	echo "Nightcap it is ... "
	echo "How does a stout with a Grand Marnier neat in a rocks glass sound?"
	echo "...I need a drink hang on . . . MUCH BETTER . . . ok let's see if we are up to date"
	echo "checking build libs . . ."
	sudo apt-get install git-core gnupg flex bison gperf libsdl1.2-dev libesd0-dev libwxgtk2.6-dev squashfs-tools build-essential zip curl libncurses5-dev zlib1g-dev sun-java6-jdk pngcrush schedtool
		if [ `uname -a | grep -o "x86_64"` ]; then
			apt-get install g++-multilib lib32z1-dev lib32ncurses5-dev lib32readline5-dev gcc-4.3-multilib g++-4.3-multilib
		fi
	echo "ok now that we got the boring stuff done let's just see if we have CyanogenMod's latest and greatest!!!"
	cd /home/$SUDO_USER/android/system
	repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
	repo sync
fi
if [ "$CHEF" = "4" ]; then
	echo ""
	echo "YEAH!!! I'm a HUGE fan of fourth meal or dinner_2.0 as it is known @ mi casa. I'm thinking steak?"
	echo "umm steak"
	echo ""
	echo "anyways lets get started"
	echo "should we sync w/CyanogenMod's github?"
	echo "***repo sync will blowout any of your code edits***"
	echo "[y/n]"
	read SYNC
	SYNC=$SYNC
		if [ "$SYNC" = "y" ]; then
			echo ""			
			echo "Ok let's sync"
			echo ""			
			cd /home/$SUDO_USER/android/system
			repo init -u git://github.com/CyanogenMod/android.git
			repo sync
		  else
			echo "Ok your edits WILL be included in the build"
			echo "setting build enviroment to suit our needs"
			cd /home/$SUDO_USER/android/system
		fi
	echo "let's burn some cpu cycles!!!"
	echo "don't get crazy this will take a few mins"
	
#TODO breakfast not working ??root??
#TODO build not working also ... once again ??root??
	cd /home/$SUDO_USER/android/system	
	#breakfast sholes
	su -c ". build/envsetup.sh && brunch $model"
	echo ""
	echo "the rom YOU compiled will be in the ~/android/system/out/you want file that starts with update if you notice there is a ****.md5 many of your followers will want to know what the md5 value is for download verification."
fi
if [ "$CHEF" = "5" ]; then
	mkdir ~/bin
	curl http://android.git.kernel.org/repo > ~/bin/repo
	chmod a+x ~/bin/repo
	echo "cleaning repo's config"
	sudo rm -Rv /home/$SUDO_USER/android/system/.repo
	echo "reinstalling Rom Manager"
	~/android/system/vendor/cyanogen/get-rommanager
	echo "adb kill-server"
	adb kill-server
	echo "adb start-server"
	adb start-server
	echo "begin repo?"
	echo "y/n"
	read REPO
	REPO=$REPO
		if [ "$REPO" = "y" ]; then
		cd /home/$SUDO_USER/android/system
		echo "PATH update"
		PATH=$PATH:/home/$SUDO_USER/bin:/home/$SUDO_USER/dev/android-sdk-linux_x86/platform-tools
		export $PATH
		echo "re-init repo"	
		sudo repo init -u git://github.com/CyanogenMod/android.git -b gingerbread
		sudo repo sync
		sudo chown -Rv $SUDO_USER:$SUDO_USER /home/$SUDO_USER/android
		fi
			else
		echo "try rerunning to finish your build"
		fi
fi	
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "|                                                                   |"
echo "|         Hope you this worked for you                              |"
echo "|             any questions let me know                             |"
echo "|                           ~JBirdVegas@gmail.com                   |"
echo "|                                                                   |"
echo "|   want to donate? go to www.cyanogenmod.com they earn it          |"
echo "|                                                                   |"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
