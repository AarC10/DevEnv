# Intro
Contains a few scripts I used for CAing because I have a crusade against GUIs. Should be significantly faster than GitHub Classroom in both frontend (literally run a single terminal command instead of clicking a bunch of dumb buttons) and backend (does cloning and pulling operations concurrently instead of sequentially)

# Setup
**Disclaimer: These scripts were used for a year in a UNIX environment, but is somewhat tested to work for Windows if git bash is being used. This was meant to be platform independent though.**
(just take the red pill and switch already smh)

**Braindead Setup**
 1. Get all the scripts in a single folder
 2. Open your terminal and make sure you are in your home directory. Just do a ```cd ~``` if you're unsure.
 3. Modify your shell config file (```.bashrc``` most likely for most people. ```.zshrc``` for Mac users probably. You should know what this is if you have a custom one). Use vim if you're cool.
 4. At the end of your config file add the line ```source (PATH TO SCRIPTS)/sourcer```. PATH TO SCRIPTS being your path to scripts... obviously.
 5. Reload your terminal or just do a ```source (SHELL CONFIG FILE)```
 6. Update the repo_list file with a unit of repos you have to grade. Screw around with some of the commands in a safe directory. 

**More Braindead Setup**
 1. Use Linux
 2. Copy all the scripts into your bin
 3. Profit (you do need to create a new ```repo_list``` file for the current working directory where you plan on doing stuff and run ```sed``` manually for replacing) 

# Script File Explanations

## cloner

Reads in a ```repo_list``` file in the same directory as the script and clones them all into the current working directory

## puller
Runs ```git pull``` on every subdirectory that is found to be a git repository. 
**WARNING: Make sure you run this command in the right place or you may unintentionally pull a repo you did not want to.**
 
## replacer

Prompts you with a unit number to replace the unit number in the ```repo_list``` file.
For example, if all of the GitHub URLs have unit00 and you enter 01, the new URLs will become unit01.

## creator
Sets up an entire unit of repositories for you automatically. Will handle both ```replacer``` and ```cloner``` functionality for you and place them in the correct directory. Running this command will create a new directory with the unit number, and several sub-directories for classwork, homework (1 and 2) and mini practicum.  If a -s is used as the first argument, it will just make the directory and all the repositories will be in that single folder instead of having several copies for each assignment. You can also enter a unit number as an argument (must be after the -s flag if being used). Otherwise it will prompt you for one when you use the command.
**Example Usages:**

 - ```creator```
 - ```creator -s```
 - ```creator 00```
 - ```creator -s 00```

**The default file structure would look something like this.**
 - unit00
	 - CW
		 - unit00-student1
		 - unit00-student2
	 -  HW1
		 - unit00-student1
		 - unit00-student2
	-  HW2
		 - unit00-student1
		 - unit00-student2
	-  MP
		 - unit00-student1
		 - unit00-student2


## sourcer
This command simplifies set up to use the above commands anywhere. This is done by adding the scripts to the PATH and an environment variable of where the repo_list file is located. Read the set up instructions for more information.
**Users should not use this command directly, unless they want to source this file directly every time they open the terminal to do their job**   
