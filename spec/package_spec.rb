# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'spec_helper'
require 'fileutils'
require 'webmock/rspec'

class FooPackage < Autoparts::Package
  name 'foo'
  version '1.0'
  description "foo package"
  category Autoparts::Category::PROGRAMMING_LANGUAGES

  source_url 'http://example.com/foo.tar.gz'
  source_sha1 'f00f00f00f00f00f00f00f00f00f00f00f00f00f'
  source_filetype 'tar.gz'

  def start
  end
end

class BarPackage < Autoparts::Package
  name 'bar'
  version '2.0'
  category Autoparts::Category::DEPLOYMENT

  description "bar bar black sheep"
  source_url 'http://example.com/bar.zip'
  source_sha1 'babababababababababababababababababababa'
  source_filetype 'zip'

  def start
  end
end

class BazPackage < Autoparts::Package
  name 'baz'
  version '2.1'
  description "baz baz black sheep"
  category Autoparts::Category::LIBRARIES

  source_url 'http://example.com/baz.zip'
  source_sha1 'babababababababababababababababababababa'
  source_filetype 'zip'

  def start
  end
end

describe Autoparts::Package do
  let(:foo_package) { FooPackage.new }
  let(:bar_package) { BarPackage.new }

  before do
    foo_package.stub(:system)
    bar_package.stub(:system)
  end

  describe '.depends_on' do
    it 'buils dependencies for the current package' do
      foobar = Class.new(Autoparts::Package) do
        name 'foobar'
        depends_on 'foo'
        depends_on 'bar'
      end

      expect(foobar.dependencies).to include(FooPackage)
      expect(foobar.dependencies).to include(BarPackage)
    end
  end

  describe '.installed' do
    before do
      FileUtils.mkdir_p (Autoparts::Path.packages + 'mysql' + '5.6.13').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'mysql' + '5.4.0').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'nodejs' + '0.10.16').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'nodejs' + '0.8.25').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'rbenv' + '0.4.0-52').to_s
      FileUtils.touch (Autoparts::Path.packages + 'junk').to_s
      FileUtils.touch (Autoparts::Path.packages + 'mysql' + '5.6.13' + '.keep').to_s
      FileUtils.touch (Autoparts::Path.packages + 'mysql' + '5.4.0' + 'some_file').to_s
      FileUtils.touch (Autoparts::Path.packages + 'nodejs' + '0.10.16' + 'README').to_s
    end

    it 'inspects packages path and returns a hash containing all installed packages, ignoring empty directories' do
      expect(described_class.installed).to eq({
        'mysql' => ['5.6.13', '5.4.0'],
        'nodejs' => ['0.10.16']
      })
    end
  end

  describe '.installed?' do
    before do
      FileUtils.mkdir_p (Autoparts::Path.packages + 'mysql' + '5.6.13').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'nodejs' + '0.10.16').to_s
      FileUtils.touch (Autoparts::Path.packages + 'mysql' + '5.6.13' + '.keep').to_s
    end

    it 'returns a boolean value of whether a package of a given name is installed' do
      expect(described_class.installed? 'mysql').to be_true
      expect(described_class.installed? 'nodejs').to be_false
    end
  end

  describe '.start_all' do
    before do
      FileUtils.mkdir_p (Autoparts::Path.packages + 'foo' + '1.0').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'bar' + '2.0').to_s
      FileUtils.mkdir_p (Autoparts::Path.packages + 'baz' + '2.1').to_s

      FileUtils.touch (Autoparts::Path.packages + 'foo' + '1.0' + '.keep').to_s
      FileUtils.touch (Autoparts::Path.packages + 'bar' + '2.0' + '.keep').to_s
      FileUtils.touch (Autoparts::Path.packages + 'baz' + '2.1' + '.keep').to_s

      FileUtils.touch (Autoparts::Path.init + 'foo.conf').to_s
      FileUtils.touch (Autoparts::Path.init + 'baz.conf').to_s

      FooPackage.any_instance.stub(:start) { 'foo' }
      BazPackage.any_instance.stub(:start) { 'baz' }
    end

    before do
      Autoparts::Package.stub(:system) { true }
    end

    context 'none of the packages are running' do
      before do
        Autoparts::Package.any_instance.stub(:running?) { false }
      end

      it 'should start packages which are meant to be auto-started' do
        expect(Autoparts::Package).to receive(:system).ordered.with "parts start foo", {}
        expect(Autoparts::Package).to receive(:system).ordered.with "parts start baz", {}
        Autoparts::Package.start_all
      end
    end

    context 'all the packages are running' do
      before do
        Autoparts::Package.any_instance.stub(:running?) { true }
      end

      it 'should start packages which are meant to be auto-started' do
        expect(Autoparts::Package).to_not receive(:system)
        Autoparts::Package.start_all
      end
    end

    context 'with silent=true' do
      before do
        Autoparts::Package.any_instance.stub(:running?) { false }
      end

      it 'should start packages which are meant to be auto-started' do
        expect(Autoparts::Package).to receive(:system).ordered.with "parts start foo", { out: '/dev/null', err: '/dev/null' }
        expect(Autoparts::Package).to receive(:system).ordered.with "parts start baz", { out: '/dev/null', err: '/dev/null' }
        Autoparts::Package.start_all(true)
      end
    end
  end

  describe '.factory' do
    it 'attempts to load the package file, and creates an instance of package class by a given name' do
      expect(described_class).to receive(:require).with('autoparts/packages/foo')
      expect(described_class.factory('foo')).to be_a FooPackage

      expect(described_class).to receive(:require).with('autoparts/packages/bar')
      expect(described_class.factory('bar')).to be_a BarPackage

      expect(described_class).to receive(:require).with('autoparts/packages/lol')
      expect {
        described_class.factory('lol')
      }.to raise_error Autoparts::PackageNotFoundError, 'Package "lol" not found'
    end
  end

  describe '#dependencies' do
    it 'resolves all dependencies of the current package' do
      newfoo_pkg = Class.new(Autoparts::Package) do
        name 'newfoo'
        depends_on 'foo'
      end

      foobar_pkg = Class.new(Autoparts::Package) do
        name 'foobar'
        depends_on 'newfoo'
        depends_on 'bar'
      end

      foobar = foobar_pkg.new
      newfoo = foobar.dependencies.children.find { |d| d.name == "newfoo" }
      expect(newfoo.children).to include(Autoparts::Dependency.new(FooPackage.new))
      expect(foobar.dependencies.children).to include(Autoparts::Dependency.new(newfoo_pkg.new))
      expect(foobar.dependencies.children).to include(Autoparts::Dependency.new(BarPackage.new))
    end
  end

  describe '#perform_install_with_dependencies' do
    context 'one level of dependencies' do
      it 'installs the dependencies of the current package' do
        foobar_pkg = Class.new(Autoparts::Package) do
          name 'foobar'
          depends_on 'foo'
          depends_on 'bar'
        end
        foobar = foobar_pkg.new
        expect_any_instance_of(FooPackage).to receive(:perform_install).with(true)
        expect_any_instance_of(BarPackage).to receive(:perform_install).with(true)
        expect(foobar).to receive(:perform_install).with(true)
        foobar.perform_install_with_dependencies true
      end
    end

    context 'two levels of dependencies' do
      it 'installs the all dependencies of the current package (including nested ones)' do
        foobaz_pkg = Class.new(Autoparts::Package) do
          name        'foobaz'
          depends_on  'foo'
        end

        foobar_pkg = Class.new(Autoparts::Package) do
          name        'foobar'
          depends_on  'foobaz'
          depends_on  'bar'
        end

        foobar = foobar_pkg.new

        expect_any_instance_of(FooPackage).to receive(:perform_install).with(true)
        expect_any_instance_of(foobaz_pkg).to receive(:perform_install).with(true)
        expect_any_instance_of(BarPackage).to receive(:perform_install).with(true)

        expect(foobar).to receive(:perform_install).with(true)
        foobar.perform_install_with_dependencies true
      end
    end
  end

  describe '#get_dependency' do
    it 'retrieves the specified dependency instance' do
      foobar_pkg = Class.new(Autoparts::Package) do
        name 'foobar'
        depends_on 'foo'
        depends_on 'bar'
      end
      foobar = foobar_pkg.new
      expect(foobar.get_dependency('foo')).to be_kind_of(FooPackage)
    end
  end

  describe '#name' do
    it 'returns the name of the package, as set in the contructor' do
      expect(foo_package.name).to eq 'foo'
      expect(bar_package.name).to eq 'bar'
    end
  end

  describe '#version' do
    it 'returns the version set using the DSL keyword "version"' do
      expect(foo_package.version).to eq '1.0'
      expect(bar_package.version).to eq '2.0'
    end
  end

  describe '#description' do
    it 'returns the description set using the DSL keyword "description"' do
      expect(foo_package.description).to eq 'foo package'
      expect(bar_package.description).to eq 'bar bar black sheep'
    end
  end

  describe '#category' do
    it 'returns the category set using the DSL keyword "category"' do
      expect(foo_package.category).to eq Autoparts::Category::PROGRAMMING_LANGUAGES
      expect(bar_package.category).to eq Autoparts::Category::DEPLOYMENT
    end
  end

  describe '#name_with_version' do
    it 'returns <name>-<version>' do
      expect(foo_package.name_with_version).to eq 'foo-1.0'
      expect(bar_package.name_with_version).to eq 'bar-2.0'
    end
  end

  describe '#source_url' do
    it 'returns the url for the source code archive set using the DSL keyword "source_url"' do
      expect(foo_package.source_url).to eq 'http://example.com/foo.tar.gz'
      expect(bar_package.source_url).to eq 'http://example.com/bar.zip'
    end
  end

  describe '#source_sha1' do
    it 'returns the sha1 for the source code archive set using the DSL keyword "source_sha1"' do
      expect(foo_package.source_sha1).to eq 'f00f00f00f00f00f00f00f00f00f00f00f00f00f'
      expect(bar_package.source_sha1).to eq 'babababababababababababababababababababa'
    end
  end

  describe '#source_filetype' do
    it 'returns the file type for the source code archive set using the DSL keyword "source_filetype"' do
      expect(foo_package.source_filetype).to eq 'tar.gz'
      expect(bar_package.source_filetype).to eq 'zip'
    end
  end

  describe '#binary_url' do
    it 'returns the url for the precompiled binary archive set using the DSL keyword "binary_url"' do
      expect(foo_package.binary_url).to eq "http://parts.nitrous.io/foo-1.0-binary.tar.gz"
      expect(bar_package.binary_url).to eq "http://parts.nitrous.io/bar-2.0-binary.tar.gz"
    end
  end

  describe '#binary_sha1_url' do
    it 'returns the url for the precompiled binary archive set using the DSL keyword "binary_sha1"' do
      expect(foo_package.binary_sha1_url).to eq "http://parts.nitrous.io/foo-1.0-binary.sha1"
      expect(bar_package.binary_sha1_url).to eq "http://parts.nitrous.io/bar-2.0-binary.sha1"
    end
  end

  describe '#user' do
    it "returns current user's username" do
      orig_user = ENV['USER']
      ENV['USER'] = 'action'
      expect(foo_package.user).to eq 'action'
      ENV['USER'] = orig_user
    end
  end

  describe '#prefix_path' do
    it 'returns the directory at which the package will be installed' do
      expect(foo_package.prefix_path).to be_a Pathname
      expect(bar_package.prefix_path).to be_a Pathname
      expect(foo_package.prefix_path.to_s).to eq "#{Autoparts::Path.packages}/foo/1.0"
      expect(bar_package.prefix_path.to_s).to eq "#{Autoparts::Path.packages}/bar/2.0"
    end
  end

  %w(bin sbin include lib libexec share).each do |d|
    describe "##{d}_path" do
      it "returns #{d} directory under the package directory" do
        expect(foo_package.send(:"#{d}_path")).to be_a Pathname
        expect(foo_package.send(:"#{d}_path").to_s).to eq "#{foo_package.prefix_path}/#{d}"
      end
    end
  end

  %w(info man).each do |d|
    describe "##{d}_path" do
      it "returns #{d} directory under the share directory" do
        expect(foo_package.send(:"#{d}_path")).to be_a Pathname
        expect(foo_package.send(:"#{d}_path").to_s).to eq "#{foo_package.share_path}/#{d}"
      end
    end
  end

  (1..8).each do |i|
    describe "#man#{i}_path do" do
      it "returns man#{i} directory under the man directory" do
        expect(foo_package.send(:"man#{i}_path")).to be_a Pathname
        expect(foo_package.send(:"man#{i}_path").to_s).to eq "#{foo_package.man_path}/man#{i}"
      end
    end
  end

  describe '#doc_path' do
    it 'returns doc/PACKAGE_NAME directory under the share directory' do
      expect(foo_package.doc_path).to be_a Pathname
      expect(bar_package.doc_path).to be_a Pathname
      expect(foo_package.doc_path.to_s).to eq "#{foo_package.share_path}/doc/foo"
      expect(bar_package.doc_path.to_s).to eq "#{bar_package.share_path}/doc/bar"
    end
  end

  describe '#execute' do
    context 'when command succeeds' do
      it 'does not raise any error' do
        expect(foo_package).to receive(:system).with('echo', 'hello', 'world').and_return true
        expect {
          foo_package.execute 'echo', 'hello', 'world'
        }.not_to raise_error
      end
    end

    context 'when command fails' do
      it 'raises ExecutionFailedError' do
        expect(foo_package).to receive(:system).with('echo', 'foo').and_return false
        expect {
          foo_package.execute 'echo', 'foo'
        }.to raise_error Autoparts::ExecutionFailedError, '"echo foo" failed'
      end
    end
  end

  describe '#execute_with_result' do
    context 'when command succeeds' do
      it 'returns true' do
        expect(foo_package).to receive(:system).with('echo', 'lol', 'wut').and_return true
        expect(foo_package.execute_with_result 'echo', 'lol', 'wut').to be_true
      end
    end

    context 'when command fails' do
      it 'returns the return value of the underlying system call' do
        expect(foo_package).to receive(:system).with('echo', 'orly').and_return false
        expect(foo_package.execute_with_result 'echo', 'orly').to be_false
        expect(foo_package).to receive(:system).with('echo', 'failed').and_return nil
        expect(foo_package.execute_with_result 'echo', 'failed').to be_nil
      end
    end
  end

  describe '#archive_filename' do
    context 'when @source_install is false' do
      before do
        foo_package.instance_variable_set :@source_install, false
        bar_package.instance_variable_set :@source_install, false
      end

      it 'generates a filename for the precompiled binary archive in the following format: <name>-<version>-binary.tar.gz' do
        expect(foo_package.archive_filename).to eq "foo-1.0-binary.tar.gz"
        expect(bar_package.archive_filename).to eq "bar-2.0-binary.tar.gz"
      end
    end

    context 'when @source_install is true' do
      before do
        foo_package.instance_variable_set :@source_install, true
        bar_package.instance_variable_set :@source_install, true
      end

      it 'generates a filename for the source code archive in the following format: <name>-<version>.<source_filetype>' do
        expect(foo_package.archive_filename).to eq "foo-1.0.tar.gz"
        expect(bar_package.archive_filename).to eq "bar-2.0.zip"
      end
    end
  end

  describe '#binary_sha1_filename' do
    it 'generates a filename for the precompiled binary SHA1 in the following format: <name>-<version>-binary.sha1' do
      expect(foo_package.binary_sha1_filename).to eq 'foo-1.0-binary.sha1'
      expect(bar_package.binary_sha1_filename).to eq 'bar-2.0-binary.sha1'
    end
  end

  describe '#temporary_archive_path' do
    context 'when @source_install is false' do
      before do
        foo_package.instance_variable_set :@source_install, false
        bar_package.instance_variable_set :@source_install, false
      end

      it 'returns the temporary pre-compiled binary archive path' do
        expect(foo_package.temporary_archive_path).to be_a Pathname
        expect(bar_package.temporary_archive_path).to be_a Pathname
        expect(foo_package.temporary_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/foo-1.0-binary.tar.gz"
        expect(bar_package.temporary_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/bar-2.0-binary.tar.gz"
      end
    end

    context 'when @source_install is true' do
      before do
        foo_package.instance_variable_set :@source_install, true
        bar_package.instance_variable_set :@source_install, true
      end

      it 'returns the temporary source code archive path' do
        expect(foo_package.temporary_archive_path).to be_a Pathname
        expect(bar_package.temporary_archive_path).to be_a Pathname
        expect(foo_package.temporary_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/foo-1.0.tar.gz"
        expect(bar_package.temporary_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/bar-2.0.zip"
      end
    end
  end

  describe '#archive_path' do
    context 'when @source_install is false' do
      before do
        foo_package.instance_variable_set :@source_install, false
        bar_package.instance_variable_set :@source_install, false
      end

      it 'returns the name of the pre-compiled binary archive under the archives path' do
        expect(foo_package.archive_path).to be_a Pathname
        expect(bar_package.archive_path).to be_a Pathname
        expect(foo_package.archive_path.to_s).to eq "#{Autoparts::Path.archives}/foo-1.0-binary.tar.gz"
        expect(bar_package.archive_path.to_s).to eq "#{Autoparts::Path.archives}/bar-2.0-binary.tar.gz"
      end
    end

    context 'when @source_install is true' do
      before do
        foo_package.instance_variable_set :@source_install, true
        bar_package.instance_variable_set :@source_install, true
      end

      it 'returns the name of the source archive under the archives path' do
        expect(foo_package.archive_path).to be_a Pathname
        expect(bar_package.archive_path).to be_a Pathname
        expect(foo_package.archive_path.to_s).to eq "#{Autoparts::Path.archives}/foo-1.0.tar.gz"
        expect(bar_package.archive_path.to_s).to eq "#{Autoparts::Path.archives}/bar-2.0.zip"
      end
    end
  end

  describe 'binary_sha1_path' do
    it 'generates a temp path for the binary SHA1 in the following format: <tmp path>/<name>-<version>-binary.sha1' do
      expect(foo_package.binary_sha1_path).to be_a Pathname
      expect(bar_package.binary_sha1_path).to be_a Pathname

      expect(foo_package.binary_sha1_path.to_s).to eq "#{Autoparts::Path.tmp}/foo-1.0-binary.sha1"
      expect(bar_package.binary_sha1_path.to_s).to eq "#{Autoparts::Path.tmp}/bar-2.0-binary.sha1"
    end
  end

  describe '#extracted_archive_path' do
    it 'generates a temp path for the extracted archive in the following format: <tmp path>/<name>-<version>' do
      expect(foo_package.extracted_archive_path).to be_a Pathname
      expect(bar_package.extracted_archive_path).to be_a Pathname
      expect(foo_package.extracted_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/foo-1.0"
      expect(bar_package.extracted_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/bar-2.0"
    end
  end

  describe '#download' do
    let(:tmp_path) { (Autoparts::Path.tmp + 'foo.tar.gz.partsdownload') }

    before do
      @curl = receive(:system).with('curl', 'http://example.com/foo.tar.gz', '-L', '-o', tmp_path.to_s)
    end

    def do_action(sha1=nil)
      foo_package.download 'http://example.com/foo.tar.gz', Pathname.new('/a/b/foo.tar.gz'), sha1
    end

    context 'when download succeeds' do
      before do
        expect(foo_package).to @curl.and_return true
      end

      context 'when sha1 is not given' do
        it 'moves the downloaded file to the "to" path' do
          expect(foo_package).to receive(:system).with('mv', tmp_path.to_s, '/a/b/foo.tar.gz').and_return true
          do_action
        end
      end

      context 'when sha1 is given' do
        context 'when sha1 verification succeeds' do
          before { Autoparts::Util.stub(:sha1).with(tmp_path).and_return 'dadadadadadadadadadadadadadadadadadadada' }

          it 'moves the downloaded file to the "to" path' do
            expect(foo_package).to receive(:system).with('mv', tmp_path.to_s, '/a/b/foo.tar.gz').and_return true
            do_action 'dadadadadadadadadadadadadadadadadadadada'
          end
        end

        context 'when sha1 verification fails' do
          before { Autoparts::Util.stub(:sha1).with(tmp_path).and_return 'babababababababababababababababababababa' }

          it 'raises error and does not move the downloaded file to the "to" path' do
            expect(foo_package).not_to receive(:system).with('mv', tmp_path, '/a/b/foo.tar.gz')
            expect {
              do_action 'dadadadadadadadadadadadadadadadadadadada'
            }.to raise_error Autoparts::VerificationFailedError
          end
        end
      end
    end

    context 'when download fails' do
      before do
        expect(foo_package).to @curl.and_return false
      end

      it 'raises error and does not move the downloaded file to the "to" path' do
        expect(foo_package).not_to receive(:system).with('mv', tmp_path, '/a/b/foo.tar.gz')
        expect {
          do_action
        }.to raise_error Autoparts::ExecutionFailedError
      end
    end
  end

  describe '#binary_sha1' do
    context 'binary is not present' do
      before do
        foo_package.stub(:binary_present?) { false }
      end

      it 'should raise error' do
        expect {
          foo_package.binary_sha1
        }.to raise_error Autoparts::BinaryNotPresentError
      end
    end

    context 'binary is present' do
      before do
        foo_package.stub(:binary_present?) { true }
        File.open(foo_package.binary_sha1_path.to_s, 'w') { |f| f.puts('dadadadadada') }
      end

      it 'should download the SHA1' do
        expect(foo_package).to receive(:download).with(foo_package.binary_sha1_url, foo_package.binary_sha1_path)
        expect(foo_package.binary_sha1).to eq 'dadadadadada'
      end
    end
  end

  describe '#binary_present?' do
    context 'one of the binary URLs is present and the other is not' do
      before do
        foo_package.should_receive(:remote_file_exists?).exactly(2).times.and_return(true, false)
      end

      it 'should return false' do
        expect(foo_package.binary_present?).to be_false
        # since the call is memoized, calling it again will not break the spec
        # since remote_file_exists? will only be called twice
        expect(foo_package.binary_present?).to be_false
      end
    end

    context 'both the binary URLs are present' do
      before do
        foo_package.should_receive(:remote_file_exists?).exactly(2).times.and_return(true, true)
      end

      it 'should return false' do
        expect(foo_package.binary_present?).to be_true
        # since the call is memoized, calling it again will not break the spec
        # since remote_file_exists? will only be called twice
        expect(foo_package.binary_present?).to be_true
      end
    end
  end

  describe '#remote_file_exists?' do
    before do
      @curl = receive(:`).with('curl -IsL -w "%{http_code}" \'http://example.com/foo.tar.gz\' -o /dev/null 2> /dev/null')
    end

    context 'file exists' do
      before do
        expect(foo_package).to @curl.and_return '200'
      end

      it 'should return true' do
        expect(foo_package.remote_file_exists?('http://example.com/foo.tar.gz')).to be_true
      end
    end

    context 'file does not exist' do
      before do
        expect(foo_package).to @curl.and_return '403'
      end

      it 'should return false' do
        expect(foo_package.remote_file_exists?('http://example.com/foo.tar.gz')).to be_false
      end
    end
  end

  describe '#download_archive' do
    context 'when @source_install is true' do
      before do
        foo_package.instance_variable_set :@source_install, true
        bar_package.instance_variable_set :@source_install, true
      end

      it 'downloads source_url, with source_sha1 onto archive_url' do
        expect(foo_package).to receive(:download).with(foo_package.source_url, foo_package.archive_path, foo_package.source_sha1)
        foo_package.download_archive
      end
    end

    context 'when @source_install is false' do
      before do
        foo_package.instance_variable_set :@source_install, false
        bar_package.instance_variable_set :@source_install, false

        foo_package.stub(:binary_sha1) { 'dadadadadada' }
      end

      it 'downloads binary_url, with binary_sha1 onto archive_url' do
        expect(foo_package).to receive(:download).with(foo_package.binary_url, foo_package.archive_path, foo_package.binary_sha1)
        foo_package.download_archive
      end
    end
  end

  describe '#extract_archive' do
    context 'when @source_install is false' do
      before { foo_package.instance_variable_set :@source_install, false }

      it 'untars the precompiled binary archive' do
        expect(Dir).to receive(:chdir).with(foo_package.extracted_archive_path).and_yield
        expect(foo_package).to receive(:system).with('tar', 'xf', foo_package.archive_path.to_s).and_return true
        foo_package.extract_archive
      end
    end

    context 'when @source_install is true' do
      before { foo_package.instance_variable_set :@source_install, true }

      %w(tar tar.gz tar.bz2 tar.bz tgz tbz2 tbz).each do |t|
        context "when source_filetype is #{t}" do
          before do
            FooPackage.source_filetype t
          end

          it 'untars the source code archive' do
            expect(Dir).to receive(:chdir).with(foo_package.extracted_archive_path).and_yield
            expect(foo_package).to receive(:system).with('tar', 'xf', foo_package.archive_path.to_s).and_return true
            foo_package.extract_archive
          end
        end
      end

      context "when source_filetype is zip" do
        before do
          FooPackage.source_filetype 'zip'
        end

        it 'unzips the source code archive' do
          expect(Dir).to receive(:chdir).with(foo_package.extracted_archive_path).and_yield
          expect(foo_package).to receive(:system).with('unzip', '-qq', foo_package.archive_path.to_s).and_return true
          foo_package.extract_archive
        end
      end
    end
  end

  describe 'symlink business' do
    before do
      FileUtils.mkdir_p '/tmp/from/foo/bar'
      FileUtils.mkdir_p '/tmp/from/boo'
      FileUtils.touch '/tmp/from/aaa'
      FileUtils.touch '/tmp/from/bbb'
      FileUtils.touch '/tmp/from/foo/ccc'
      FileUtils.touch '/tmp/from/foo/bar/ddd'
      FileUtils.touch '/tmp/from/boo/eee'
      FileUtils.ln_s '/tmp/from/foo', '/tmp/from/baz'

      FileUtils.mkdir_p '/tmp/to'
      FileUtils.touch '/tmp/to/bbb'  # pre-existing file

      Pathname.new('/tmp/from/aaa').chmod 0755
      Pathname.new('/tmp/from/bbb').chmod 0644
      Pathname.new('/tmp/from/foo/ccc').chmod 0644
      Pathname.new('/tmp/from/foo/bar/ddd').chmod 0755
      Pathname.new('/tmp/from/boo/eee').chmod 0755
    end

    describe '#symlink_recursively' do
      it 'recursively creates symlinks of all files and directories under a given directory' do
        foo_package.symlink_recursively Pathname.new('/tmp/from'), Pathname.new('/tmp/to')
        expect(Pathname.new('/tmp/to/aaa').realpath.to_s).to eq '/tmp/from/aaa'
        expect(Pathname.new('/tmp/to/bbb').realpath.to_s).to eq '/tmp/from/bbb'
        expect(Pathname.new('/tmp/to/foo/ccc').realpath.to_s).to eq '/tmp/from/foo/ccc'
        expect(Pathname.new('/tmp/to/foo/bar/ddd').realpath.to_s).to eq '/tmp/from/foo/bar/ddd'
        expect(Pathname.new('/tmp/to/boo/eee').realpath.to_s).to eq '/tmp/from/boo/eee'
        expect(Pathname.new('/tmp/to/baz').realpath.to_s).to eq '/tmp/from/baz'
      end

      context 'when only_executables option is false' do
        it 'recursively creates symlinks of all files and directories under a given directory' do
          foo_package.symlink_recursively Pathname.new('/tmp/from'), Pathname.new('/tmp/to'), only_executables: false
          expect(Pathname.new('/tmp/to/aaa').realpath.to_s).to eq '/tmp/from/aaa'
          expect(Pathname.new('/tmp/to/bbb').realpath.to_s).to eq '/tmp/from/bbb'
          expect(Pathname.new('/tmp/to/foo/ccc').realpath.to_s).to eq '/tmp/from/foo/ccc'
          expect(Pathname.new('/tmp/to/foo/bar/ddd').realpath.to_s).to eq '/tmp/from/foo/bar/ddd'
          expect(Pathname.new('/tmp/to/boo/eee').realpath.to_s).to eq '/tmp/from/boo/eee'
          expect(Pathname.new('/tmp/to/baz').realpath.to_s).to eq '/tmp/from/baz'
        end
      end

      context 'when only_executables option is true' do
        it 'recursively creates symlinks of all executable files and directories under a given directory' do
          foo_package.symlink_recursively Pathname.new('/tmp/from'), Pathname.new('/tmp/to'), only_executables: true
          expect(Pathname.new('/tmp/to/aaa').realpath.to_s).to eq '/tmp/from/aaa'
          expect(Pathname.new('/tmp/to/bbb')).not_to be_symlink
          expect(Pathname.new('/tmp/to/foo/ccc')).not_to exist
          expect(Pathname.new('/tmp/to/foo/bar/ddd').realpath.to_s).to eq '/tmp/from/foo/bar/ddd'
          expect(Pathname.new('/tmp/to/boo/eee').realpath.to_s).to eq '/tmp/from/boo/eee'
          expect(Pathname.new('/tmp/to/baz').realpath.to_s).to eq '/tmp/from/baz'
        end
      end
    end

    describe '#unsymlink_recursively' do
      before do
        FileUtils.mkdir_p '/tmp/to/foo/bar'
        FileUtils.mkdir_p '/tmp/to/boo'
        #FileUtils.touch '/tmp/to/aaa'    # - missing symlink
        FileUtils.touch '/tmp/to/bbb'
        FileUtils.touch '/tmp/to/foo/ccc'
        FileUtils.touch '/tmp/to/foo/bar/ddd'
        FileUtils.touch '/tmp/to/boo/eee'
        FileUtils.touch '/tmp/to/boo/fff' # - extra file
        FileUtils.touch '/tmp/to/baz'
      end

      it 'recursively removes symlinks' do
        foo_package.unsymlink_recursively Pathname.new('/tmp/from'), Pathname.new('/tmp/to')
        expect(Pathname.new '/tmp/to/bbb').not_to exist
        expect(Pathname.new '/tmp/to/foo/ccc').not_to exist
        expect(Pathname.new '/tmp/to/foo/bar/ddd').not_to exist
        expect(Pathname.new '/tmp/to/foo/bar').not_to exist
        expect(Pathname.new '/tmp/to/foo').not_to exist
        expect(Pathname.new '/tmp/to/boo/eee').not_to exist
        expect(Pathname.new '/tmp/to/boo/fff').to exist # extra file
        expect(Pathname.new '/tmp/to/boo').to exist # because boo/fff still exists
        expect(Pathname.new '/tmp/to/baz').not_to exist
        expect(Pathname.new '/tmp/to').to exist # because boo still exists
      end
    end
  end

  describe '#call_web_hook' do
    before do
      FileUtils.mkdir_p(Pathname.new(Autoparts::Package::BOX_ID_PATH).dirname.to_s)
      File.open(Autoparts::Package::BOX_ID_PATH, 'w') { |f| f.puts('42') }

      Autoparts::Commands::Help.stub(:version) { 'Autoparts 1.0.0-abcd' }
    end

    it 'calls the endpoint with the action, name, version, box id and autoparts version' do
      uri = URI.parse(Autoparts::Package::WEB_HOOK_URL)
      stub_request(:post, uri.host)

      foo_package.call_web_hook :installed

      expect(a_request(:post, Autoparts::Package::WEB_HOOK_URL).with(
        query: {
          'type' => 'installed',
          'part_name' => 'foo',
          'part_version' => '1.0',
          'box_id' => '42',
          'autoparts_version' => 'Autoparts 1.0.0-abcd'
        }
      ))
    end

    context 'when calling the endpoint raises an exception' do
      it 'fails silently, allowing the command to exit without an error status' do
        allow_any_instance_of(Net::HTTP::Post).to receive(:new).and_raise('an error')
        expect(foo_package.call_web_hook(:installed)).to be_nil
      end
    end

    context 'when box id file does not exist' do
      before do
        File.stub(:exist?).with(Autoparts::Package::BOX_ID_PATH) { false }
        File.stub(:read).with(Autoparts::Package::BOX_ID_PATH).and_raise('Cannot read file')
      end

      it 'should not call the endpoint' do
        expect_any_instance_of(Net::HTTP).to_not receive(:request)
        foo_package.call_web_hook :installed
      end
    end
  end
end
