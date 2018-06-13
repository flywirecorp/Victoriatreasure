module S3Secrets
  module Helpers
    class S3
      def initialize(s3_client, s3_resource)
        @s3_client = s3_client
        @s3_resource = s3_resource
      end

      def download_file(bucket, file)
        json_file = empty_json_file
        if file_exists_in_s3(bucket, file)
          object = { bucket: bucket, key: file }
          json_file = @s3_client.get_object(object).body.read
        end

        json_file
      end

      def upload_file(file, bucket, file_path)
        object_to_upload = {
          body: file,
          bucket: bucket,
          key: file_path
        }
        @s3_client.put_object(object_to_upload)
      end

      def bucket_from_file_uri(file_uri)
        file_uri[0, file_uri.index('/')]
      end

      def file_path_from_file_uri(file_uri)
        file_uri[file_uri.index('/') + 1..file_uri.length]
      end

      private

      def empty_json_file
        '{}'
      end

      def file_exists_in_s3(bucket, file)
        bucket = @s3_resource.bucket(bucket)
        bucket.object(file).exists?
      end
    end
  end
end
