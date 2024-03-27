#!/usr/bin/bash 
# Environment variables to configure the AWS CLI
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="xxx"
export AWS_SESSION_TOKEN="xxx"

set +x
function calcs3bucketsize() {
    sizeInBytes=`aws s3 ls s3://"${1}" --recursive --human-readable --summarize | awk END'{print}'`
    echo ${1},${sizeInBytes} >> allregions-buckets-s3-sizes.csv
    printf "DONE. Size of the bucket ${1}. %s\n " "${sizeInBytes}"  
}
[ -f allregions-buckets-s3-sizes.csv ] && rm -fr allregions-buckets-s3-sizes.csv
buckets=`aws s3 ls | awk '{print $3}'`
i=1
for j in ${buckets}; do
    printf "calculating the size of the bucket[%s]=%s. \n " "${i}" "${j}"   
    i=$((i+1))
    # to expedite the calculation, make the cli commands run parallel in the background
    calcs3bucketsize ${j} &
done