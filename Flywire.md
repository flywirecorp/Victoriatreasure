# Victoria Secrets

Victoria Secrets is an utility for handling secrets in S3 avoiding manual steps for decrypting or encrypt the files.


## Getting the secrets.env file

Be sure you've properly installed and configured the [aws-okta](https://confluence.flywire.tech/display/SRE/AWS+programmatic+credentials+via+Okta), so you'll be able to run:

```bash
$ ./get_aws_secrets.sh <your-aws-account-profile>
```

Your AWS account profile names can be found in `~/.aws/config`.

Once you run this command, you'll be able to find a `secrets.env` file in the root path of the repo.

## Usage to update/add a new value

```bash
$ docker build -t victoria_treasure .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env victoria_treasure victoria-playground-secrets/apps/testing-secrets/app.json.encrypted my_secret_key my_value
```

Where:

* `victoria-playground-secrets/apps/testing-secrets/app.json.encrypted`: is the route where the secret file is stored and you want to edit, if you put a file that not exists in the s3, it will create a new one
* `my_secret_key`: is the secret key to be added
* `my_value`: is the value of that key

If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key added to victoria-playground-secrets/apps/testing-secrets/app.json.encrypted
```

### What's happening behind the scenes

* Downloads and decrypt the specified file into memory if it exists, if not, it creates a new file in memory
* Edits the file adding the specified key and value
* Encrypts and upload the changes to S3, replacing the old file


## Usage to get a value

```bash
$ docker build -t victoria_treasure .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env victoria_treasure victoria-playground-secrets/apps/testing-secrets/app.json.encrypted my_secret_key
```

Where:

* `victoria-playground-secrets/apps/testing-secrets/app.json.encrypted`: is the route where the secret file is stored and you want to check, if you put a file that not exists in the s3, the result will be empty
* `my_secret_key`: is the secret key to be read

If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key content is SUPER_SECRET_CONTENT
```

#### secrets.env

Once you run get_aws_secrets it will create secrets.env with the following keys:

```bash
AWS_DEFAULT_REGION=
AWS_REGION=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_OKTA_PROFILE=
AWS_SESSION_TOKEN=
AWS_SECURITY_TOKEN=
```

There is a `KMS_KEY_ID` for each AWS account, for getting the ID of the current account run:

```bash
$ aws kms list-aliases | grep -h1 $ACCOUNT_ALIAS | grep TargetKeyId
```

$ACCOUNT_ALIAS variable can have 3 different values depending where you want to create secret:

* branch: victoria-playground
* staging: victoria-staging
* production: victoria-production

The output will be something like:
```json
"TargetKeyId": "ca242e97-d284-4219-9bce-cea69c618ff8"
```

## Running the tests

```bash
$ rake
```

## Versioning

In general, Victoria Secrets follows [semver](https://semver.org/)

## Authors

* **Super Mega Awesome SRE Team**
