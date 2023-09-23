# frozen_string_literal: true

# This job will find the required video and call #download on it.
class DownloadVideoJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: :default, retry: false

  def perform(video_id)
    Video.find(video_id).download(async: self)
  end
end
