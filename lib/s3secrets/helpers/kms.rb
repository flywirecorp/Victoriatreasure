module S3Secrets
  module Helpers
    class Kms
      def initialize(kms_client, kms_key_id)
        @kms_client = kms_client
        @kms_key_id = kms_key_id
      end

      def encrypt(content)
        content = JSON.pretty_generate(content)

        object_to_encrypt = { key_id: @kms_key_id, plaintext: content }
        @kms_client.encrypt(object_to_encrypt).ciphertext_blob
      end

      def decrypt(content)
        decrypted_object = content

        decrypted_object = @kms_client.decrypt(ciphertext_blob: content).plaintext unless plaintext?(content)

        JSON.parse(decrypted_object)
      end

      private

      def plaintext?(content)
        content == '{}'
      end
    end
  end
end
