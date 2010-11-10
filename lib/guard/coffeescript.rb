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
      @options[:strip_leading_path] ||= false
    end

    def run_all

      paths = Inspector.clean(Watcher.match_files(self, Dir.glob(File.join('**', '*.coffee'))))
      compile_to_subdirectory(paths, options)

    end

    def run_on_change(paths)
      paths = Inspector.clean(paths)
      compile_to_subdirectory(paths, options)
    end

    def compile_to_subdirectory(paths, options)

      paths.each do |path|

        subdirectory = File.dirname(path)
        if @options[:strip_leading_path]
          subdirectory = subdirectory.gsub(@options[:strip_leading_path], '')
        else
          subdirectory = subdirectory.slice((path.index('/') + 1)..-1)
        end

        output = File.join(options[:output], subdirectory)

        Runner.run([path], options.merge(:output => output)) unless paths.empty?

      end

    end

  end
end
