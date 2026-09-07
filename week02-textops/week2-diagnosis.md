

# 1. 
	The trainee's commands ran successfully and were able to produce and 
confirm 40 lines. Except for the uniq -c command, which didn't group the three 
10.0.0.5 addresses together.

# 2. 
	Uniq counted them as different values instead of the same, because 
they weren't right next to one another in the file. So uniq reads them as separate 
values even though they're identical.

# 3. 
	A sort command needed to be added before uniq so matching addresses 
end up grouped together and get counted properly.

# 4. 
	Using "sort src-ips.txt | uniq -c | grep 10.0.0.5" or "grep "10.0.0.5" src-ips.txt | wc -l" confirms that an address we know appears 
multiple times gets counted together, instead of still showing up as separate lines.



# 5. 
	 If this count goes to the security team without being verified, an 
address like 10.0.0.5 that actually shows up several times could get split into 
multiple "count of 1" lines instead of one accurate total. That makes a real 
pattern of repeated access attempts look spread out and harmless, when it's 
actually the same source hitting the system over and over.
