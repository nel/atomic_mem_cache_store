require "bundler/gem_tasks"

begin
  require "spec/rake/spectask"  # RSpec 1.3

  desc 'Run all specs in spec directory.'
  Spec::Rake::SpecTask.new(:spec) do |task|
    task.libs = ['lib', 'spec']
    task.spec_files = FileList['spec/**/*_spec.rb']
  end
rescue LoadError
  require "rspec/core/rake_task" # RSpec 2.0

  desc 'Run all specs in spec directory.'
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w{--colour --format progress}
    t.pattern = 'spec/**/*_spec.rb'
  end  
end

desc 'Default: runs specs.'
task :default => :spec
