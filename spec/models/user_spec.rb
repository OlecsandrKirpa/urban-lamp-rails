# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'should have valid factories' do
    it { expect(build(:user)).to be_valid }
    it { expect { create(:user).not_to raise_error } }
  end

  context 'validations' do
    before { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password_digest) }

    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:username).case_insensitive.allow_nil }

    it { should have_secure_password }

    it { should allow_value('email@example.com').for(:email) }
    it { should allow_value('email@example').for(:email) }
    it { should_not allow_value('email').for(:email) }
    it { should_not allow_value('email@').for(:email) }
    it { should_not allow_value('@example.com').for(:email) }
    it { should_not allow_value('email@example..com').for(:email) }

    it { should allow_value('username').for(:username) }
    it { should allow_value('username123').for(:username) }
    it { should allow_value('username123.').for(:username) }
    it { should allow_value('username123').for(:username) }
    it { should_not allow_value('usernam e123').for(:username) }
    it { should allow_value('usernam-e123').for(:username) }
    it { should allow_value('usernam.e123').for(:username) }
    it { should_not allow_value('').for(:username) }
    it { should allow_value(nil).for(:username) }
  end

  context 'associations' do
    it { should have_many(:playlists).dependent(:destroy) }
    it { should have_many(:videos).through(:playlists) }

    context 'should destroy associated playlists and videos' do
      let(:user) { create(:user) }

      before do
        create(:video, user: user, playlist: create(:playlist, user: user))
        expect(user.playlists.count).to eq(1)
        expect(user.videos.count).to eq(1)
      end

      after do
        expect(user.playlists.count).to eq(0)
        expect(user.videos.count).to eq(0)
      end

      it { expect { user.destroy }.to change { Playlist.count }.by(-1) }
      it { expect { user.destroy }.to change { Video.count }.by(-1) }
    end
  end
end
