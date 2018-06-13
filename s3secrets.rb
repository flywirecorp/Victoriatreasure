require_relative './lib/s3secrets.rb'
require 'aws-sdk-s3'

def check_env_vars
  env_vars_to_check = %w(
    AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_DEFAULT_REGION KMS_KEY_ID
  )

  vars = env_vars_to_check.select { |var| ENV[var].nil? }
  return if vars.empty?

  puts "[FAIL] Environment variables #{vars.join(' ')} not set"
  exit 1
end

def instance_creator
  s3_resource = Aws::S3::Resource.new(region: ENV['AWS_DEFAULT_REGION'])
  s3_client = Aws::S3::Client.new(region: ENV['AWS_DEFAULT_REGION'])
  kms_client = Aws::KMS::Client.new
  kms_key_id = ENV['KMS_KEY_ID']
  S3Secrets::Creator.new(s3_resource, s3_client, kms_client, kms_key_id)
end

secret_file = ARGV[0]
key_to_add = ARGV[1]
value_to_add = ARGV[2]

check_env_vars
creator = instance_creator

creator.create_secret(secret_file, key_to_add, value_to_add)

puts "[SUCCESS] Secret #{key_to_add} added to #{secret_file}"
