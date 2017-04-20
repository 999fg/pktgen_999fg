#! /bin/bash

echo "docker stress test!!"
docker ps -a | grep con | awk '{ print $1}' | xargs docker rm -f $1
echo "How many containers?"
read input
`python numbermaker.py $input`
for n in `cat con_numbers.txt`
do
    echo "making container$n"
    docker run -dti --net=mynet --name con$n ubuntu:14.04
    #docker run -dti --name con$n ubuntu:14.04
done
    
