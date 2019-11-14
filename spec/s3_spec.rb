require 'spec_helper'

RSpec.describe S3Secrets::Helpers::S3 do
  it 'returns empty file if file does not exists' do
    s3 = S3Secrets::Helpers::S3.new(
      stub_s3_client,
      stub_s3_resource
    )

    file_path = 'mys3/uploads/file.json.encrypted'
    bucket = 'mys3'
    expected_file = '{}'
    
    # stub for file_exists_in_s3 returning nil
    allow(s3).to receive(:file_exists_in_s3).with(bucket, file_path)
      .and_return(nil)

    file = s3.download_file(bucket, file_path)
    expect(file).to eq(expected_file)
  end

  it 'returns the object if the file exists' do
    s3 = S3Secrets::Helpers::S3.new(
      stub_s3_client,
      stub_s3_resource
    )
  
    file_path = 'mys3/uploads/file.json.encrypted'
    bucket = 'mys3'
    expected_file = '{"my_secret":"this_is_my_secret_peeeim"}'
  
    file = s3.download_file(bucket, file_path)  
    expect(file).to eq(expected_file)
  end

  it 'raises an error if bucket region differs from env region, outputs and returns buckets region' do
    env_region = 'eu-west-1'
    bucket_region = 'eu-west-2'
    stubbed_s3_resource = Aws::S3::Resource.new(stub_responses: { region: env_region } )

    s3 = S3Secrets::Helpers::S3.new(
      stub_s3_client,
      stubbed_s3_resource
    )

    file_path = 'mys3/uploads/file.json.encrypted'
    bucket = 'mys3'
    
    allow(s3).to receive(:download_file).with(bucket, file_path)
      .and_raise(Aws::S3::Errors::Http301Error)
    expect{s3.get_bucket_region(bucket)}.to output.to_stdout

    allow(s3).to receive(:get_bucket_region).with(bucket)
      .and_return(bucket_region)
    expect(s3.get_bucket_region(bucket)).to eq(bucket_region)
  end
end
