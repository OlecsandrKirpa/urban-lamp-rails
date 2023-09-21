# frozen_string_literal: true

return unless Rails.env.development?

User.destroy_all
Playlist.destroy_all
Video.destroy_all

user = User.create(email: 'sasha@example.com', password: 'admin')

Playlist.create(user: user)

5.times do
  User.all.each do |user|
    user.playlists.each do |playlist|
      Video.create(playlist: playlist, user: user)
    end
  end
end
