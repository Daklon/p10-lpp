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

guard :rspec, cmd: 'rspec -I. -f d spec/alimentos_spec.rb' do
  require 'guard/rspec'
  require "guard/rspec/inspectors/simple_inspector.rb"
  module ::Guard
      class RSpec < Plugin
          module Inspectors
              class SimpleInspector < BaseInspector
                  def paths(paths)
                      # please don't clear modified files correctly detected
                      # by watch but whose name doesn't end with '_spec.rb'
                      paths # return input without modification
                  end
              end
          end
      end
  end

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib})
end

guard :shell do
  watch(/.*/) { `git status -s` }
end

guard :bundler do
  watch('Gemfile')
end
