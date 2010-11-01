require 'guard'
require 'guard/guard'
require 'guard/watcher'

module Guard
  class CoffeeScript < Guard

    autoload :Runner, 'guard/coffeescript/runner'
    autoload :Inspector, 'guard/coffeescript/inspector'

    def initialize(watchers = [], options = {})
      @watchers, @options = watchers, options
      @options[:output] ||= 'javascripts'
      @options[:nowrap] ||= false
    end

    def run_all

      paths = Inspector.clean(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))

      paths.each do |path|

        subdirectory = File.dirname(path).slice((path.index('/') + 1)..-1)

        output = File.join(options[:output], subdirectory)

        Runner.run([path], options.merge(:output => output, :message => 'Compile all CoffeeScripts')) unless paths.empty?

      end
    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      Runner.run(paths, options) unless paths.empty?
    end

  end
end
