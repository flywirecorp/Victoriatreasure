# Victoria Treasure

![Victoria](imgs/victoria.png)
![Treasure](imgs/Treasure.png)

[![CircleCI](https://circleci.com/gh/peertransfer/Victoriatreasure.svg?style=svg)](https://circleci.com/gh/peertransfer/Victoriatreasure)

Victoria Treasure is an utility for handling secrets in S3 avoiding manual steps for decrypting or encrypt the files.

## Setting up Victoria Treasure

Create a file called `secrets.env` with the following environment variables:

```bash
AWS_DEFAULT_REGION=
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
KMS_KEY_ID=
```

## Usage to update/add a new value

```bash
$ docker build -t victoria_treasure .
# Remember to edit the secrets.env file to add the necessary variables
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

## What's happening behind the scenes

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

## Running the tests

```bash
$ rake
```

## Versioning

In general, Victoria secrets follows [semver](https://semver.org/)

## Authors

* **Super Mega Awesome Flywire SRE Team**
