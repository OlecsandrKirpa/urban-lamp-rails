# frozen_string_literal: true

class DownloadVideo < ActiveInteraction::Base
  object :video_id, class: Integer
  object :async, default: -> { nil }, class: DownloadVideoJob

  def execute
    video = Video.find(video_id)
    video.download
  end
end
