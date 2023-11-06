APPNAME=brunollp-website
ENVIRONMENT=prd

.PHONY: bucket

lint:
	cfn-lint */*-stack.yml


push:
	BUCKET=$$(aws cloudformation list-exports --output text | \
		grep ${APPNAME}-${ENVIRONMENT}-stack | \
		grep ${APPNAME}-${ENVIRONMENT}-stack-WebsiteBucketName | \
		cut -f 4) ; \
	echo $${BUCKET}

## aws s3 cp ./ s3://$${BUCKET}/ --recursive --exclude 'node_modules/*' --exclude '.git/*' --exclude '*.DS_Store*'

deploy:
	aws cloudformation deploy \
		--template-file *-stack.yml \
		--no-fail-on-empty-changeset \
		--capabilities CAPABILITY_IAM \
		--parameter-overrides AppName=${APPNAME} Environment=${ENVIRONMENT} \
		--stack-name ${APPNAME}-${ENVIRONMENT}-stack