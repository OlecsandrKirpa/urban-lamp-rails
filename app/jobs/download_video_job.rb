# frozen_string_literal: true

class DownloadVideoJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  sidekiq_options queue: :default, retry: false

  def perform(video_id)
    DownloadVideo.run!(video_id: video_id, async: self)
  end
end
