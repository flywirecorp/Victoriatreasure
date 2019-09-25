require 'spec_helper'

RSpec.describe S3Secrets::Helpers::S3 do
  it 'downloads json file from the S3 bucket' do
    s3 = S3Secrets::Helpers::S3.new(
      stub_s3_client,
      stub_s3_resource
    )
  
    file_path = 'mys3/uploads/file.json.encrypted'
    bucket = 'mys3'
  
    s3.download_file(bucket, file_path)
  end
  
  it 'gets S3 bucket region' do
    env_region = 'eu-west-1'   
    stubbed_s3_resource = Aws::S3::Resource.new(region: env_region)
  
    s3 = S3Secrets::Helpers::S3.new(
      stub_s3_client,
      stubbed_s3_resource
    )
  
    bucket_region = 'eu-west-2'
    bucket = 'mys3'
    file_path = 'mys3/uploads/file.json.encrypted'
    
    allow(s3).to receive(:download_file).with(bucket, file_path).
      and_raise(Aws::S3::Errors::Http301Error)
    allow(s3).to receive(:get_bucket_region).with(bucket)
      .and_return(bucket_region)
  
    expect(s3.get_bucket_region(bucket)).to eq(bucket_region) 
  end
end