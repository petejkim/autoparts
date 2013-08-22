require 'spec_helper'
require 'fileutils'

class FooPackage < Autoparts::Package
  name 'foo'
  version '1.0'
  source_url 'http://example.com/foo.tar.gz'
  source_sha1 'f00f00f00f00f00f00f00f00f00f00f00f00f00f'
  source_type 'tar.gz'
end

class BarPackage < Autoparts::Package
  name 'bar'
  version '2.0'
  source_url 'http://example.com/bar.zip'
  source_sha1 'babababababababababababababababababababa'
  source_type 'zip'
end

describe Autoparts::Package do
  let(:foo_package) { FooPackage.new }
  let(:bar_package) { BarPackage.new }

  before do
    foo_package.stub(:system)
    bar_package.stub(:system)
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

  describe '#source_type' do
    it 'returns the file type for the source code archive set using the DSL keyword "source_filetype"' do
      expect(foo_package.source_type).to eq 'tar.gz'
      expect(bar_package.source_type).to eq 'zip'
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
      expect(foo_package.prefix_path.to_s).to eq "#{Autoparts::PACKAGES_PATH}/foo/1.0"
      expect(bar_package.prefix_path.to_s).to eq "#{Autoparts::PACKAGES_PATH}/bar/2.0"
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

  describe '#source_filename' do
    it 'generates a filename for the source code in the following format: <name>-<version>.<source_type>' do
      expect(foo_package.source_filename).to eq "foo-1.0.tar.gz"
      expect(bar_package.source_filename).to eq "bar-2.0.zip"
    end
  end

  describe '#download_path' do
    it 'returns the temporary download path' do
      expect(foo_package.download_path).to be_a Pathname
      expect(bar_package.download_path).to be_a Pathname
      expect(foo_package.download_path.to_s).to eq "#{Autoparts::TMP_PATH}/foo-1.0.tar.gz"
      expect(bar_package.download_path.to_s).to eq "#{Autoparts::TMP_PATH}/bar-2.0.zip"
    end
  end

  describe '#source_path' do
    it 'returns the source filename under the ARCHIVES_PATH' do
      expect(foo_package.source_path).to be_a Pathname
      expect(bar_package.source_path).to be_a Pathname
      expect(foo_package.source_path.to_s).to eq "#{Autoparts::ARCHIVES_PATH}/foo-1.0.tar.gz"
      expect(bar_package.source_path.to_s).to eq "#{Autoparts::ARCHIVES_PATH}/bar-2.0.zip"
    end
  end

  describe '#extracted_source_path' do
    it 'generates a temp path for the source code in the following format: TMP_PATH/<name>-<version>' do
      expect(foo_package.extracted_source_path).to be_a Pathname
      expect(bar_package.extracted_source_path).to be_a Pathname
      expect(foo_package.extracted_source_path.to_s).to eq "#{Autoparts::TMP_PATH}/foo-1.0"
      expect(bar_package.extracted_source_path.to_s).to eq "#{Autoparts::TMP_PATH}/bar-2.0"
    end
  end

  describe '#download_source' do
    context 'when download to TMP_PATH completes' do
      it 'makes sure that ARCHIVES_PATH directory exists then moves the downloaded file to source_path' do
        expect(foo_package).to receive(:system).with("curl http://example.com/foo.tar.gz -L -o #{foo_package.download_path}").and_return true
        expect(foo_package).to receive(:system).with("mv #{foo_package.download_path} #{foo_package.source_path}").and_return true
        expect(File.directory?(Autoparts::ARCHIVES_PATH)).to be_false
        foo_package.download_source
        expect(File.directory?(Autoparts::ARCHIVES_PATH)).to be_true
      end
    end

    context 'when download to TMP_PATH fails' do
      it 'does not move the downloaded file to source_path' do
        expect(foo_package).to receive(:system).with("curl http://example.com/foo.tar.gz -L -o #{foo_package.download_path}").and_return false
        expect(foo_package).not_to receive(:system).with("mv #{foo_package.download_path} #{foo_package.source_path}")
        expect {
          foo_package.download_source
        }.to raise_error
      end
    end
  end

  describe '#verify_source' do
    context 'when sha1 verification succeeds' do
      before do
        foo_package.stub(:`).with("shasum -p #{foo_package.source_path}").and_return "f00f00f00f00f00f00f00f00f00f00f00f00f00f ?foo-1.0.tar.gz\n"
      end

      it 'does not raise any error' do
        expect {
          foo_package.verify_source
        }.not_to raise_error
      end
    end

    context 'when sha1 verification fails' do
      before do
        foo_package.stub(:`).with("shasum -p #{foo_package.source_path}").and_return "f00f00f00f00f00f00f00f00f00f00f00f00f000 ?foo-2.0.tar.gz\n"
      end

      it 'raises VerificationFailedError' do
        expect {
          foo_package.verify_source
        }.to raise_error Autoparts::VerificationFailedError
      end
    end
  end

  describe '#extract_source' do
    %w(tar tar.gz tar.bz2 tar.bz tgz tbz2 tbz).each do |t|
      context "when source_type is #{t}" do
        before do
          FooPackage.source_type t
        end

        it 'makes sure that TMP_PATH directory exists and then untars the package' do
          expect(foo_package).to receive(:system).with("tar xf #{foo_package.source_path} -C #{foo_package.extracted_source_path}").and_return true
          expect(File.exists?(foo_package.extracted_source_path)).to be_false
          foo_package.extract_source
          expect(File.directory?(foo_package.extracted_source_path)).to be_true
        end
      end
    end

    context "when source_type is zip" do
      before do
        FooPackage.source_type 'zip'
      end

      it 'makes sure that TMP_PATH directory exists and then unzips the package' do
        expect(foo_package).to receive(:system).with("unzip -qq #{foo_package.source_path} -d #{foo_package.extracted_source_path}").and_return true
        expect(File.exists?(foo_package.extracted_source_path)).to be_false
        foo_package.extract_source
        expect(File.directory?(foo_package.extracted_source_path)).to be_true
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
