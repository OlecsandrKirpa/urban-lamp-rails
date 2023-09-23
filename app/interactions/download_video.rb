# frozen_string_literal: true

# This lib will manage the download of a video, starting from the Video.
# Will edit the Video model and attach the downloaded file.
class DownloadVideo < ActiveInteraction::Base
  # Mandatory inputs
  integer :video_id, default: nil
  record :video, default: nil, class: Video

  # Optional inputs
  object :async, default: -> { nil }, class: DownloadVideoJob
  string :downloader, default: nil
  object :downloader_args, default: nil

  # Validators
  validate :valid_video_exists
  validate :video_and_video_id_are_not_both_present
  validate :downloader_must_be_a_video_downloader, if: -> { valid_video.present? }

  def execute
    
  end

  def downloader_klass
    return @downloader_klass if defined?(@downloader_klass)

    @downloader_klass_str = (downloader || valid_video.downloader || valid_video.default_downloader).to_s
    @downloader_klass = @downloader_klass_str.constantize
  rescue NameError => e
    Rails.logger.error e
    puts e unless Rails.env.production?
    errors.add(:downloader, "must be a valid VideoDownloader. Got #{@downloader_klass_str}", details: { error: e })
    @downloader_klass = nil
  end

  def downloader_must_be_a_video_downloader
    return if downloader_klass.is_a?(Class) && (downloader_klass < VideoDownloader || downloader_klass == VideoDownloader)

    errors.add(:downloader, "must be a class. Got #{@downloader_klass_str}")
  end

  def valid_video
    return @valid_video if defined?(@valid_video)
    return @valid_video = video if video.is_a?(Video)

    @valid_video = Video.where(id: video_id.to_i).first
  end

  def valid_video_exists
    return if valid_video.present?

    errors.add(:video, 'param is missing or invalid')
    errors.add(:video_id, 'param is missing or invalid')
  end

  def video_and_video_id_are_not_both_present
    return if video.blank? || video_id.blank?

    errors.add(:video, 'both params :video and :video_id are present')
    errors.add(:video_id, 'both params :video and :video_id are present')
  end
end
