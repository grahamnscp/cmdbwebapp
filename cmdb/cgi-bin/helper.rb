#!/usr/bin/ruby

# Includes
require 'rubygems'
require 'net/ldap'
require 'cgi'

require 'globals.rb'


def output_page_header
  file = File.new("html/header", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end

def output_page_header_list
  file = File.new("html/header_list", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end
def output_page_header_box
  file = File.new("html/header_box", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end

def output_page_footer
  file = File.new("html/footer", "r")
  while (line = file.gets)
    puts "#{line}"
  end
end


#
# Function: read_server_by_fqdn
#
def get_param_fqdn

  cgi = CGI.new
  params = cgi.params # hash with field-names and values
  fqdn = params['fqdn'].to_s

  return fqdn
end



#
# Function: read_server_by_fqdn
#
def read_server_by_fqdn(servername)

  filter = Net::LDAP::Filter.eq( "objectclass", "managedServer" )
  filter = Net::LDAP::Filter.eq( "hostName", servername )
  attrs = [ ]

  $conn.search(:base => $basedomain,
               :filter => filter) do |entry|
    server = entry

    return server
  end
end

#
# Function: read_disk_by_dn
#
def read_disk_by_dn(treebase, entry_number)

  filter = Net::LDAP::Filter.eq( "objectclass", "storageDevice" )
  filter = Net::LDAP::Filter.eq( "diskOrder", entry_number )
  attrs = [ ]

  $conn.search(:base => treebase,
               :filter => filter) do |entry|
    disk = entry

    return disk
  end
end

#
# Function: read_nic_by_dn
#
def read_nic_by_dn(treebase, entry_number)

  filter = Net::LDAP::Filter.eq( "objectclass", "networkInterface" )
  filter = Net::LDAP::Filter.eq( "nicOrder", entry_number )
  attrs = [ ]

  $conn.search(:base => treebase,
               :filter => filter) do |entry|
    nic = entry 

    return nic
  end
end

#
# Function: persistServerEntry
#
def persistServerEntry(dn, mansvr, disk, nic1, nic2)

  #p mansvr
  #puts "<br>"
  #p disk
  #puts "<br>"
  #p nic1
  #puts "<br>"
  #p nic2
  #puts "<br>"

  # If entry already exists, delete it first then add it.
  fqdn = mansvr[:hostName].to_s
  result = delete_entry_by_fqdn(fqdn)
  #puts "delete:" + result.to_s + "<br>"

  # Add LDAP Entries
  result = $conn.add(:dn => dn, :attributes => mansvr )
  #puts "add server:" + result.to_s + "<br>"

  result = $conn.add(:dn => "cn="+disk[:cn].to_s+","+dn, :attributes => disk )
  #puts "add disk:" + result.to_s + "<br>"

  result = $conn.add(:dn => "cn="+nic1[:cn].to_s+","+dn, :attributes => nic1 )
  #puts "add nic1:" + result.to_s + "<br>"

  result = $conn.add(:dn => "cn="+nic2[:cn].to_s+","+dn, :attributes => nic2 )
  #puts "add nic2:" + result.to_s + "<br>"

  return result
end


#
# function: delete_entry_by_fqdn
#
def delete_entry_by_fqdn(fqdn)

  cn=fqdn.split(".").first
  basedn = "cn=" + cn + "," + $basedomain
  #puts "Deleting basedn: "+basedn+"<br>"

  # Need to delete children first if they exist
  filter = Net::LDAP::Filter.eq( "objectclass", "storageDevice" )
  $conn.search(:base => basedn,
               :filter => filter) do |diskentry|
    subdn = diskentry['dn'].to_s
    result = $conn.delete(:dn => subdn)
    #puts "<blockquote>dn: "+subdn +" -> "+result.to_s+"</blockquote>"
  end
  filter = Net::LDAP::Filter.eq( "objectclass", "networkInterface" )
  $conn.search(:base => basedn,
               :filter => filter) do |nicentry|
    subdn = nicentry['dn'].to_s
    result = $conn.delete(:dn => subdn)
    #puts "<blockquote>dn: "+subdn+" -> " +result.to_s+"</blockquote>"
  end

  result = $conn.delete(:dn => basedn)
  #puts "<blockquote>dn: "+basedn+" -> " +result.to_s+"</blockquote>"

  return result
end


