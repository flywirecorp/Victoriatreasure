# Changelog


All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.5.3] - 2023-07-13
 - Update dockerignore

## [0.5.2] - 2023-07-12
 - Update gems

## [0.5.1] - 2022-11-02
 - Restore ENTRYPOINT in Dockerfile instead of CMD

## [0.5.0] - 2022-08-17
 - Remove aws-okta dependency

## [0.4.7] - 2022-03-23
 - Adds and argument checker with a correct exitcode

## [0.4.6] - 2021-11-30

### Changes 
 - Adds latest tag when pushing docker image 

## [0.4.5] - 2021-11-30

### Fixes
 - Adds credentiasl action for allowing git operations in the repo
   - This will fix the problem we have now for creating git tags 

## [0.4.4] - 2021-07-30
 - Add check jq is installed 

## [0.4.3] - 2021-06-4
 - Fixes output when getting KMS keys
 - README.md now contains jq dependency

## [0.4.2] - 2021-03-03
 - Fixes grep for getting KMS keys

## [0.4.1] - 2020-12-17
 - Adds security to CODEOWNERS

## [0.4.0] - 2020-09-15
 - Adds feature for getting the whole file instead of a single key the encrypted json
