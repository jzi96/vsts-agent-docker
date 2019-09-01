#!/bin/bash
set -e

cd "$(dirname $0)"

count=0
start=$(date +%s)

while read dir; do
  echo "Building $dir"
  docker build -q -t janzi/vsts-build-agents:${dir//\//-} $dir
  _=$((count+=1))
done < <(./dirs.sh $1)

LATEST_TAG=$(cat latest.tag)
if [ -n "$(docker images -f reference=janzi/vsts-build-agents:$LATEST_TAG -q)" ]; then
  docker tag janzi/vsts-build-agents:$LATEST_TAG janzi/vsts-build-agents
fi

end=$(date +%s)
((seconds=end-start))

if (( $seconds > 3600 )) ; then
    ((hours=seconds/3600))
    ((minutes=(seconds%3600)/60))
    ((seconds=(seconds%3600)%60))
    echo "Built $count images in $hours hour(s), $minutes minute(s) and $seconds second(s)" 
elif (( $seconds > 60 )) ; then
    ((minutes=(seconds%3600)/60))
    ((seconds=(seconds%3600)%60))
    echo "Built $count images in $minutes minute(s) and $seconds second(s)"
else
    echo "Built $count images in $seconds seconds"
fi