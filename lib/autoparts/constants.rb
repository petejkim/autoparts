require 'pathname'

module Autoparts
  INSTALL_PATH = Pathname.new File.expand_path('../../../..', __FILE__)
  PACKAGES_PATH = INSTALL_PATH + 'packages'
  ARCHIVES_PATH = INSTALL_PATH + 'archives'
  BIN_PATH  = INSTALL_PATH + 'bin'
  ETC_PATH = INSTALL_PATH + 'etc'
  INCLUDE_PATH = INSTALL_PATH + 'include'
  LIB_PATH = INSTALL_PATH + 'lib'
  SBIN_PATH = INSTALL_PATH + 'sbin'
  SHARE_PATH = INSTALL_PATH + 'share'
  TMP_PATH = INSTALL_PATH + 'tmp'
  VAR_PATH = INSTALL_PATH + 'var'
end
