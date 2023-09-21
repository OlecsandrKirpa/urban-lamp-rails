# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindVideosToDownload, type: :interaction do
  context 'inputs' do
    it { is_expected.to have_input(:async).with_default(nil) }

    context 'async' do
      subject { described_class.run!(async: async) }

      context 'when nil' do
        let(:async) { nil }

        it { expect { subject }.not_to raise_error }
      end

      context 'when FindVideosToDownloadJob instance' do
        let(:async) { FindVideosToDownloadJob.new }

        it { expect { subject }.not_to raise_error }
      end

      [
        Object.new,
        1,
        'string',
        :symbol,
        [],
        {},
        true,
        false,
        -> {},
        Sidekiq::Worker,
        ApplicationJob
      ].each do |async0|
        context "when #{async0.class} instance" do
          let(:async) { async0 }
          it { expect { subject }.to raise_error(ActiveInteraction::InvalidInteractionError) }
        end
      end
    end
  end

  context 'basic run' do
    let(:playlist) { create(:playlist, :with_user) }
    let(:user) { playlist.user }
    before do
      [false, true].each do |url|
        [false, true].each do |download_jid|
          [0, 1, 5, 100].each do |download_attempts|
            create(:video,
                   playlist: playlist,
                   user: user,
                   url: url ? Faker::Internet.url : nil,
                   download_jid: download_jid ? SecureRandom.uuid : nil,
                   download_attempts: download_attempts)
          end
        end
      end
    end

    let(:videos_to_download) { Video.ready_for_download }

    it { expect { described_class.run! }.not_to raise_error }

    it 'calls Video#download_later for all videos' do
      allow(Video).to receive(:ready_for_download).and_return(videos_to_download)
      videos_to_download.each do |video|
        allow(video).to receive(:download_later).and_return(true)
      end

      described_class.run!

      videos_to_download.each do |video|
        expect(video).to have_received(:download_later).once
      end
    end

    it 'calls Video.ready_for_download' do
      expect(Video).to receive(:ready_for_download).and_call_original
      described_class.run!
    end

    it 'returns an array of strings' do
      result = described_class.run!
      expect(result).to be_an(Array)
      expect(result.uniq).to eq [true]
    end
  end
end
