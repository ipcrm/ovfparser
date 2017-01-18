#!/usr/bin/env ruby
require 'nokogiri'
require 'trollop'

# Get Args
opts = Trollop::options do
  opt :filename, 'OVF File to process', :type => :string
  opt :newovfname, 'New OVF Filename', :type => :string
  opt :product, 'OVF Product String', :type => :string
  opt :vendor, 'OVF Vendor String', :type => :string
  opt :ovfversion, 'OVF Version String', :type => :string
  opt :producturl, 'OVF ProductURL String', :type => :string
  opt :vendorurl, 'OVF VendorURL String', :type => :string
end

Trollop::die :filename, "must be supplied" unless not opts[:filename].nil?
Trollop::die :newovfname, "must be supplied" unless not opts[:newovfname].nil?
Trollop::die :product, "must be supplied" unless not opts[:product].nil?
Trollop::die :vendor, "must be supplied" unless not opts[:vendor].nil?
Trollop::die :ovfversion, "must be supplied" unless not opts[:ovfversion].nil?
Trollop::die :producturl, "must be supplied" unless not opts[:producturl].nil?
Trollop::die :vendorurl, "must be supplied" unless not opts[:vendorurl].nil?

xml_file = File.open(opts[:filename])
doc = Nokogiri::XML(xml_file)

Nokogiri::XML::Builder.with(doc.at('VirtualSystem')) do |xml|
  xml.ProductSection {
    xml.Info("Meta-information about the installed software")
    xml.Product(opts[:product])
    xml.Vendor(opts[:vendor])
    xml.Version(opts[:version])
    xml.ProductUrl(opts[:producturl])
    xml.VendorUrl(opts[:vendorurl])
  }
end

f = File.open(opts[:newovfname],'w+')
doc.write_to(f,:indent => 5, :encoding => 'UTF-8')
