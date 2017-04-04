import sys

f = open('con_numbers.txt', 'w')
for i in range(int(sys.argv[1])):
    f.write(str(i+1)+'\n')
f.close()
