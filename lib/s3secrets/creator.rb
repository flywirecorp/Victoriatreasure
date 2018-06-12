require_relative './helpers/s3'
require_relative './helpers/kms'

module S3Secrets
  class Creator
    def initialize(s3_resource, s3_client, kms_client, kms_key_id)
      @kms_helper = S3Secrets::Helpers::Kms.new(kms_client, kms_key_id)
      @s3_helper = S3Secrets::Helpers::S3.new(s3_client, s3_resource)
    end

    def create_secret(file_uri, key, value)
      bucket = @s3_helper.bucket_from_file_uri(file_uri)
      file_path = @s3_helper.file_path_from_file_uri(file_uri)

      decrypted_json = get_json_secret_content(bucket, file_path)
      decrypted_json = add_key_value(decrypted_json, key, value)

      encrypt_json_and_upload_to_s3(decrypted_json, bucket, file_path)
    end

    private

    def get_json_secret_content(bucket, file_path)
      downloaded_file = @s3_helper.download_file(bucket, file_path)

      @kms_helper.decrypt(downloaded_file)
    end

    def encrypt_json_and_upload_to_s3(file_to_upload, bucket, file_path)
      encrypted_file = @kms_helper.encrypt file_to_upload

      @s3_helper.upload_file(encrypted_file, bucket, file_path)
    end

    def add_key_value(json, key, value)
      json[key] = value
      json
    end
  end
end
