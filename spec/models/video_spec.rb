# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video, type: :model do
  context 'should have valid factories' do
    it { expect(build(:video, :with_playlist, :with_user)).to be_valid }
    it { expect { create(:video, :with_playlist, :with_user).not_to raise_error } }
  end

  context 'validations' do
    before do
      create(:video, :with_playlist, :with_user)
      allow_any_instance_of(Video).to receive(:assign_defaults).and_return(true)
    end

    it { should validate_uniqueness_of(:download_jid).case_insensitive.allow_nil }

    it { should belong_to(:playlist).required }
    it { should belong_to(:user).required }

    context 'should not allow same playlist_id and url' do
      let(:playlist) { create(:playlist, :with_user) }
      let(:url) { 'http://example.com' }
      let!(:video0) { create(:video, :with_user, playlist: playlist, url: url) }
      let(:video) { build(:video, :with_user, playlist: playlist, url: url) }

      it { expect { video.save! }.to raise_error(ActiveRecord::RecordInvalid) }
      it do
        expect(video.save).to eq(false)
        expect(video.errors).to include(:url)
      end
    end
  end

  context 'associations' do
    context 'on destroy' do
      let(:video) { create(:video, :with_playlist, :with_user) }
      let(:playlist) { video.playlist }
      let!(:playlist_id) { playlist.id }
      let(:user) { video.user }
      let!(:user_id) { user.id }

      before do
        expect(video.playlist).to be_persisted
        expect(video.playlist.id).to eq playlist.id
        expect(video.user).to be_persisted
        expect(video.user.id).to eq user.id
      end

      def destroy
        video.destroy
      end

      it { expect { destroy }.to change { Video.count }.by(-1) }
      it { expect { destroy }.to change { User.count }.by(0) }
      it { expect { destroy }.to change { Playlist.count }.by(0) }
    end
  end

  context 'scopes' do
    context 'valid_media/invalid_media' do
      let!(:valid_media) { create_list(:video, 3, :with_playlist, :with_user, valid_media: true) }
      let!(:invalid_media) { create_list(:video, 3, :with_playlist, :with_user, valid_media: false) }

      describe '.valid_media' do
        it { expect(Video.valid_media.count).to eq(3) }
        it { expect(Video.valid_media.pluck(:valid_media).uniq).to eq([true]) }
      end

      describe '.invalid_media' do
        it { expect(Video.invalid_media.count).to eq(3) }
        it { expect(Video.invalid_media.pluck(:valid_media).uniq).to eq([false]) }
      end
    end

    context 'with_url/without_url' do
      let!(:with_url) { create_list(:video, 3, :with_playlist, :with_user, url: 'http://example.com') }
      let!(:without_url) { create_list(:video, 3, :with_playlist, :with_user, url: nil) }

      describe '.with_url' do
        it { expect(Video.with_url.count).to eq(3) }
        it { expect(Video.with_url.pluck(:url).uniq).to eq(['http://example.com']) }
      end

      describe '.without_url' do
        it { expect(Video.without_url.count).to eq(3) }
        it { expect(Video.without_url.pluck(:url).uniq).to eq([nil]) }
      end
    end

    context 'with_download_jid/without_download_jid' do
      let!(:with_download_jid) { create_list(:video, 3, :with_playlist, :with_user, :with_download_jid) }
      let!(:without_download_jid) { create_list(:video, 3, :with_playlist, :with_user, download_jid: nil) }

      describe '.with_download_jid' do
        it { expect(Video.with_download_jid.count).to eq(3) }
        it { expect(Video.with_download_jid.pluck(:download_jid).uniq.count).to eq(3) }
        it { expect(Video.with_download_jid.pluck(:download_jid).uniq).not_to include(nil) }
      end

      describe '.without_download_jid' do
        it { expect(Video.without_download_jid.count).to eq(3) }
        it { expect(Video.without_download_jid.pluck(:download_jid).uniq).to eq([nil]) }
      end
    end

    context 'ready_for_download' do
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

      it { expect(Video.ready_for_download.count).to eq(Video.where(download_jid: nil).where('download_attempts < ?', Config.max_download_attempts).where.not(url: nil).count) }
    end
  end
end
