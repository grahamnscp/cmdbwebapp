#!/usr/bin/ruby

# Globals
$conn = Net::LDAP.new
$conn.host = "cmdb.example.co.uk"
$conn.port = "389"
$conn.auth "cn=Manager,dc=example,dc=co,dc=uk", "dirmanager-password"
$basedomain = "ou=Servers,dc=example,dc=co,dc=uk"
$domainname = "example.co.uk"
$cmdbapppath = "/var/www/cmdb/cgi-bin/"

# Form LOV
$lov_vcluster            = $cmdbapppath+"/values/lov_vcluster"
$lov_location            = $cmdbapppath+"/values/lov_location"
$lov_vdatacentre         = $cmdbapppath+"/values/lov_vdatacentre"
$lov_environment         = $cmdbapppath+"/values/lov_environment"
$lov_vesxhost            = $cmdbapppath+"/values/lov_vesxhost"
$lov_operatingsystem     = $cmdbapppath+"/values/lov_operatingsystem"
$lov_vsockets            = $cmdbapppath+"/values/lov_vsockets"
$lov_vcores              = $cmdbapppath+"/values/lov_vcores"
$lov_osversion           = $cmdbapppath+"/values/lov_osversion"
$lov_cobblerprofile      = $cmdbapppath+"/values/lov_cobblerprofile"
$lov_rhnactivationkey    = $cmdbapppath+"/values/lov_rhnactivationkey"
$lov_serverrole          = $cmdbapppath+"/values/lov_serverrole"
$lov_rhnbasechannel      = $cmdbapppath+"/values/lov_rhnbasechannel"
$lov_rhnchildchannel     = $cmdbapppath+"/values/lov_rhnchildchannel"
$lov_nameserver          = $cmdbapppath+"/values/lov_nameserver"
$lov_timeserver          = $cmdbapppath+"/values/lov_timeserver"

$lov_diskcn              = $cmdbapppath+"/values/lov_diskcn"
$lov_diskstoragelocation = $cmdbapppath+"/values/lov_diskstoragelocation"

$lov_niccn               = $cmdbapppath+"/values/lov_niccn"
$lov_nicbridge           = $cmdbapppath+"/values/lov_nicbridge"

