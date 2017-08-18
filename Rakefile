require 'rake'
require 'rspec/core/rake_task'

repo = 'jeffgrunewald'
version = Time.now.strftime("%Y%m%d-%H%M")
image = "#{repo}/#{@name}"
sha = system "git rev-parse HEAD"

task :default => :test

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/*_spec.rb')
  t.rspec_opts = '--color'
end

desc 'Remove dangling docker images'
task :cleanup do
  system "docker system prune -f"
end

desc 'Build the docker image'
task :build, [:tag, :dockerfile] do |t, args|
  args.with_defaults(tag: version)
  system "docker build --force-rm=true --pull=true \
    --label git_sha=#{sha} \
    --tag=#{image}:#{args[:tag]} ."
end

desc 'Re-tag the image for artifactory and push'
task :push, [:tag] do |t, args|
  args.with_defaults(
    tag: %x[docker images #{image} --format \"\{\{.Tag\}\}\" | sort -r | head -1].strip
  )
  system "docker push #{image}:#{args[:tag]}"
end

task :test => [
  :build,
  :spec,
  :cleanup
]
