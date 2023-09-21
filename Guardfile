# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# guard :rspec, cmd: 'rspec -f html -o /tmp/spec_results.html', launchy: '/tmp/spec_results.html' do
guard :rspec, cmd: 'bundle exec rspec --no-profile', notification: false do
  watch('spec/spec_helper.rb')                        { "spec" }
  watch('config/routes.rb')                           { "spec/controllers" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }

  # When editing mailer views, we want to test them.
  watch(%r{^app/views/(.*)_mailer/(.*)(\.erb|\.haml|\.slim)$}) { |m| "spec/mailers/#{m[1]}_mailer_spec.rb" }

  # When editing factories, we want to test them.
  watch(%r{^spec/factories/(.*)_factory\.rb$})                 { |m| "spec/models/#{m[1]}_spec.rb" }

  # When editing shared examples, we want to launch all specs.
  watch(%r{^spec/shared_examples/(.*).examples\.rb$}) { "spec" }

  # If editing matchers, run all specs.
  watch(%r{^spec/matchers/(.*)\.rb$}) { "spec" }

  watch(%r{^spec/support/(.*)\.rb$}) { "spec" }

  # watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  # watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end
