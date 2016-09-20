# Grucket

> Seek and ye shall find.

Search for strings in files located in an S3 bucket.

## Requirements

* awscli
* proper credentials allowing access to desired S3 bucket

## Usage

First, set the proper environment variables required by the script:

```
export BUCKET=my_bucket
export FILE_PREFIX=my_file_prefix
export AWS_ACCESS_KEY_ID=xxxx
export AWS_SECRET_ACCESS_KEY=xxxx
```

Now run the script and supply the search term:

```
./grucket.sh find_me
```

`grucket` will recursively search all files in the bucket matching the search term.
