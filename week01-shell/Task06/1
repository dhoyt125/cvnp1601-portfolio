# 1. State
	Every command the fellow trainee used worked as intended.
# 2. Root Cause
	The reason for the missing lines is, the wrong command being ran for the critical search. The trainee should have used ">>" instead of ">" when adding to the preexisting incident.txt file.
# 3. Remediation 
	The command the fellow trainee should have ran is (assuming they are starting over...), 
	"grep" -i "critical" syslog >> ~/incident.txt"  after they already ran the "error" search. 
# 4. Verification  	
	2 ways of verifying the fix, first the trainee can run this command - "wc -l ~/incident.txt" and 
	verify if it shows 218 lines. Second, the trainee can check agiasnt the "incident.txt" file by
	running these commands - "grep -c -i "error" ~/incident.txt" and "grep -c -i "critical" ~/incident.txt" 
	and confirm they return 215 and 3.  
