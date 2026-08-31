# Tech Lead Note 


	I reviewed the core commands for a directory (/etc, /var/log, /tmp, /home, /usr/bin) to understand where 
	config, logs, user data, binaries, and temporary files are stored. A really important command was the grep
	filtered log data, it helped speparate error and warning events from a raw file to make it much more
	manageable to read. Also tested running the find command with and without "2/dev/null". 

	Redeirecting log data with ">" and ">>" and using them correclty can prevent accidental data loss and keep a
	clear record. This reduces guessing durring troubleshooting
