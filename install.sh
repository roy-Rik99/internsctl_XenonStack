#!/bin/bash


echo "Copying Files to Dir /usr/local/bin"
sudo cp internsctl.sh /usr/local/bin
sudo cp config.sh /usr/local/bin
echo "Copied files internsctl.sh, config.sh"



count=`grep -c "source /usr/local/bin/internsctl.sh" ~/.bashrc`
if [ $count -eq 0 ]; then
	sudo echo "source /usr/local/bin/internsctl.sh" >> ~/.bashrc
	echo "USER $USER .bashrc file edited."
else
	echo "USER $USER .bashrc file already edited."
	echo "No changes done to USER $USER .bashrc file."
fi

source ~/.bashrc
echo "Sourced USER $USER .bashrc file."



echo "Creating /usr/local/man/man1 ..."
if [[ -d /usr/local/man/man1 ]]; then
	echo "/usr/local/man/man1 exists on your filesystem!";
else
	sudo mkdir /usr/local/man/man1
	echo "/usr/local/man/man1 created!"
fi

echo "Copying Man Pages to Dir /usr/local/man/man1"
sudo cp internsctl.1 /usr/local/man/man1

echo "Compressing Man Pages in Dir /usr/local/man/man1"
sudo gzip /usr/local/man/man1/ms.1

echo "Manually updating manual page index database caches"
sudo mandb




#read -p "Install for all Users? (y/n)" flag

#if [ "$flag" = "y" -o "$flag" = "Y" -o "$flag" = "yes" -o "$flag" = "Yes" ]; then
#	sudo echo "source /usr/local/bin/internsctl.sh" >> /etc/bash.bashrc
#elif [ "$flag" = "n" -o "$flag" = "N" -o "$flag" = "no" -o "$flag" = "No" ]; then
#	sudo echo "source /usr/local/bin/internsctl.sh" >> ~/.bashrc
#else
#	echo "Wrong Option!"
#fi
