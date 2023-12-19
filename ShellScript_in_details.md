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

##### -a array  declare -a indices      The variable indices will be treated as an array.
##### <br>-f function(s)  A declare -f line with no arguments in a script causes a listing of all the functions previously defined in that script.</br>
##### <br>-x export     This declares a variable as available for exporting outside the environment of the script itself.</br>
##### <br>x var=$value The declare command permits assigning a value to a variable in the same statement as setting its properties</br>


function my_func() {
    return 10
}
my_func
echo $?

function add_numbers() {
    local sum=$(( $1 + $2 ))
    return $sum
}




 

