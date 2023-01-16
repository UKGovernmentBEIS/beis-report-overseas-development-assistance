require "rails_helper"

RSpec.describe Export::S3Downloader do
  let(:response_body) { double("response_body", read: double) }
  let(:response) { double("response", body: response_body) }
  let(:aws_credentials) { double("aws credentials") }
  let(:aws_client) { instance_double(Aws::S3::Client, get_object: response) }

  let(:s3_bucket) { double("s3 bucket") }
  let(:s3_uploader_config) {
    instance_double(
      Export::S3UploaderConfig,
      key_id: "key id",
      secret_key: "secret key",
      region: "region",
      bucket: s3_bucket
    )
  }

  let(:filename) { "Q1_report0101202312345.csv" }

  subject {
    Export::S3Downloader.new(filename: filename)
  }

  before do
    allow(Aws::Credentials).to receive(:new).and_return(aws_credentials)
    allow(Aws::S3::Client).to receive(:new).and_return(aws_client)
    allow(Export::S3UploaderConfig).to receive(:new).and_return(s3_uploader_config)
  end

  describe "#initialize" do
    context "when instantiating the Aws::S3::Client" do
      it "sets `credentials:` using an Aws::Credentials object" do
        subject

        expect(Aws::Credentials).to have_received(:new).with(
          s3_uploader_config.key_id,
          s3_uploader_config.secret_key
        )
        expect(Aws::S3::Client).to have_received(:new).with(hash_including(
          credentials: aws_credentials
        ))
      end

      it "sets `region:` using the region from the S3UploaderConfig" do
        subject

        expect(Aws::S3::Client).to have_received(:new).with(hash_including(
          region: s3_uploader_config.region
        ))
      end
    end
  end

  describe "#download" do
    it "gets the specified report CSV from S3" do
      subject.download

      expect(aws_client).to have_received(:get_object).with(
        bucket: s3_bucket,
        key: filename,
        response_content_type: "text/csv"
      )
      expect(response).to have_received(:body)
      expect(response_body).to have_received(:read)
    end

    context "when something goes wrong with fetching the object from S3" do
      before do
        allow(aws_client).to receive(:get_object).and_raise("There has been a problem!")
      end

      it "re-raises the error, adding the filename for information" do
        enriched_message = "There has been a problem! #{I18n.t("download.failure", filename: filename)}"
        expect { subject.download }.to raise_error(Export::S3DownloaderError, enriched_message)
      end
    end
  end
end
