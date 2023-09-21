# frozen_string_literal: true

class FindVideosToDownloadJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: :default, retry: false

  def perform
    FindVideosToDownload.run!(async: self)
  end
end
