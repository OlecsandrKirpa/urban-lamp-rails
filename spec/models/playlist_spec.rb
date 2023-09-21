# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist, type: :model do
  context 'should have valid factories' do
    it { expect(build(:playlist, :with_user)).to be_valid }
    it { expect { create(:playlist, :with_user).not_to raise_error } }
  end

  context 'validations' do
    before do
      create(:playlist, :with_user)
      allow_any_instance_of(Playlist).to receive(:assign_defaults).and_return(true)
    end

    it { should validate_presence_of(:visibility) }
    it { should validate_inclusion_of(:visibility).in_array(%w[public private]) }

    it { should_not validate_presence_of(:name) }
    it { should_not validate_presence_of(:notes) }

    it { should belong_to(:user).required }
  end

  context 'associations' do
    it { should belong_to(:user).required }
    it { should have_many(:videos).dependent(:destroy) }

    context 'on destroy' do
      let(:user) { create(:user) }
      let(:playlist) { create(:playlist, user: user) }
      let!(:playlist_id) { playlist.id }

      before do
        create(:video, playlist: playlist, user: playlist.user)
        expect(playlist.user).to be_persisted
        expect(playlist.user.id).to eq user.id
        expect(playlist.videos.count).to eq(1)
      end

      after do
        expect(playlist.videos.count).to eq(0)
      end

      def destroy
        playlist.destroy
      end

      it { expect { destroy }.to change { Video.count }.by(-1) }
      it { expect { destroy }.to change { Playlist.count }.by(-1) }
      it { expect { destroy }.to change { User.count }.by(0) }
    end
  end
end
