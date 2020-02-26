require 'spec_helper'

RSpec.describe S3Secrets::Reader do
  describe '#get_secret' do
    it 'reads a secret from s3' do
      kms_key_id = 'kmsid'
      stubbed_s3_client = stub_s3_client
      stubbed_kms_client = stub_kms_client

      reader = S3Secrets::Reader.new(
        stub_s3_resource,
        stubbed_s3_client,
        stubbed_kms_client,
        kms_key_id
      )

      file_path = 'mys3/uploads/file'
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

      expect(stubbed_s3_client).to receive(:get_object)
        .with(expected_get_object_args)
        .and_call_original

      expect(stubbed_kms_client).to receive(:decrypt)
        .with(expected_decrypt_args)
        .and_call_original

      reader.get_secret(file_path, "my_secret") == json_content[:my_secret]
    end
  end
end
