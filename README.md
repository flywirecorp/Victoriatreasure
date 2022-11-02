# Victoria Treasure

![Victoria](imgs/victoria.png)
![Treasure](imgs/Treasure.png)

[![CircleCI](https://circleci.com/gh/peertransfer/Victoriatreasure.svg?style=svg)](https://circleci.com/gh/peertransfer/Victoriatreasure)

Victoria Treasure is an utility for handling secrets in S3.

**Internal Flywire users**: please read [./Flywire.md](./Flywire.md).

## What's happening behind the scenes

* Downloads and decrypt the specified file into memory if it exists, if not, it creates a new file in memory
* Edits the file adding the specified key and value
* Encrypts and upload the changes to S3, replacing the old file

## Prerequisites

- Docker

## Build the container

```bash
docker build -t victoria_treasure --target=test .
```

## Running the tests

```bash
docker run --entrypoint="" victoria_treasure rake test
```

## Versioning

In general, Victoria secrets follows [semver](https://semver.org/)

## Authors

* **Super Mega Awesome Flywire SRE Team**
