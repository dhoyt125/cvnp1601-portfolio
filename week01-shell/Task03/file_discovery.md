# File Discovery with find


## With /dev/null 
![01](SCs/t3-01)




## Without /dev/null
![02](SCs/t3-02)



## Explanation 

We use "find" search to not waste time adn cuase mistakes. Linux has two different output streams "stdout" and "stderr".
stdout being normal messages and stderr being error messages. Error messages does always mean its a bad thing, sometimes
the system is protecting sensitive paths. To save time and we sometime redirect stderr(error messages) to a virtual trash can
using "/dev/null"


