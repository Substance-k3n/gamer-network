#!/bin/sh
# Creates $BUCKET on the S3 server at ${S3_ENDPOINT:-http://s3:9000} with
# public reads under avatars/. Safe to run again. Used by compose and CI.
set -eu
endpoint=${S3_ENDPOINT:-http://s3:9000}
aws --endpoint-url "$endpoint" s3api head-bucket --bucket "$BUCKET" 2>/dev/null ||
  aws --endpoint-url "$endpoint" s3 mb "s3://$BUCKET"
aws --endpoint-url "$endpoint" s3api put-bucket-policy --bucket "$BUCKET" --policy "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [{
    \"Effect\": \"Allow\",
    \"Principal\": \"*\",
    \"Action\": \"s3:GetObject\",
    \"Resource\": \"arn:aws:s3:::$BUCKET/avatars/*\"
  }]
}"
