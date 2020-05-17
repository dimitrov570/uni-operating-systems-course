#!/bin/bash

cat <<- _EOF_
<table>
  <tr>
    <th>Username</th>
    <th>group</th>
    <th>login shell</th>
    <th>GECKO</th>
  </tr>
_EOF_

while IFS=':' read username group gecko login_shell; do
cat	<<- _EOF_
<table>
  <tr>
    <th>"${username}"</th>
    <th>"${group}"</th>
    <th>"${login_shell}"</th>
    <th>"${gecko}"</th>
  </tr>
_EOF_
done < <(cut -d ':' -f 1,4,5,7 /etc/passwd)

echo "</table>";

