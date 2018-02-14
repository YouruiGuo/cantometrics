import os

path = os.getcwd()

infile = open("file_list.txt","r")

filelist = []
c1 = 0
c2 = 0

line = infile.readline().strip()
while line != '':
        filelist.append(line.replace("mp3", "wav"))
        c1 += 1
        line = infile.readline().strip()
lack = []
for f in filelist:
        if f not in os.listdir(path):
                lack.append(f)
        else:
                c2 += 1
print(lack,c1,c2)
