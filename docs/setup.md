# Setting up Victoria Treasure

Create a file called `secrets.env` with the following environment variables:

```bash
AWS_DEFAULT_REGION=
AWS_SECRET_ACCESS_KEY=
AWS_ACCESS_KEY_ID=
KMS_KEY_ID=
```

Region should be set to the one used both by the S3 bucket and the KMS key, otherwise you will get an error.

Check if `jq` command is installed:
```
jq --version
```
If not installed, you can do so with:
```
brew install jq
```
