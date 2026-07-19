---
id: 01HBGN4P98N5ZYWK61V8BMDYRC
created: 2023-09-29T14:23:05Z
updated: 2023-09-29T14:23:05Z
type: memo
title: Install the Velero CLI
---
29-09-2023 10:40

Tags: #velero #kubernetes #backup 


---
# Install the Velero CLI
## Windows
```
chock install velero
```
## Linux

Download the latest release from - https://github.com/vmware-tanzu/velero/releases/latest

Extract the Tarball
```
tar -xvf <RELEASE-TARBALL-NAME>.tar.gz
```
## MacOS
```
brew install velero
```

# Create the Storage Bucket
## Variables
```
BUCKET=<buskct-name>
```
```
REGION=<region-name>
```
## Create bucket
```
aws s3api create-bucket --bucket $BUCKET --region $REGION --create-bucket-configuration LocationConstraint=$REGION
```
# Create a Backup Operator
## Create IAM User
```
aws iam create-user --user-name service-velero
```
## Attach Policies
```
cat > velero-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeVolumes",
                "ec2:DescribeSnapshots",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::${BUCKET}"
            ]
        }
    ]
}
EOF
```

```
aws iam put-user-policy \
  --user-name service-velero \
  --policy-name velero \
  --policy-document file://velero-policy.json
```
## Create Access Key
```
aws iam create-access-key --user-name service-velero
```

## Enter the key details into a file called "credentials-velero"
```
[default]
aws_access_key_id=<AWS_ACCESS_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
```
# Install Velero on Cluster

Ensure you are currently using the correct Kubeconfig

```
velero install \
    --provider aws \
    --plugins velero/velero-plugin-for-aws:v1.8.0 \
    --bucket $BUCKET \
    --backup-location-config region=$REGION \
    --snapshot-location-config region=$REGION \
    --secret-file ./credentials-velero
```



---
## References