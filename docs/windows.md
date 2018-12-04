## Install Windows Subsystem for Linux
Go to **Settings** and search for **Windows Features** and select **Turn Windows features on or off**.
From there select ***Windows Subsystem for Linux***. Then go to Microsoft Store and install Ubuntu
or any other linux you want. Search Linux to see the full list of apps available.

## Install VirtualBox
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 
Next download [Ubuntu ISO](https://www.ubuntu.com/desktop).
Create a virtual machine, and the first time it asks you the start-up disk. Select
the Ubuntu ISO you downloaded. If you skipped this question, then after starting 
the machine you can go to **Machine** menu and select **Settings**. Select **Storage**
and choose the CD/DVD drive there and then **Choose Virtual Optical Disk Drive** and
choose the Ubuntu ISO and start the machine again.

## Cygwin
Install [Cygwin](https://cygwin.com/install.html). Make sure the following packages are
installed:

* emacs
* curl
* openssl  
 