require 'spec_helper'
require 'fileutils'

class FooPackage < Autoparts::Package
  name 'foo'
  version '1.0'
  source_url 'http://example.com/foo.tar.gz'
  source_sha1 'f00f00f00f00f00f00f00f00f00f00f00f00f00f'
  source_filetype 'tar.gz'
  binary_url 'http://example.com/foo-precompiled.tar.gz'
  binary_sha1 'dadadadadadadadadadadadadadadadadadadada'
end

class BarPackage < Autoparts::Package
  name 'bar'
  version '2.0'
  source_url 'http://example.com/bar.zip'
  source_sha1 'babababababababababababababababababababa'
  source_filetype 'zip'
  binary_url 'http://example.com/bar-precompiled.tar.gz'
  binary_sha1 'd00d00d00d00d00d00d00d00d00d00d00d00d00d'
end

describe Autoparts::Package do
  let(:foo_package) { FooPackage.new }
  let(:bar_package) { BarPackage.new }

  before do
    foo_package.stub(:system)
    bar_package.stub(:system)
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

  describe '.find' do
    it 'finds a package class by name' do
      expect(described_class.find('foo')).to eq FooPackage
      expect(described_class.find('bar')).to eq BarPackage
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
      expect(foo_package.binary_url).to eq 'http://example.com/foo-precompiled.tar.gz'
      expect(bar_package.binary_url).to eq 'http://example.com/bar-precompiled.tar.gz'
    end
  end

  describe '#binary_sha1' do
    it 'returns the url for the precompiled binary archive set using the DSL keyword "binary_sha1"' do
      expect(foo_package.binary_sha1).to eq 'dadadadadadadadadadadadadadadadadadadada'
      expect(bar_package.binary_sha1).to eq 'd00d00d00d00d00d00d00d00d00d00d00d00d00d'
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
        expect(foo_package).to receive(:system).with('echo hello world').and_return true
        expect {
          foo_package.execute 'echo', 'hello', 'world'
        }.not_to raise_error
      end
    end

    context 'when command fails' do
      it 'raises ExecutionFailedError' do
        expect(foo_package).to receive(:system).with('echo foo').and_return false
        expect {
          foo_package.execute 'echo', 'foo'
        }.to raise_error Autoparts::ExecutionFailedError, '"echo foo" failed'
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

  describe '#extracted_archive_path' do
    it 'generates a temp path for the extracted archive in the following format: <tmp path>/<name>-<version>' do
      expect(foo_package.extracted_archive_path).to be_a Pathname
      expect(bar_package.extracted_archive_path).to be_a Pathname
      expect(foo_package.extracted_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/foo-1.0"
      expect(bar_package.extracted_archive_path.to_s).to eq "#{Autoparts::Path.tmp}/bar-2.0"
    end
  end

  describe '#download_archive' do
    context 'when @source_install is false' do
      before do
        foo_package.instance_variable_set :@source_install, false
        bar_package.instance_variable_set :@source_install, false
      end

      context 'when downloading source code archive to tmp path completes' do
        it 'moves the downloaded file to archive path' do
          expect(foo_package).to receive(:system).with("curl http://example.com/foo-precompiled.tar.gz -L -o #{foo_package.temporary_archive_path}").and_return true
          expect(foo_package).to receive(:system).with("mv #{foo_package.temporary_archive_path} #{foo_package.archive_path}").and_return true
          foo_package.download_archive
        end
      end

      context 'when downloading source code archive fails' do
        it 'does not move the downloaded file to archive path' do
          expect(foo_package).to receive(:system).with("curl http://example.com/foo-precompiled.tar.gz -L -o #{foo_package.temporary_archive_path}").and_return false
          expect(foo_package).not_to receive(:system).with("mv #{foo_package.temporary_archive_path} #{foo_package.archive_path}")
          expect {
            foo_package.download_archive
          }.to raise_error
        end
      end
    end

    context 'when @source_install is true' do
      before do
        foo_package.instance_variable_set :@source_install, true
        bar_package.instance_variable_set :@source_install, true
      end

      context 'when downloading pre-compiled binary archive to tmp path completes' do
        it 'moves the downloaded file to archive path' do
          expect(foo_package).to receive(:system).with("curl http://example.com/foo.tar.gz -L -o #{foo_package.temporary_archive_path}").and_return true
          expect(foo_package).to receive(:system).with("mv #{foo_package.temporary_archive_path} #{foo_package.archive_path}").and_return true
          foo_package.download_archive
        end
      end

      context 'when downloading pre-compiled binary fails' do
        it 'does not move the downloaded file to archive path' do
          expect(foo_package).to receive(:system).with("curl http://example.com/foo.tar.gz -L -o #{foo_package.temporary_archive_path}").and_return false
          expect(foo_package).not_to receive(:system).with("mv #{foo_package.temporary_archive_path} #{foo_package.archive_path}")
          expect {
            foo_package.download_archive
          }.to raise_error
        end
      end
    end
  end

  describe '#verify_archive' do
    context 'when @source_install is false' do
      before { foo_package.instance_variable_set :@source_install, false }

      context 'when sha1 of the archive is the same as binary_sha1' do
        before do
          Autoparts::Util.stub(:sha1).with(foo_package.archive_path).and_return "dadadadadadadadadadadadadadadadadadadada"
        end

        it 'does not raise any error' do
          expect {
            foo_package.verify_archive
          }.not_to raise_error
        end
      end

      context 'when sha1 of the archive is different from binary_sha1' do
        before do
          Autoparts::Util.stub(:sha1).with(foo_package.archive_path).and_return "aaaaaaaaaaaaf00f00f00f00f00f00f00f00f00f"
        end

        it 'raises VerificationFailedError' do
          expect {
            foo_package.verify_archive
          }.to raise_error Autoparts::VerificationFailedError
        end
      end
    end

    context 'when @source_install is true' do
      before { foo_package.instance_variable_set :@source_install, true }

      context 'when sha1 of the archive is the same as source_sha1' do
        before do
          Autoparts::Util.stub(:sha1).with(foo_package.archive_path).and_return "f00f00f00f00f00f00f00f00f00f00f00f00f00f"
        end

        it 'does not raise any error' do
          expect {
            foo_package.verify_archive
          }.not_to raise_error
        end
      end

      context 'when sha1 of the archive is different from source_sha1' do
        before do
          Autoparts::Util.stub(:sha1).with(foo_package.archive_path).and_return "aaaaaaaaaaaaf00f00f00f00f00f00f00f00f00f"
        end

        it 'raises VerificationFailedError' do
          expect {
            foo_package.verify_archive
          }.to raise_error Autoparts::VerificationFailedError
        end
      end
    end
  end

  describe '#extract_archive' do
    context 'when @source_install is false' do
      before { foo_package.instance_variable_set :@source_install, false }

      it 'untars the precompiled binary archive' do
        expect(Dir).to receive(:chdir).with(foo_package.extracted_archive_path).and_yield
        expect(foo_package).to receive(:system).with("tar xf #{foo_package.archive_path}").and_return true
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
            expect(foo_package).to receive(:system).with("tar xf #{foo_package.archive_path}").and_return true
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
          expect(foo_package).to receive(:system).with("unzip -qq #{foo_package.archive_path}").and_return true
          foo_package.extract_archive
        end
      end
    end
  end

  describe '#symlink_recursively' do
    before do
      FileUtils.mkdir_p '/tmp/from/foo/bar'
      FileUtils.touch '/tmp/from/aaa'
      FileUtils.touch '/tmp/from/bbb'
      FileUtils.touch '/tmp/from/foo/ccc'
      FileUtils.touch '/tmp/from/foo/bar/ddd'
      FileUtils.ln_s '/tmp/from/foo', '/tmp/from/baz'
    end

    it 'recursively creates symlinks of all files and directories under a given directory' do
      expect(foo_package).to receive(:system).with('ln -s /tmp/from/baz /tmp/to/baz').and_return true
      expect(foo_package).to receive(:system).with('ln -s /tmp/from/aaa /tmp/to/aaa').and_return true
      expect(foo_package).to receive(:system).with('ln -s /tmp/from/bbb /tmp/to/bbb').and_return true
      expect(foo_package).to receive(:system).with('ln -s /tmp/from/foo/ccc /tmp/to/foo/ccc').and_return true
      expect(foo_package).to receive(:system).with('ln -s /tmp/from/foo/bar/ddd /tmp/to/foo/bar/ddd').and_return true

      expect(Pathname.new('/tmp/to')).not_to exist
      foo_package.symlink_recursively Pathname.new('/tmp/from'), Pathname.new('/tmp/to')
      expect(Pathname.new('/tmp/to')).to be_directory
      expect(Pathname.new('/tmp/to/foo')).to be_directory
      expect(Pathname.new('/tmp/to/foo/bar')).to be_directory
    end
  end
end
