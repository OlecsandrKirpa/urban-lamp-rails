# frozen_string_literal: true

class FindVideosToDownload < ActiveInteraction::Base
  object :async, default: -> { nil }, class: FindVideosToDownloadJob
  integer :limit, default: -> { 1000 }

  def execute
    Video.ready_for_download.map(&:download_later)
  end
end
