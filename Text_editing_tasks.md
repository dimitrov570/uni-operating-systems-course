# Text editing tasks

### -- 03-a-2110 
##### Отпечатайте втората колона на /etc/passwd, разделена спрямо символ '/'.
```bash
cut -d '/' -f2 < /etc/passwd
```

### -- 03-a-3000
##### Запаметете във файл в своята home директория резултатът от командата ls -l изпълнена за вашата home директорията.
##### Сортирайте създадения файла по второ поле (numeric, alphabetically).
```
ls -l > 03-a-3000.txt; sort (-n)-k2 < 03-a-3000.txt
```

### -- 03-a-5000
##### Отпечатайте 2 реда над вашия ред в /etc/passwd и 3 реда под него // може да стане и без пайпове
```
grep -A 3 -B 2 "$(whoami)" /etc/passwd
```

### -- 03-a-5001
##### Колко хора не се казват "human" според /etc/passwd
```
grep -v 'human' /etc/passwd | wc -l
```

### -- 03-a-5002
##### Изведете имената на хората с второ име по-дълго от 7 (>7) символа според /etc/passwd
```
grep -E "([^:]+:){4}[^[:space:]]+ [^[:space:],:]{7,}[,: ].*" /etc/passwd | cut -d ':' -f5 | cut -d ',' -f1
```

### -- 03-a-5003
##### Изведете имената на хората с второ име по-късо от 8 (<=7) символа според /etc/passwd // !(>7) = ?
```
grep -E "([^:]+:){4}[^[:space:]]+ [^[:space:]]{,7}[,: ].*" /etc/passwd | cut -d ':' -f5 | cut -d ',' -f1
```

### -- 03-a-5004
##### Изведете целите редове от /etc/passwd за хората от 03-a-5003
```
grep -E "([^:]+:){4}[^[:space:]]+ [^[:space:]]{,7}[,: ].*"
```

### -- 03-b-3000
##### Запазете само потребителските имена от /etc/passwd във файл users във вашата home директория.
```
cut -d ':' -f5 passwd-symlink | cut -d ',' -f1 > users.txt
```

### -- 03-b-3400
##### Колко коментара има във файла /etc/services ? Коментарите се маркират със символа #, след който всеки символ на реда се счита за коментар.
```
grep "#" /etc/services | wc -l
```

### -- 03-b-3450
##### Вижте man 5 services. Напишете команда, която ви дава името на протокол с порт естествено число N. Командата да не отпечатва нищо, ако търсения порт не съществува (например при порт 1337). Примерно, ако номера на порта N е 69, командата трябва да отпечати tftp.
```
egrep "[[:space:]]5269/(tcp|udp)" /etc/services | cut -f1 | head -n 1   (head because it can be tcp and udp)
```

### -- 03-b-3500
##### Колко файлове в /bin са shell script? (Колко файлове в дадена директория са ASCII text?)
```
find /bin/ -type f | xargs file | grep "shell script" | wc -l
find /bin/ -type f | xargs file | grep "ASCII text$"
```
### -- 03-b-3600
##### Направете списък с директориите на вашата файлова система, до които нямате достъп. Понеже файловата система може да е много голяма, търсете до 3 нива на дълбочина. А до кои директории имате достъп? Колко на брой са директориите, до които нямате достъп?
```
find / -maxdepth 3 -type f 2> no-perm.txt > perm.txt; wc no-perm.txt perm.txt 
```
### -- 03-b-4000
Създайте следната файлова йерархия.
/home/s...../dir1/file1
/home/s...../dir1/file2
/home/s...../dir1/file3
```
mkdir dir1; touch ~/dir1/file{1..3}
```

Посредством vi въведете следното съдържание:
```
file1:
1
2
3

file2:
s
a
d
f

file3:
3
2
1
45
42
14
1
52
```
Изведете на екрана:
* статистика за броя редове, думи и символи за всеки един файл
* статистика за броя редове и символи за всички файлове
* общия брой редове на трите файла

### -- 03-b-4001
##### Във file2 подменете всички малки букви с главни.
```
sed -i 'y/asdf/ASDF/' file2
```

### -- 03-b-4002
##### Във file3 изтрийте всички "1"-ци.
```
sed 's/1//g' file3
```

### -- 03-b-4003
##### Изведете статистика за най-често срещаните символи в трите файла.
```
sed -E 's/(.)/\1\n/g' file* | sed '/^$/d' | sort | uniq -c
```

### -- 03-b-4004
##### Направете нов файл с име по ваш избор, който е конкатенация от file{1,2,3}.
###### Забележка: съществува решение с едно извикване на определена програма - опитайте да решите задачата чрез него.
```
cat file{1..3} > file4
```

### -- 03-b-4005
##### Прочетете текстов файл file1 и направете всички главни букви малки като запишете резултата във file2.
```
cat file1 | tr [A-Z] [a-z] > file2
```

### -- 03-b-5200
##### Изтрийте всички срещания на буквата 'a' (lower case) в /etc/passwd и намерете броят на оставащите символи.
```
sed 's/a//g' /etc/passwd | wc -m
```

### -- 03-b-5300
##### Намерете броя на уникалните символи, използвани в имената на потребителите от /etc/passwd.
```
cut -d ':' -f 5 /etc/passwd | cut -d ',' -f 1 | sed -E 's/(.)/\1\n/g' | sed '/^[[:space:]]*$/d' | sort | uniq -c | grep -E '[[:space:]]1[[:space:]]' | wc -l
```

### -- 03-b-5400
##### Отпечатайте всички редове на файла /etc/passwd, които не съдържат символния низ 'ov'.
```
grep -v 'ov' /etc/passwd
```

### -- 03-b-6100
##### Отпечатайте последната цифра на UID на всички редове между 28-ми и 46-ред в /etc/passwd.
```
cut -d ':' -f 3 /etc/passwd | sed -n '28,46p' | grep -o '.$'
```

### -- 03-b-6700
##### Отпечатайте правата (permissions) и имената на всички файлове, до които имате read достъп, намиращи се в директорията /tmp.
```
find /tmp -type f -perm /u+r -printf "%M %f\n" 2> /dev/null
```

### -- 03-b-6900
##### Намерете имената на 10-те файла във вашата home директория, чието съдържание е редактирано най-скоро. На първо място трябва да бъде най-скоро редактираният файл. Намерете 10-те най-скоро достъпени файлове. (hint: Unix time)
```
find . -type f -printf "%T@ %f\n" | sort -n | tail
find . -type f -printf "%A@ %f\n" | sort -n | tail
```

### -- 03-b-7000
##### Файловете, които съдържат C код, завършват на `.c`.
##### Колко на брой са те във файловата система (или в избрана директория)?
##### Колко реда C код има в тези файлове?
```
find / -regex '.*\.c$' 2> /dev/null | wc -l
```

### -- 03-b-7500
##### Даден ви е ASCII текстов файл (например /etc/services). Отпечатайте хистограма на N-те (например 10) най-често срещани думи.
```
grep -Eo '[[:alpha:]]+' /etc/services | tr [A-Z] [a-z] | sort | uniq -c| sort -nr | head
```

### -- 03-b-8500
##### За всеки логнат потребител изпишете "Hello, потребител", като ако това е вашият потребител, напишете "Hello, потребител - this is me!".

Пример:
```
hello, human - this is me!
Hello, s63465
Hello, s64898
```


```
cat names.txt | awk -v usr=$(whoami) '{printf "Hello, %s", $1; if($1==usr){printf " - this is me"}; printf "\n" }'
```

### -- 03-b-8520
##### Изпишете имената на potrebitelite от /etc/passwd с главни букви.
```
awk -F: '$5 ~ /[a-zA-Z0-9]+/{print toupper($5)}' /etc/passwd
```

### -- 03-b-8600
##### Shell Script-овете са файлове, които по конвенция имат разширение .sh. Всеки такъв файл започва с "#!<interpreter>" , където <interpreter> указва на операционната система какъв интерпретатор да пусне (пр: "#!/bin/bash", "#!/usr/bin/python3 -u"). 

##### Намерете всички .sh файлове и проверете кой е най-често използваният интерпретатор.
```
find / -type f -regex '.*\.sh' 2> /dev/null | xargs sed -n '/^#!/p' | sed 's/[[:space:]]//' | sort | uniq -c | sort -nr
```

### -- 03-b-8700
##### Намерете 5-те най-големи групи подредени по броя на потребителите в тях.
```
cat /etc/passwd | cut -d ':' -f4 | sort -nr | uniq -c | head -n 5 | sed -E "s/[[:space:]]*[[:digit:]]*[[:space:]]*([[:digit:]]+)/\1/"
```

### -- 03-b-9000
##### Направете файл eternity. Намерете всички файлове, които са били модифицирани в последните 15мин (по възможност изключете .).  Запишете във eternity името на файла и часa на последната промяна.
```
find / -mmin 15 -printf "%T+ %p\n" 2> /dev/null > eternity
```

### -- 03-b-9051
##### Използвайки файл population.csv, намерете колко е общото население на света през 2008 година. А през 2016?
```
grep -E ',2008,' population.csv | awk -F ',' 'BEGIN{result=0} {result+=$NF} END{print result}'
grep -E ',2006,' population.csv | awk -F ',' 'BEGIN{result=0} {result+=$NF} END{print result}'
(NF used, because there are names that include “,”, so $4 is not population number in these cases)
```

### -- 03-b-9052
##### Използвайки файл population.csv, намерете през коя година в България има най-много население.
```
grep 'Bulgaria' population.csv | sort -nr -t ',' -k4 | head -1 | cut -d ',' -f3
```

### -- 03-b-9053
##### Използвайки файл population.csv, намерете коя държава има най-много население през 2016. А коя е с най-малко население?
###### (Hint: Погледнете имената на държавите)
```
grep -E ',2016,' population.csv | awk -F ',' '{printf "%s / %s\n", $1,$NF}' | sort -n -t '/' -k2 | tail -1
grep -E ',2016,' population.csv | awk -F ',' '{printf "%s / %s\n", $1,$NF}' | sort -n -t '/' -k2 | head -1
```

### -- 03-b-9054
##### Използвайки файл population.csv, намерете коя държава е на 42-ро място по население през 1969. Колко е населението й през тази година?
```
grep -E ',1969,' population.csv | awk -F ',' '{printf "%s / %s\n", $1,$NF}' | sort -nr -t '/' -k2 | sed -n '42p'
```

### -- 03-b-9100	
##### В home директорията си изпълнете командата `curl -o songs.tar.gz "http://fangorn.uni-sofia.bg/misc/songs.tar.gz"`

### -- 03-b-9101
##### Да се разархивира архивът songs.tar.gz в папка songs във вашата home директорията.
```
mkdir songs; cp songs.tar songs; gunzip songs.tar.gz; tar -xf songs.tar
```

### -- 03-b-9102
##### Да се изведат само имената на песните.
```
ls | sed -E 's/[[:alpha:][:space:]]+-[[:space:]]*([[:alpha:][:space:]]+)\(.*/\1/'
```

### -- 03-b-9103
##### Имената на песните да се направят с малки букви, да се заменят спейсовете с долни черти и да се сортират.
```
ls | sed -E 's/[[:alpha:][:space:]]+-[[:space:]]*([[:alpha:][:space:]]+)[[:space:]]+\(.*/\1/' | awk '{print tolower($0)}' | tr ' ' '_' | sort
```

### -- 03-b-9104
##### Да се изведат всички албуми, сортирани по година.

### -- 03-b-9105
##### Да се преброят/изведат само песните на Beatles и Pink.


### -- 03-b-9106
##### Да се направят директории с имената на уникалните групи. За улеснение, имената от две думи да се напишат слято:
##### Beatles, PinkFloyd, Madness
```
mkdir $(ls | grep -Eo "[[:alpha:][:space:]]+-" | cut -d '-' -f1 | sed -E 's/[[:space:]]//' | sort | uniq)
```

### -- 03-b-9200
##### Напишете серия от команди, които извеждат детайли за файловете и директориите в текущата директория, които имат същите права за достъп както най-големият файл в /etc директорията.
```
find . -perm $(find /etc -type f -printf "%k\t%m\n" 2> /dev/null | sort -n | tail -1 | cut -f2) -exec ls -l {} \;
```

### -- 03-b-9300

##### Дадени са ви 2 списъка с email адреси - първият има 12 валидни адреса, а вторията има само невалидни. Филтрирайте всички адреси, така че да останат само валидните. Колко кратък регулярен израз можете да направите за целта?

###### Валидни email адреси (12 на брой):
```
email@example.com
firstname.lastname@example.com
email@subdomain.example.com
email@123.123.123.123
1234567890@example.com
email@example-one.com
_______@example.com
email@example.name
email@example.museum
email@example.co.jp
firstname-lastname@example.com
unusually.long.long.name@example.com
```

###### Невалидни email адреси:
```
#@%^%#$@#$@#.com
@example.com
myemail
Joe Smith <email@example.com>
email.example.com
email@example@example.com
.email@example.com
email.@example.com
email..email@example.com
email@-example.com
email@example..com
Abc..123@example.com
(),:;<>[\]@example.com
just"not"right@example.com
this\ is"really"not\allowed@example.com
```
```
grep -E '^[[:lower:][:digit:]_-]+(\.[[:lower:][:digit:]_-]+)*@[[:lower:][:digit:]]+([-.][[:lower:][:digit:]]+)+$ file.txt
```

### -- 03-b-9500
##### Запишете във файл next потребителското име на човека, който е след вас в изхода на who. Намерете в /etc/passwd допълнителната ифнромация (име, специалност...) и също го запишете във файла next. Използвайки файла, изпратете му съобщение "I know who you are, информацията за студента"
```
who | cut -d ' ' -f1 | grep -A 1 "$(whoami)" | tail -1 > next;
cat /etc/passwd | grep "$(cat next)";
```

