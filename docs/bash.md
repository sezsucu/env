## [Awesome Bash](https://github.com/awesome-lists/awesome-bash)
A curated list of bash scripts and resources

## Reminders
* `type`: builtin command
* `which`: to find which command would be executed
* `man`: to view the manual for a command
* `help`: to view the help page for builtin commands (e.g. help type)
* `file`: determine file type
* `stat`: display file status
* `echo`: print to standard output
* `printf`: print formatted strings to standard output
* `cat`: output contents of a file
* `sort`: to sort a file
* `uniq`: to remove adjacent duplicate lines from a file
* `tee`: to copy input into both standard output and a given file
* `tr`: translate characters
* `wc`: word, line, character count
* `grep`: to find text in files
* `zgrep`: to find text in compressed files
* `zcat`: like cat, but for compressed files
* `awk`: a great utility to process text files and extract columns
* `time`: to time commands
* `kill`: to kill a job with pid or job number
* `trap`: to trap a signal
* `date`: to show current time and date 
* `diff`: to compare two files
* `ln`: to make symbolic links
* `xargs`: to construct argument list and execute utility

## Minor Things To Remember
* To avoid alias
 ```bash
 \ls -l
```

* Use single quote to avoid shell expansion and substitution
```bash
echo 'Hello, the item is 10$!'
```

* To direct error output to a specific file
```bash
program 2> /dev/null
```

* To direct both output and error to the same file
```bash
program >& all.txt
```

* To redirect error output to standard output target
```bash
program ... 2>&1
```

* To append output
```bash
echo "Blah Blah Blah" >> appended.txt
```

* Show last 5 lines of a file
```bash
tail -5 file.txt
```

* Continuously see the last lines of a log file
```bash
tail -f logFile.txt
```

* Skip the first 5 lines of a file
```bash
tail -n +5 file.txt
```

* To group commands and direct their output all at once
```bash
{ program1; program2; program3; } > file.txt
```

* To run commands in a subshell and direct their output all at once
```bash
( program1; program2; program3 ) > file.txt
```

* To rm all class files under the current directory
```bash
\rm -f $(find . -name '*.class')
```

* To forward error to a particular file
```bash
gcc *.cc 2> errors.txt
```
To also view the errors on screen
```bash
gcc *.cc 2>&1 | tee errors.txt
```

* To swap STDERR and STDOUT
```bash
program 3>&1 1>stdout.txt 2>&3- | tee -a stderr.txt
```

* To ignore noclobber set
```bash
echo something >| output.txt
```

* Here documents in shell script with indentation
```bash
read -r -d '' varName <<'EOF'
name1 value1
name2 value2
name3 value3
name4 value4
name5 value5
name6 value6
EOF
export varName
EOF
```

* Read user input with 3 seconds timeout
```bash
read -t 3 -p "How old are you? " YEAR
echo "You are $YEAR years old"
```

* Select an option from a list of options
```bash
optionList="done a b c"
selectedOption=""
until [ "$selectedOption" == "done" ]; do
    echo "Select an option "
    select selectedOption in $optionList; do
        if [ -z "$selectedOption" ]; then
            echo "Invalid selection"
        elif [ "$selectedOption" == "done" ]; then
            break
        elif [ -n "$selectedOption" ]; then
            echo "You chose $REPLY, doing $selectedOption..."
            break
        else
            echo "Invalid selection"
        fi
    done
done
```

* Reading password
```bash
read -s -p "password: " PASSWD
printf "%b" "\n"
```

* Get the choice of a user
```bash
function getChoice
{
    CHOICE=''
    local prompt="$*"
    local response
    
    read -p "$prompt" response
    case "$response" in
        [yY] ) CHOICE='y';;
        [nN] ) CHOICE='n';;
        *    ) CHOICE="$response";;
    esac
}

CHOICE=''
getChoice "Wanna continue? [y/n]"
echo $CHOICE
```

* Run multiple programs
```bash
# unconditional, doesn't matter if previous command runs or not
first ; second ; third
# conditional, run the next one only if the previous command is successfully run
first && second && third
# unconditional, run in parallel
first & second & third 
```

* Examine the exit status of a command
```bash
ls thisFileDoesNotExist
# ls: thisFileDoesNotExist: No such file or directory
echo $?
# 1
```

* Conditional running of another command
```bash
command1
if (( $? == 0 )); then
    command2
fi
```
or
```bash
if command1; then
    command2
fi
```

* To run a job even after shell exit
```bash
nohup command &
```

* To print an error message and exit upon failure of a command
```bash
command || { echo "FAILED command" ; exit 1 ; }
```

* To process all files in a given directory
```bash
for FILE in /path/to/dir/*
do
    if [ -f "$FILE" -a -x "$FILE" ]; then
        $FILE
    fi
done
```

* To separate a variable from surrounding text
```bash
for FN in 1 2 3 4 5
do
    echo "Step${FN})..."
done
```

* Called scripts can not change the exported variables. The caller has to read
the value back from the output of the called script and assign it to the value.

* To see all set variables in the environment
```bash
set
```

* To see all exported variables in the environment
```bash
env
```

* To process all arguments passed in a function or script
```bash
for argV in $*
do
    echo "Processing $argV"
done
```

* To process arguments that contain whitespace
```bash
for argV in "$@"
do
    echo "Processing $argV"
done
```

* To get the number of arguments
```bash
echo "You passed $# arguments"
if (( $# < 3 )); then
    echo "3 arguments are required"
fi
```

* To get default values
```bash
TMPDIR=${1:-/tmp}
```

* To assign a default value, if the variable is not set before or is empty
```bash
cd ${TMPDIR:=/tmp}
```

* To assign a default value (including empty), if the variable is not set before
```bash
cd ${TMPDIR=/tmp}
```
In this case, empty string is valid and /tmp won't be assigned if TMPDIR is set to an empty string.

* To assign a more complex value
```bash
cd ${TMPDIR:="$(tmpDirGetCommand)"}
```
You can run commands and assign their results to your variable. In general you can assign
to other variables, tilde expansion (e.g. `~userName`), command substitution, and arithmetic expansion (e.g. `$((number+1))`)

* To give an error for a missing argument
```bash
DIR=${1:?"Error! You must provide a directory"}
# same as 
if [ -z "$1" ]; then
    echo "Error! You must provide a directory"
    exit 1
fi
```

* String operators
```bash
# substring of str starting at 0 length of 10
${str:0:10} 
# length of str
#str  
# replace first occurrence of pattern
str/pattern/replacement
# replace all occurrences of pattern
str//pattern/replacement
```

* To get file name or directory name of a path
```bash
pathName="/tmp/blah/doo/foo"
dir="$( dirname "$pathName" )"
fileName="$( basename "$pathName" )" 
```

* To build a comma separated list of values
```bash
newItem=''
while read newItem; do
    commaSeparatedList="${commaSeparatedList}${commaSeparatedList:+,}${newItem}"
done
```

* Arrays
```bash
myArray=(first second third)
echo 1st ${myArray[0]}, 2nd ${myArray[1]}, 3rd ${myArray[2]}
```

* Arithmetic
```bash
MAX=3
C=2
C=$((C + (5 * MAX)))
echo $C
# or
C=2
let C+='5 * MAX'
echo $C
```

* Arithmetic comparison
```bash
C=17
if [ $C -lt 30 ]; then
    echo "Less than 30"
fi
if (( $C < 30 )); then
    echo "Less than 30"
fi
```

* File operators
```bash
if [ $file1 -nt $file2 ]; then
    echo "file1 is newer than file2"
fi 
if [ $file1 -ot $file2 ]; then
    echo "file1 is older than file2"
fi 
if [ -d "$file1" ]; then
    echo "file1 is a directory"
fi 
if [ -e "$file1" ]; then
    echo "file1 exists"
fi 
if [ -f "$file1" ]; then
    echo "file1 is a regular file"
fi 
if [ -r "$file1" ]; then
    echo "file1 is readable"
fi 
if [ -x "$file1" ]; then
    echo "file1 is executable"
fi 
if [ -w "$file1" ]; then
    echo "file1 is writable"
fi 
if [ -s "$file1" ]; then
    echo "file1 has at least one byte"
fi 
```

* Logical operators
```bash
if [ -r $file1 -a -w $file1 ]; then
    echo "both readable and writable";
fi
if [ -r $file1 -o -w $file1 ]; then
    echo "readable or writable";
fi
```

* String tests
```bash
if [ -n "$strVar" ]; then
    echo "strVar has text"
fi
if [ -z "$strVar" ]; then
    echo "strVar is zero length or not assigned"
fi
```

* Numeric tests
```bash
if [ "$var1" -eq "$var2" ]; then
    echo "var1 == var2 "
fi
if [ "$var1" -ne "$var2" ]; then
    echo "var1 != var2 "
fi
if [ "$var1" -lt "$var2" ]; then
    echo "var1 < var2 "
fi
if [ "$var1" -le "$var2" ]; then
    echo "var1 <= var2 "
fi
if [ "$var1" -gt "$var2" ]; then
    echo "var1 > var2 "
fi
if [ "$var1" -ge "$var2" ]; then
    echo "var1 >= var2 "
fi
```

* Pattern matching
```bash
if [[ "${fileName} == *.jpg ]]; then
    echo "ends with .jpg"
fi
fileName="a.tgz"
if [[ "$fileName" =~ tgz$ ]]; then
    echo "ends with tgz"
fi
```

* Looping with a counter
```bash
for (( i=0 ; i < 10 ; i++ )); do
    echo $i
done
```

* Multi-branching 
```bash
case $1 in
    *.txt) echo "text file"
        ;;
    *.gif | *.png | *.jpg) echo "image file"
        ;;
    *) echo "whatever"
        ;;
esac
```

* Basic argument processing
```bash
# program [-c char] [length] 
col=72
charValue='-'
while (( $# > 0 )); do
    case $1 in
        [0-9]*) col=$1
            ;;
        -c) shift; charValue=${1:--}
            ;;
        *) echo "Error";
            exit 1
            ;;
    esac
    shift
done
```

* Grep options
```bash
# case insensitive search
grep -i caseinsensitive *
# just show the number of times it was found in a file
grep -c searchedText *
# show lines that don't contain the given text
grep -v unwantedText *
# search for a regex
grep '[0-9]\{7\}' phones.txt
# search compressed files
zgrep searchedText * 
```

* awk options
```bash
# print first word
awk '{print $1}' < input

# to print first and last word in a line
awk '{print $1, $NF}' < input

# to reverse all words in a line
awk '{for (i=NF; i>0; i--) {printf "%s ", $i;} printf "\n" }' < input

# to process an awk script
awk -f script.awk < input
```

* awk script to count occurrence of the second word
```
NF > 1 {
    words[$1]++
}
END {
    for (i in words) {
        printf "%s occurs %d times\n", i, words[i]
    }
}
```

* Sort in reverse order
```bash
sort -r input.txt
```

* Sort ignoring the case
```bash
sort -f input.txt
```

* sort numeric data
```bash
sort -n numbers.txt
```

* Find all shells used in a system
```bash
cat /etc/passwd | grep -v ^# | cut -d':' -f7 | sort | uniq -c  | sort -rn
```

`grep -v` used to remove comments, lines that start with #. `cut` is used to 
select the 7th field, using ':' as a delimiter. Finally `uniq -c` is used
to count each unique sorted value.

* To sort ip addresses
```bash
sort -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 ips.txt
```

* Remove duplicate lines
```bash
sort -u input.txt > noDuplicates.txt
# or 
sort input.txt | uniq > noDuplicates.txt

```

* Select a particular field from ps
```bash
# tr is used to collapse multiple spaces into a single space
ps -l | tr -s ' ' | cut -f 3 -d ' ' 
# or easier to do with awk
ps -l | awk '{print $3}'
```

* Convert DOS text files to UNIX files
```bash
tr -d '\r' < input.dos > output.unix
```

* Counting lines, words and characters
```bash
# lines
wc -l input.txt
# words
wc -w input.txt
# characters
wc -c input.txt
```

* Pretty format mangled text
```bash
fmt goal maximum many_text.txt
```

* Configure less with options
```bash
# show line numbers -N
# ignore case -i 
# prevent clearing the screen when exiting less -X
# supress all noises -Q 
export LESS="-N -i -X -Q"
```

* Commands with less
    - one window forward: `f`
    - Type `100` followed by `z` to change the window size (applies to `f` and `b`)
    - one window backward: `b`
    - Type `100` followed by `w` to change the window size (applies to `f` and `b`)
    - one line forward: `e` or `j`
    - one line backward: `y`
    - Type `100` followed by `d` to move forward 100 lines and 100 lines every time `d` is presed
    - To refresh the file: `r` or `R`
    - To go to beginning: `g`
    - To go to end: `G`
    - To mark a position: `m` + a lower case letter
    - To go to a previously marked position: `'` + the lower case letter
    - Move to a specific position by percentage: Enter a number followed by `p` or `%`
    - Search for text: `/` + type searched text
    - Search backwards for text: `?` + type searched text
    - To load a new file: `:e newFile.txt`
    - To exit: `q` or `Q`
    

* To process paths in PATH
```bash
for path in ${PATH//:/ }; do
    echo $path
    # if [ -x "$path/command" ]; then ...
done
```

* To include other script files
```bash
. "/path/to/other/source.sh"
# or
source "/path/to/other/source.sh" 
```

* To daemonize a script
```bash
nohup daeomonscript.sh <0&-1>/dev/null 2>&1 &
# or
nohup daeomonscript.sh >>/path/to/daeomonscript.log 2>&1 <&-  &
```

* To return va value from a function
```bash
function min()
{
    if [ $1 -lt $2 ]; then
        echo $1
    else
        echo $2
}

ONE=$(min 1 10)
echo $ONE
```

* To trap a signal
```bash
trap ' echo "Received a signal: $?" ' EXIT HUP INT QUIT TERM
sleep 120
```

* To list all signals that can be trapped or killed
```bash
trap -l
kill -l
```

* To call a function when trapping a signal. Notice that you can never trap SIGKILL.
```bash
function trappedOne
{
    if [ "$1" = "USR2" ]; then
        echo "Bye!"
        exit 0
    else
        echo "Not that easy with $1 signal"
    fi
}

trap "trappedOne ABRT" ABRT
trap "trappedOne EXIT" EXIT
trap "trappedOne HUP"  HUP
trap "trappedOne INT"  INT
trap "trappedOne TERM" TERM
trap "trappedOne USR1" USR1   
trap "trappedOne USR2" USR2


while (( 1 )); do
    :  # just wait
done
```

To kill a running script written as above 
```bash
jobs
# find the job number, say it is 1
kill -TERM %1
# Not that easy with TERM signal
kill -USR1 %1
# Not that easy with USR1 signal
kill -USR2 %2
# Bye
# Not that easy with EXIT signal
```

* To remove an alias
```bash
\rm *.class
``` 

* To time a command
```bash
time commandName
```

* To format dates
```bash
ISO_8601='%Y-%m-%dT%H:%M:%S%z'
ISO_8601_ALT='%Y-%m-%d %H:%M:%S %Z'
FILENAME_DATE='%Y%m%d%H%M%S'

date "+$ISO_8601"
date "+$ISO_8601"
mv log.file.log "log.file.$(date +$FILENAME_DATE).log"
```

* Get the epoch seconds of now
```bash
date '+%s'
# Epoch seconds are the number of seconds since midnight on January 1, 1970

```

* To create a symbolic link
```bash
ln -s /path/to/source.file /path/to/symbolick.link.file
```

* To get the process id
```bash
echo $$
```

* Numeric tests in if expressions
```bash
if (( number < (1024*1024) )); then
    echo "$number is less than 102323"
fi

if [[ $number -lt 1048576 ]]; then
    echo "$number is less than 102323"
fi
```

* To pipe output of find to ls


But this won't work really well with file names that include whitespace. 
In order to solve that you need to change the delimiter used by xargs, but
that won't work on Mac Os X, where the only alternative is to set the delimiter
to '\0' character using `-0` option, and consequently you need to modify the find command to print '\0'
using `-print0`. In Linux, it is much easier using `-d '\n'` command option.
```bash
# on mac os x
find . -name *\.MOV* -print0 | xargs -0 ls -lh

# on linux
find . -name *\.MOV* | xargs -d '\n' ls -lh
```