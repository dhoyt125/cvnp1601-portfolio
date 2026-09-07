# Tech Lead Notes


I finished filling out the edited note file with the server's identifying info: 
Server Name: cvnp1601-lab, IP Address: 192.168.13.128, Status: Active, Date: 
9-4-26.

I ran the command to generate ssh access report and the output came back empty. 
Thinking it might have been a fluke, I ran it a second time 
and got the same blank result. That leaves two possibilities as far 
as I can tell — either there genuinely weren't any matching entries in the log, or 
the command wasn't pointed at the right file or pattern to begin with. I'd rather 
flag that uncertainty here than present a blank report.

 The whole reason to check access logs in the first place is 
to catch unusual login behavior early, before it turns into a real breach. A blank 
report is risky precisely because it can look like good news
