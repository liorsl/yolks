#!/bin/ash

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Print Node.js version
node -v

# Vars
# REPOSITORY_HOST
# Load git repo
if [[ ! "${USERNAME}" == "" ]]; then
    if [[ ! https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git = *\.git ]]; then
      INSTALL_REPO=$(echo -e https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git | sed 's:/*$::')
      INSTALL_REPO="https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git"
    fi

    echo -e "working on installing a discord.js bot from https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git"

    if [ "${USER_UPLOAD}" == "true" ] || [ "${USER_UPLOAD}" == "1" ]; then
    	echo -e "assuming user knows what they are doing have a good day."
    	exit 0
    fi

    if [ "$(ls -A /home/container)" ]; then
    	echo -e "/home/container directory is not empty."
         if [ -d .git ]; then
    		echo -e ".git directory exists"
    		if [ -f .git/config ]; then
    			echo -e "loading info from git config"
    			ORIGIN=$(git config --get remote.origin.url)
    		else
    			echo -e "files found with no git config"
    			echo -e "closing out without touching things to not break anything"
    			exit 10
    		fi
    	fi
    	if [ "${ORIGIN}" == "https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git" ]; then
    		echo "pulling latest from ${REPOSITORY_HOST}"
    		git pull
    	fi
    else
       	echo -e "/home/container is empty.\ncloning files into repo"
    	if [ -z ${INSTALL_BRANCH} ]; then
    		echo -e "assuming master branch"
    		INSTALL_BRANCH=master
    	fi
    		echo -e "running 'git clone --single-branch --branch ${INSTALL_BRANCH} https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git .'"
	   		git clone --single-branch --branch ${INSTALL_BRANCH} https://${USERNAME}:${PASSWORD}@${REPOSITORY_HOST}/${INSTALL_REPO}.git .
   	fi

else
    if [[ ! ${INSTALL_REPO} = *\.git ]]; then
      INSTALL_REPO=$(echo -e ${INSTALL_REPO} | sed 's:/*$::')
      INSTALL_REPO="${INSTALL_REPO}.git"
    fi

    echo -e "working on installing a discord.js bot from ${INSTALL_REPO}"

    if [ "${USER_UPLOAD}" == "true" ] || [ "${USER_UPLOAD}" == "1" ]; then
    	echo -e "assuming user knows what they are doing have a good day."
    	exit 0
    else
    	if [ "$(ls -A /home/container)" ]; then
    		echo -e "/home/container directory is not empty."
    	     if [ -d .git ]; then
    			echo -e ".git directory exists"
    			if [ -f .git/config ]; then
    				echo -e "loading info from git config"
    				ORIGIN=$(git config --get remote.origin.url)
    			else
    				echo -e "files found with no git config"
    				echo -e "closing out without touching things to not break anything"
    				exit 10
    			fi
    		fi
    		if [ "${ORIGIN}" == "${INSTALL_REPO}" ]; then
    			echo "pulling latest from ${REPOSITORY_HOST}"
    			git pull
    		fi
    	else
        	echo -e "/home/container is empty.\ncloning files into repo"
    		if [ -z ${INSTALL_BRANCH} ]; then
    			echo -e "assuming master branch"
    			INSTALL_BRANCH=master
    		fi

    		echo -e "running 'git clone --single-branch --branch ${INSTALL_BRANCH} ${INSTALL_REPO} .'"
    		git clone --single-branch --branch ${INSTALL_BRANCH} ${INSTALL_REPO} .
    	fi
    fi
fi

echo "Installing NPM packages..."
/usr/local/bin/npm install --production
eco "Starting bot"
