## Usage to update/add a new values

```bash
$ docker build -t victoria_treasure --target=release .
# Remember to edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env victoria_treasure victoria-playground-secrets/apps/testing-secrets/app my_secret_key my_value
```

Where:

* `victoria-playground-secrets/apps/testing-secrets/app` is the route where the secret file is stored and you want to edit, if you put a file that not exists in the s3, it will create a new one
* `my_secret_key`: is the secret key to be added
* `my_value`: is the value of that key

If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key added to victoria-playground-secrets/apps/testing-secrets/app.json.encrypted
```

## Usage to get a value

```bash
$ docker build -t victoria_treasure --target=release .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env victoria_treasure victoria-playground-secrets/apps/testing-secrets/app my_secret_key
```

Where:

* `victoria-playground-secrets/apps/testing-secrets/app`: is the route where the secret file is stored and you want to check, if you put a file that not exists in the s3, the result will be empty
* `my_secret_key`: is the secret key to be read


If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret my_secret_key content is SUPER_SECRET_CONTENT
```

## Usage to get the whole secrets file decrypted

```bash
$ docker build -t victoria_treasure --target=release .
# Edit the secrets.env file to add the necessary variables
$ docker run --env-file=secrets.env victoria_treasure victoria-playground-secrets/apps/testing-secrets/app
```

Where:

* `victoria-playground-secrets/apps/testing-secrets/app`: is the route where the secret file is stored and you want to check, if you put a file that not exists in the s3, the result will be empty


If everything goes right, you'll get the following output:

```text
[SUCCESS] Secret content is {
  "secre_key": "secret_value"
}
```
