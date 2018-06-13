require 'bundler/setup'
require_relative '../lib/s3secrets.rb'
require 'aws-sdk-s3'

module Helpers
  def stub_s3_client
    s3_client = Aws::S3::Client.new(stub_responses: true)

    s3_client.stub_responses(:get_object, body: '{"my_secret":"this_is_my_secret_peeeim"}')
    s3_client.stub_responses(:put_object, etag: 'uploaded_tag')

    s3_client
  end

  def stub_s3_resource
    Aws::S3::Resource.new(client: stub_s3_client)
  end

  def stub_kms_client
    kms_client = Aws::KMS::Client.new(stub_responses: true)

    content_to_decrypt = '{"my_secret":"this_is_my_secret_peeeim"}'
    content_to_encrypt = '{"my_secret":"this_is_my_secret_peeeim","another_key":"myvalue"}'
    kms_client.stub_responses(:decrypt, plaintext: content_to_decrypt)
    kms_client.stub_responses(:encrypt, ciphertext_blob: content_to_encrypt)

    kms_client
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end
