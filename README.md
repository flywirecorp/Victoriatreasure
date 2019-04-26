# Victoria Secrets

![Victoria](imgs/victoria.png)
![Secrets](imgs/secrets.gif)

[![CircleCI](https://circleci.com/gh/peertransfer/VictoriaSecrets.svg?style=svg)](https://circleci.com/gh/peertransfer/VictoriaSecrets)

Victoria Secrets is an utility for handling secrets in S3 avoiding manual steps for decrypting or encrypt the files.

## What's happening behind the scenes

* Downloads and decrypt the specified file into memory if it exists, if not, it creates a new file in memory
* Edits the file adding the specified key and value
* Encrypts and upload the changes to S3, replacing the old file

## Setting up Victoria Secrets

Create a file called `secrets.env` with the following environment variables:

```bash
AWS_DEFAULT_REGION=
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
KMS_KEY_ID=
```

## Usage to update/add a new value

```bash
$ docker build -t your_desired_tag .
# Remember to edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env your_desired_tag flywire-playground-secrets/apps/testing-secrets/app.json.encrypted my_secret_key my_value
```

Where:

* `flywire-playground-secrets/apps/testing-secrets/app.json.encrypted`: is the route where the secret file is stored and you want to edit, if you put a file that not exists in the s3, it will create a new one
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

## Running the tests

```bash
$ rake
```

## Versioning

In general, Victoria secrets follows [semver](https://semver.org/)

## Authors

* **Super Mega Awesome Flywire SRE Team**
