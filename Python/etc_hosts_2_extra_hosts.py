repr
'''
usage:

echo '
1.1.1.1 xx.com yy.com
2.2.2.2 aa.com bb.com
' | python etc_hosts_2_extra_hosts.py
'''


import sys
for line in sys.stdin.readlines():
    items = line.split(' ')
    if len(items) >=2:
        head = items[0]
        for item in items[1:]:
            item = item.strip()
            if len(item) > 0:
              print(item + ': ' + head)