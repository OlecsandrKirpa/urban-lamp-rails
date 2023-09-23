# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DownloadVideo, type: :interaction do
  let(:video) { create(:video, :with_user, :with_playlist) }
  context 'inputs' do
    context 'video and video_id' do
      it { should have_input(:video).optional }
      it { should have_input(:video_id).of_type(:integer).optional }

      context 'if both are missing' do
        subject { described_class.run }

        it { should_not be_valid }

        context 'errors' do
          let(:errors) { described_class.run.errors }
          subject { errors }

          it { should include(:video) }
          it { should include(:video_id) }

          it do
            expect(errors[:video]).to include('param is missing or invalid')
          end

          it do
            expect(errors[:video_id]).to include('param is missing or invalid')
          end

          it 'should only have keys :video and :video_id' do
            expect(errors.as_json.keys).to match_array(%i[video video_id])
          end
        end
      end

      context 'if both are present' do
        context 'but different' do
          def run
            described_class.run(video: video, video_id: video_id)
          end
          subject { run }

          let(:video) { create(:video, :with_user, :with_playlist) }
          let(:video_id) { create(:video, :with_user, :with_playlist).id }

          it { should_not be_valid }

          context 'errors' do
            let(:errors) { run.errors }
            subject { errors }

            it { should include(:video) }
            it { should include(:video_id) }

            it do
              expect(errors[:video]).to include('both params :video and :video_id are present')
            end

            it do
              expect(errors[:video_id]).to include('both params :video and :video_id are present')
            end

            it 'should only have keys :video and :video_id' do
              expect(subject.as_json.keys).to match_array(%i[video video_id])
            end
          end
        end

        context 'and video_id == video.id' do
          def run
            described_class.run(video: video, video_id: video_id)
          end
          subject { run }

          let(:video) { create(:video, :with_user, :with_playlist) }
          let(:video_id) { video.id }

          it { should_not be_valid }

          context 'errors' do
            let(:errors) { run.errors }
            subject { errors }

            it { should include(:video) }
            it { should include(:video_id) }

            it do
              expect(errors[:video]).to include('both params :video and :video_id are present')
            end

            it do
              expect(errors[:video_id]).to include('both params :video and :video_id are present')
            end

            it 'should only have keys :video and :video_id' do
              expect(subject.as_json.keys).to match_array(%i[video video_id])
            end
          end
        end
      end

      context 'if video is present' do
        context 'and video_id is missing' do
          let(:run) { described_class.run(video: video) }
          subject { run }

          let(:video) { create(:video, :with_user, :with_playlist) }

          it { should be_valid }
          it { should respond_to(:valid_video) }

          it 'instance variable @valid_video should be set' do
            expect(subject.valid_video).to eq(video)
          end
        end

        context 'but it\'s not a Video' do
          def run
            described_class.run(video: video)
          end
          subject { run }

          let(:video) { create(:playlist, :with_user) }

          it { should_not be_valid }

          context 'errors' do
            let(:errors) { run.errors }
            subject { errors }

            it { should include(:video) }

            it do
              expect(errors[:video]).to include('is not a valid record')
            end

            it 'should only have key :video' do
              expect(subject.as_json.keys).to match_array(%i[video])
            end
          end
        end
      end

      context 'if video_id is present' do
        context 'and video is missing' do
          let(:run) { described_class.run(video_id: video_id) }
          subject { run }

          let(:video_id) { create(:video, :with_user, :with_playlist).id }

          it { should be_valid }
          it { should respond_to(:valid_video) }

          it 'instance variable @valid_video should be set' do
            expect(subject.valid_video.id).to eq(video_id)
          end
        end

        context 'but it\'s an id of a non-existing Video' do
          def run
            described_class.run(video_id: video_id)
          end
          subject { run }

          let(:video_id) { 0 }

          it { should_not be_valid }

          context 'errors' do
            let(:errors) { run.errors }
            subject { errors }

            it { should include(:video) }
            it { should include(:video_id) }

            it { expect(errors[:video]).to include('param is missing or invalid') }
            it { expect(errors[:video_id]).to include('param is missing or invalid') }

            it 'should only have key :video' do
              expect(subject.as_json.keys).to match_array(%i[video video_id])
            end
          end
        end

        context "but it's a stirng" do
          let(:run) { described_class.run(video_id: video_id) }
          subject { run }

          let(:video_id) { video.id.to_s }

          it { should be_valid }
          it 'instance variable @valid_video should be set' do
            expect(subject.valid_video.id).to eq(video_id.to_i)
          end
        end
      end
    end

    context 'async' do
      it { should have_input(:async).optional }

      context 'if missing' do
        subject { described_class.run(video: video) }

        it { should be_valid }
        it { should respond_to(:async) }

        it 'should have nil value for :async' do
          expect(subject.async).to be_nil
        end
      end

      context 'if present' do
        context 'and valid' do
          subject { described_class.run(async: async, video: video) }

          let(:async) { DownloadVideoJob.new }

          it { should be_valid }
          it { should respond_to(:async) }

          it 'should have value for :async' do
            expect(subject.async).to eq(async)
          end
        end
      end
    end

    context 'downloader' do
      [
        {
          downloader: VideoDownloader.new,
          valid: false
        },
        {
          downloader: 'VideoDownloader',
          valid: true
        },
        {
          downloader: 'VideoDownloader::TikTok',
          valid: false
        },
        {
          downloader: 'videodownloader::tiktok',
          valid: false
        },
        {
          downloader: 'VideoDownloader::tiktok',
          valid: false
        },
        {
          downloader: 'VideoDownloader::Tiktok',
          valid: true
        },
        {
          downloader: 'banana',
          valid: false
        },
        {
          downloader: :banana,
          valid: false
        },
        {
          downloader: 'ApplicationRecord',
          valid: false
        },
        {
          downloader: ApplicationRecord,
          valid: false
        }
      ].each do |situation|
        context "when downloader is #{situation[:downloader].to_s.inspect} of type #{situation[:downloader].class.inspect}" do
          let(:run) { described_class.run(video: video, downloader: situation[:downloader]) }
          subject { run }
  
          if situation[:valid]
            it { should be_valid }
            it { should respond_to(:downloader_klass) }
          else
            it { should_not be_valid }
            context 'errors' do
              let(:errors) { run.errors }
              subject { errors }
    
              it { should include(:downloader) }
    
              it { expect(errors.as_json.keys).to match_array(%i[downloader]) }
            end
          end
        end
      end
    end
  end
end
