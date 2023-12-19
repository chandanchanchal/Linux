## Internal Variables
### The path to the Bash binary itself
bash$ echo $BASH<br>/bin/bash</br>
<br>$BASH_ENV</br>

### Process ID of the current instance of Bash
<br>$BASHPID</br>

## Typing variables: declare or typeset
declare -r var1=1
<br>echo "var1 = $var1"</br>

### -i integer
declare -i number
#### The script will treat subsequent occurrences of "number" as an integer.		

number=3
echo "Number = $number"     # Number = 3

number=three
echo "Number = $number"     # Number = 0
##### Tries to evaluate the string "three" as an integer.

 

