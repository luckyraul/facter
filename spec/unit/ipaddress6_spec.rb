#!/usr/bin/env ruby

$basedir = File.expand_path(File.dirname(__FILE__) + '/..')
require File.join($basedir, 'spec_helper')

require 'facter'

def ifconfig_fixture(filename)
  ifconfig = File.new(File.join($basedir, 'fixtures', 'ifconfig', filename)).read
end

describe "IPv6 address fact" do
  it "should return ipaddress6 information for Darwin" do
    Facter::Util::Resolution.stubs(:exec).with('uname -s').returns('Darwin')
    Facter::Util::Resolution.stubs(:exec).with('/sbin/ifconfig -a').
      returns(ifconfig_fixture('darwin_ifconfig_all_with_multiple_interfaces'))

    Facter.value(:ipaddress6).should == "2610:10:20:209:223:32ff:fed5:ee34"
  end

  it "should return ipaddress6 information for Linux" do
    Facter::Util::Resolution.stubs(:exec).with('uname -s').returns('Linux')
    Facter::Util::Resolution.stubs(:exec).with('/sbin/ifconfig').
      returns(ifconfig_fixture('linux_ifconfig_all_with_multiple_interfaces'))

    Facter.value(:ipaddress6).should == "2610:10:20:209:212:3fff:febe:2201"
  end

  it "should return ipaddress6 information for Solaris" do
    Facter::Util::Resolution.stubs(:exec).with('uname -s').returns('SunOS')
    Facter::Util::Resolution.stubs(:exec).with('/usr/sbin/ifconfig -a').
      returns(ifconfig_fixture('sunos_ifconfig_all_with_multiple_interfaces'))

    Facter.value(:ipaddress6).should == "2610:10:20:209:203:baff:fe27:a7c"
  end
end
