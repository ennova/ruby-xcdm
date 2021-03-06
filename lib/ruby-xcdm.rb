require 'xcdm/schema'
require 'xcdm/entity'

if defined?(Motion::Project::Config)

  if File.directory?(File.join(App.config.project_dir, "schemas"))
    namespace :schema do

      desc "Clear the datamodel outputs"
      task :clean do
        files = Dir.glob(File.join(App.config.project_dir, 'resources', App.config.name) + ".{momd,xcdatamodeld}")
        files.each do |f|
          rm_rf f
        end
      end

      desc "Generate the xcdatamodel file"
      task :build => :clean do
        Dir.chdir App.config.project_dir
        if `xcodebuild -version` =~ /Xcode (\d.\d+)/
          xcode_version = $1
        else
          raise "could not determine xcode version"
        end
        runner = XCDM::Schema::Runner.new( App.config.name, "schemas", "resources", App.config.sdk_version)
        App.info "Generating", "Data Model #{App.config.name}"
        runner.load_all { |schema, file| App.info "Loading", file }
        runner.write_all { |schema, file| App.info "Writing", file }
      end
    end
  end

end
