#!/bin/bash

# minio deploy: create access key and secret key, create bucket, webhook event
chmod +x /opt/bin/mc
cd /opt/bin || exit
mc alias set myminio http://127.0.0.1:9002 ROOTNAME CHANGEME123
mc admin user svcacct add --access-key "xFkEokGRxAlwIs4Vw5cO" --secret-key "jaz4FlvCDDKvbBuQYJ9NIohMUlRDsT09F1PZH6KB" myminio ROOTNAME
mc mb myminio/cogent
mc event add myminio/cogent arn:minio:sqs::PRIMARY:webhook --event put
mc event add myminio/cogent arn:minio:sqs::PRIMARY:webhook --event delete