# frozen_string_literal: true

# This lib will manage the download of the file of a Video, and return the file.
class VideoDownloader < ActiveInteraction::Base
  record :video, class: Video
end
