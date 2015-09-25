# == Class: mapserver
#
# Classifies a node to run mapserver
#
# === Parameters
# [*port*] The port number to run mapserver on
# [*docroot*] the directory which contains your map files and hosted content
# [*extension*] of the map files, normally this will be .map
# [*servername*] of the apache vhost
# [*gdal_version*] The version of the gdal suite to install
# [*cgi_mapserver_version*] The version of the cig mapserver application to install
# [*mapserver_bin_version*] The version of the mapserver bin to install
# [*manage_vhost*] if an apache vhost should be created hosting the cgi application
# [*ubuntugis*] The ubuntugis ppa source. Either undef, stable, unstable or a custom 
#   location. When custom sources are used, it is expected that the key and key_server
#   match that of the ubuntugis ppa. If this is not acceptable, you should manage the 
#   ppa yourself. An undef value, defaults to not managing ubuntugis
#
# === Authors
# 
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class mapserver (
  $port                  = '9000',
  $docroot               = '/var/www/mapserver',
  $extension             = 'map',
  $servername            = $::fqdn,
  $gdal_version          = present,
  $cgi_mapserver_version = present,
  $mapserver_bin_version = present,
  $manage_vhost          = true,
  $ubuntugis             = undef
) {
  if $manage_vhost {
    mapserver::vhost { 'default': }
  }

  if $ubuntugis {
    include apt
    $ppa_location = $ubuntugis ? {
      'stable'   => 'http://ppa.launchpad.net/ubuntugis/ppa/ubuntu',
      'unstable' => 'http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu',
      default    => $ubuntugis
    }

    ::apt::source { 'ubuntugis-ppa' :
      location   => $ppa_location,
      repos      => 'main',
      key        => '314DF160',
      key_server => 'keyserver.ubuntu.com',
      before     => Package['cgi-mapserver', 'mapserver-bin', 'gdal-bin'],
    }
  }

  package {'cgi-mapserver':
    ensure => $cgi_mapserver_version,
  }

  package {'mapserver-bin':
    ensure => $mapserver_bin_version,
  }

  package {'gdal-bin':
    ensure => $gdal_version,
  }
}
