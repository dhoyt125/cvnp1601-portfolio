# Troubleshooting Narractive 


# 1.  
	A fellow trainee ran "grep -i "error" syslog > ~/incident.txt" which returned 215 lines, confirmed the line count with "wc -l". They 
	then ran a second grep for "critical" using the same redirect file, which only returned 3 lines. The trainee 
	explained  that "the log is rotating" and the original 215 lines were gone from the incident.txt file. 
# 2. 
	I looked closly at the commands that were ran in the screenshot by the trainee. I found that both commands 
	were redirecting to the same file using a single ">". ">" rewrites the entire file completely. This would
	explain the the file line count drop from 215 to 3. 
# 3. 
	The root cause of the problem wasnt something to troubleshoot, it was a user error. The fix was for the
	trainee to use ">>" (append) instead of ">" on the second command, so the new data would not overwrite 
	the previous data inside of the file. 
# 4. 
	Two ways of verifying. One is having the trainee run both commands correctly and confirming the end result 
	is 218 (215+3)
	Second, is running "grep -i "error" ~/incident.txt | wc -l" afterward should show 215 lines, confirming the 
	lines were not lost. 
