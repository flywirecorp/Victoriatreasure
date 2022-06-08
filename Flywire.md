# Victoria Secrets

Reminders:
- always use `get_aws_secrets.sh` before victoriaTreasure
- `get_aws_secrets.sh` depends on [aws-okta](https://confluence.flywire.tech/display/SRE/AWS+programmatic+credentials+via+Okta)
- always use victoriaTreasure from your copy of the git repository (ie from the same folder as this Flywire.md file)

## Getting the secrets.env file

To refresh your victoriaTreasure credentials run:

```bash
$ ./get_aws_secrets.sh aws_staging_developers
```

It will create `secrets.env` file in the root path of the victoriaTreasure repo.

YMMV and you may need to use a different AWS profile (ie not `aws_staging_developers`). Refer to `~/.aws/config` for the profiles configured in your machine.

## Usage

### Build the container

```
$ docker build -t victoria_treasure .
```

### How to set a secret

```bash
$ ./get_aws_secrets.sh aws_staging_developers
$ docker run --env-file=secrets.env victoria_treasure $VICTORIA_ACCOUNT_ALIAS$-secrets/$SECRET_PATH$ $MY_SECRET_KEY$ $MY_VALUE$
```

output:

```text
[SUCCESS] Secret my_secret_key added to victoria-playground-secrets/apps/testing-secrets/app
```

### How to get a secret

```bash
$ ./get_aws_secrets.sh aws_staging_developers
$ docker run --env-file=secrets.env victoria_treasure $VICTORIA_ACCOUNT_ALIAS$-secrets/$SECRET_PATH$ $MY_SECRET_KEY$
```

output:
```text
[SUCCESS] Secret my_secret_key content is SUPER_SECRET_CONTENT
```

Where:

* `$VICTORIA_ACCOUNT_ALIAS$` : a valid [account alias](https://confluence.flywire.tech/x/IbCDIw)
  - ie one of: `victoria-production`, `victoria-staging`, `victoria-playground`
* `$SECRET_PATH$`: the path to the secret
  - must match what you use in your app.json
  - the conventional path is: apps/$CI_PROJECT_NAME/app
* `$MY_SECRET_KEY$`: the secret key
* `$MY_VALUE$`: the value of the secret


## What's happening behind the scenes

* Downloads and decrypt the specified file into memory if it exists, if not, it creates a new file in memory
* Edits the file adding the specified key and value
* Encrypts and upload the changes to S3, replacing the old file

Secrets are stored in KMS encrypted json files in S3.

## Notes

- The naming of the secret key is case sensitive. Therefore if the key is named MY_SECRET and you will read as "secret:$AWS_ACCOUNT_ALIAS-secrets/apps/$CI_PROJECT_NAME/app:my_secret" the pipeline will fail with "ERROR -- : Secret key MY_SECRET does not exist in...". As a guideline, use lowercase for naming your secret keys.

- All this process is done by this gem we have developed: [secrets-parser](https://github.com/peertransfer/secrets_parser)

- When a secret is changed the app needs to be restarted or edeployed to load the new secret value.
- Size constraint for a secret value is 4096 bytes due to the limitation imposed by AWS KMS. If you get over that limit with app.json.encrypted, start a new file.
