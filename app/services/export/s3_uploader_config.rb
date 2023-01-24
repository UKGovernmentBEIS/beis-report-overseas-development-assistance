module Export
  class S3UploaderConfig
    def initialize(use_public_bucket:)
      @use_public_bucket = use_public_bucket
    end

    def region
      credentials.fetch("aws_region")
    end

    def bucket
      credentials.fetch("bucket_name")
    end

    def key_id
      credentials.fetch("aws_access_key_id")
    end

    def secret_key
      credentials.fetch("aws_secret_access_key")
    end

    private

    attr_reader :use_public_bucket

    def credentials
      JSON.parse(ENV.fetch("VCAP_SERVICES"))
        .fetch("aws-s3-bucket")
        .find { |config| config.fetch("name").match?(bucket_name_regex) }
        .fetch("credentials")
    rescue KeyError, NoMethodError => _error
      raise "AWS S3 credentials not found"
    end

    def bucket_name_regex
      use_public_bucket ? /s3-export-download-bucket$/ : /s3-export-download-bucket-private/
    end
  end
end
