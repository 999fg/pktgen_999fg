#! /bin/bash

echo "docker stress test!!"
for con in `docker ps -a -q`
do
docker stop $con
docker rm $con
done
echo "How many containers?"
read input
`python numbermaker.py $input`
for n in `cat con_numbers.txt`
do
    echo "making container$n"
    docker run -dti --name con$n ubuntu:14.04
done
    
