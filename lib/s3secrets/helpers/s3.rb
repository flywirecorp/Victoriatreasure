module S3Secrets
  module Helpers
    class S3
      def initialize(s3_client, s3_resource)
        @s3_client = s3_client
        @s3_resource = s3_resource
      end

      def get_bucket_region(bucket)
        location = @s3_client.get_bucket_location(bucket: bucket).to_h
        region = location[:location_constraint]
        env_region = ENV['AWS_DEFAULT_REGION']
        # if we find the bucket and consequently the region it's in
        unless region.empty?
          hint = "[Hint] The bucket '#{bucket}' is in '#{region}' region. Your ENV region is set to '#{env_region}'."
          puts hint if !(region.eql? env_region)
          region
        end
      end
      
      def download_file(bucket, file)
        json_file = empty_json_file
        begin
          if file_exists_in_s3(bucket, file)
            object = { bucket: bucket, key: file }
            json_file = @s3_client.get_object(object).body.read
          end
        rescue Aws::S3::Errors::Http301Error => e
          get_bucket_region(bucket)
          raise "[Error] #{e.inspect}"
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
