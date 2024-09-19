require 'aws-sdk-s3'
require 'pry'
require 'securerandom'

client = Aws::S3::Client.new

bucket_name = ENV['BUCKET_NAME']

resp = client.create_bucket({
  bucket: bucket_name, 
  create_bucket_configuration: {
    location_constraint: "ap-south-1", 
  }
})

number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Loop to create and upload each file
number_of_files.times.each do |i|
  puts "Creating file: #{i + 1}"

  # Generating a filename for each file
  filename = "file_#{i + 1}.txt"

  # Specifying the output path for the file in the 'tmp' folder
  output_path = "/tmp/#{filename}"

  # Writing a unique UUID to each file
  File.open(output_path, "w") do |f|
    f.write(SecureRandom.uuid) # Write a random UUID to the file
  end

  # Open and read the file in binary mode, then upload it to S3
  File.open(output_path, 'rb') do |f|
    client.put_object(
      bucket: bucket_name,  # Bucket to upload to
      key: filename,        # Key (filename) for the object in the bucket
      body: f               # File content
    )
    puts "#{filename} uploaded to S3."
  end
end