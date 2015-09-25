# == Define: mapserver::vhost
#
# Defines an apache vhost which hosts all the MapFile files as mapping 
# endpoints. Essentially, if you create a mapfile named 'test.map' inside
# $docroot then this can be accessed as /test?REQUEST=GetCapabilities&SERVICE=wms
#
# In addition to hosting these map files the standard mapserver cgi will be 
# exposed at /cgi-bin/mapserv
#
# [*port*]      which this vhost should listen to
# [*docroot*]   the directory which contains your map files and hosted content
# [*extension*] of the map files, normally this will be .map
# [*servername*] of the apache vhost
#
# === Authors
# 
# - Christopher Johnson - cjohn@ceh.ac.uk
#
define mapserver::vhost (
  $port       = $mapserver::port,
  $docroot    = $mapserver::docroot,
  $extension  = $mapserver::extension,
  $servername = $mapserver::servername,
) {
  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['mapserver']) {
    fail('You must include the mapserver base class before defining a vhost')
  }

  include apache
  include apache::mod::fcgid

  apache::vhost { "mapserver-${name}":
    servername      => $servername,
    port            => $port,
    docroot         => ,
    scriptaliases   => [{
      alias => '/cgi-bin',
      path  => '/usr/lib/cgi-bin/',
    }],
    rewrites        => [{
      rewrite_cond => "${docroot}/%{REQUEST_FILENAME}${extension} -f",
      rewrite_rule => "^/(.*)$ /cgi-bin/mapserv?map=${docroot}/$1${extension} [QSA,L,NC,PT]"
    }],
    custom_fragment => 'SetHandler fcgid-script',
  }
}
