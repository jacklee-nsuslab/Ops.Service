#!/bin/sh

while getopts g:p:f: option
do
    case "${option}"
    in
	g) SECURITY_GROUP=${OPTARG};;
    p) PORT=${OPTARG};;
	f) LIST_FILE=${OPTARG};;
    esac
done

if [ -z ${SECURITY_GROUP} ]
then
    echo "Security group name is required. [-g sg-0f6273074f1b5db0f]"
    exit 1
fi

if [ -z ${PORT} ]
then
    echo "Port number is required. [-p 443]"
    exit 1
fi

set -o xtrace
while read -r line; do
    aws ec2 authorize-security-group-ingress --group-id ${SECURITY_GROUP} --protocol tcp --port ${PORT} --cidr ${line}
done < "${LIST_FILE:-/dev/stdin}"
set +o xtrace
