# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'spec_helper'

describe Autoparts::CLIParser do
  CLIParser = Autoparts::CLIParser

  it "does not freak out when there isn't any argument" do
    expect {
      CLIParser.new []
    }.not_to raise_error
  end

  it 'finds the first argument with no prefix (e.g. "-") and sets it as a command' do
    expect(CLIParser.new([]).command).to be_nil
    expect(CLIParser.new(['install']).command).to eq 'install'
    expect(CLIParser.new(['--source', 'install']).command).to eq 'install'
    expect(CLIParser.new(['update', 'mysql']).command).to eq 'update'
    expect(CLIParser.new(['-s', 'install', 'mysql']).command).to eq 'install'
  end

  it 'sets any other words with no prefix that come after the command as arguments' do
    expect(CLIParser.new([]).args).to eq []
    expect(CLIParser.new(['install']).args).to eq []
    expect(CLIParser.new(['install', 'mysql']).args).to eq ['mysql']
    expect(CLIParser.new(['install', 'mysql', 'postgresql']).args).to eq ['mysql', 'postgresql']
    expect(CLIParser.new(['install', '--source', 'mysql']).args).to eq ['mysql']
    expect(CLIParser.new(['install', 'mysql', '--source', 'postgresql']).args).to eq ['mysql', 'postgresql']
  end

  it 'sets arguments that start with a hyphen (") as options' do
    expect(CLIParser.new([]).options).to eq []
    expect(CLIParser.new(['install']).options).to eq []
    expect(CLIParser.new(['install', '--source']).options).to eq ['--source']
    expect(CLIParser.new(['install', '-f', '--source']).options).to eq ['-f', '--source']
    expect(CLIParser.new(['-f', 'install', '--source', 'mysql']).options).to eq ['-f', '--source']
  end
end
