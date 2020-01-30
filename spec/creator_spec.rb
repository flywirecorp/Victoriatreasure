require 'spec_helper'

RSpec.describe S3Secrets::Creator do
  describe '#create_secret' do
    it 'creates a secret in s3' do
      kms_key_id = 'kmsid'
      stubbed_s3_client = stub_s3_client
      stubbed_kms_client = stub_kms_client

      creator = S3Secrets::Creator.new(
        stub_s3_resource,
        stubbed_s3_client,
        stubbed_kms_client,
        kms_key_id
      )

      file_path = 'mys3/uploads/file'
      secret_key = 'another_key'
      secret_value = 'myvalue'
      bucket = 'mys3'
      file_key = 'uploads/file.json.encrypted'
      json_content = { my_secret: 'this_is_my_secret_peeeim' }

      expected_get_object_args = {
        bucket: bucket,
        key: file_key
      }

      expected_decrypt_args = {
        ciphertext_blob: json_content.to_json
      }

      json_content[secret_key] = secret_value
      expected_encrypt_args = {
        key_id: kms_key_id,
        plaintext: JSON.pretty_generate(json_content)
      }

      expected_put_object_args = {
        body: json_content.to_json,
        bucket: bucket,
        key: file_key
      }

      expect(stubbed_s3_client).to receive(:get_object)
        .with(expected_get_object_args)
        .and_call_original

      expect(stubbed_kms_client).to receive(:decrypt)
        .with(expected_decrypt_args)
        .and_call_original

      expect(stubbed_kms_client).to receive(:encrypt)
        .with(expected_encrypt_args)
        .and_call_original

      expect(stubbed_s3_client).to receive(:put_object)
        .with(expected_put_object_args)
        .and_call_original

      creator.create_secret(file_path, secret_key, secret_value)
    end
  end
end
