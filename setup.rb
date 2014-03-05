# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'pathname'

HOME_PATH = Pathname.new(Dir.home)
AUTOPARTS_ROOT_PATH = HOME_PATH + '.parts'
AUTOPARTS_APP_PATH = AUTOPARTS_ROOT_PATH + 'autoparts'

class ExecutionFailedError < StandardError
  def initialize(cmd)
    super("\"#{cmd}\" failed")
  end
end

def execute(*args)
  args = args.map(&:to_s)
  unless system(*args)
    raise ExecutionFailedError.new args.join(' ')
  end
end

def inject_parts_init(path)
  puts "=> Injecting init script into ~/#{path.basename}"
  relative_autoparts_bin_path = AUTOPARTS_APP_PATH.relative_path_from(HOME_PATH) + 'bin'
  file = File.read(path)
  File.open(path, 'a') do |f|
    export_path = "export PATH=\"$HOME/#{relative_autoparts_bin_path}:$PATH\"\n"
    parts_init = "eval \"$(parts init -)\"\n"
    f.write "\n"
    f.write export_path unless file.include? export_path
    f.write parts_init unless file.include? parts_init
  end
end

if AUTOPARTS_APP_PATH.exist? && AUTOPARTS_APP_PATH.children.any?
  abort "setup: It appears that Autoparts is already installed on your box. If you want to reinstall Autoparts, please make sure that your \"#{AUTOPARTS_APP_PATH}\" directory is empty."
end

begin
  AUTOPARTS_ROOT_PATH.mkpath
  puts "=> Downloading Autoparts..."
  execute 'git', 'clone', 'https://github.com/action-io/autoparts.git', AUTOPARTS_APP_PATH

  bash_profile_path = HOME_PATH + '.bash_profile'
  bashrc_path = HOME_PATH + '.bashrc'
  zshrc_path = HOME_PATH + '.zshrc'

  if bash_profile_path.exist?
    inject_parts_init(bash_profile_path)
  elsif bashrc_path.exist?
    inject_parts_init(bashrc_path)
  end

  if zshrc_path.exist?
    inject_parts_init(zshrc_path)
  end

  puts "=> Installation complete!"
  puts "\nPlease reopen this shell or enter the following command:\n  exec $SHELL -l"
rescue => e
  AUTOPARTS_APP_PATH.rmtree if AUTOPARTS_APP_PATH.exist?
  abort "setup: ERROR: #{e}\nAborting!"
end
