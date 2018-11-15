# s3-json-secrets

s3-json-secrets is an utility for handling secrets in S3 avoiding manual steps for decrypting or encrypt the files.


## Getting the secrets.env file

Be sure you've properly installed and configured the [aws-okta](https://confluence.flywire.tech/display/SRE/AWS+programmatic+credentials+via+Okta), so you'll be able to run:

```bash
$ ./get_aws_secrets.sh <your-aws-account-profile>
```

Your AWS account profile names can be found in `~/.aws/config`.

Once you run this command, you'll be able to find a `secrets.env` file in the root path of the repo. 

## Usage to update/add a new value

```bash
$ docker build -t your_desired_tag .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env your_desired_tag flywire-playground-secrets/apps/testing-secrets/app.json.encrypted my_secret_key my_value
```

Where:

* `playground-secrets/apps/testing-secrets/app.json.encrypted`: is the route where the secret file is stored and you want to edit, if you put a file that not exists in the s3, it will create a new one
* `my_secret_key`: is the secret key to be added
* `my_value`: is the value of that key

If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key added to flywire-playground-secrets/apps/testing-secrets/app.json.encrypted
```


## Usage to get a value

```bash
$ docker build -t your_desired_tag .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env your_desired_tag flywire-playground-secrets/apps/testing-secrets/app.json.encrypted my_secret_key
```

Where:

* `playground-secrets/apps/testing-secrets/app.json.encrypted`: is the route where the secret file is stored and you want to check, if you put a file that not exists in the s3, the result will be empty
* `my_secret_key`: is the secret key to be read


If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key content is SUPER_SECRET_CONTENT
```


#### secrets.env

This file has the following secrets:

```bash
AWS_DEFAULT_REGION=
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
KMS_KEY_ID=
```

There is a `KMS_KEY_ID` for each AWS account, for getting the ID of the current account run:

```bash
$ ACCOUNT_ALIAS=`aws iam list-account-aliases --query 'AccountAliases[0]' --output text`
$ aws kms list-aliases | grep -h1 $ACCOUNT_ALIAS | grep TargetKeyId
```

The output will be something like:
```json
"TargetKeyId": "ca242e97-d284-4219-9bce-cea69c618ff8"
```

### What's happening behind the scenes

* Downloads and decrypt the specified file into memory if it exists, if not, it creates a new file in memory
* Edits the file adding the specified key and value
* Encrypts and upload the changes to S3, replacing the old file

## Running the tests

```bash
$ rake
```

## Versioning

In general, s3-json-secrets follows [semver](https://semver.org/)

## Authors

* **Super Mega Awesome SRE Team**
