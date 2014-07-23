# == Class: mapserver
#
# Classifies a node to run mapserver
#
# === Parameters
# [*port*] The port number to run mapserver on
# [*gdal_version*] The version of the gdal suite to install
# [*cgi_mapserver_version*] The version of the cig mapserver application to install
# [*mapserver_bin_version*] The version of the mapserver bin to install
# [*manage_sources*] if the apt::source for ubuntu gis should be managed
# [*manage_vhost*] if an apache vhost should be created hosting the cgi application
# [*source*] The ubuntugis ppa source. Either stable, unstable or a custom location.
#   when custom sources are used, it is expected that the key and key_server match that of
#   the ubuntugis ppa. If this is not acceptable, you should manage the ppa yourself
#
# === Authors
# 
# - Christopher Johnson - cjohn@ceh.ac.uk
#
class mapserver (
  $port                  = '9000',
  $gdal_version          = present,
  $cgi_mapserver_version = present,
  $mapserver_bin_version = present,
  $manage_sources        = true,
  $manage_vhost          = true,
  $source                = stable
) {
  if $manage_vhost {
    include apache
    include apache::mod::fcgid

    apache::vhost { 'mapserver':
      servername      => $fqdn,
      port            => $port,
      docroot         => '/var/www/mapserver',
      scriptalias     => '/usr/lib/cgi-bin/',
      custom_fragment => 'SetHandler fcgid-script',
    }
  }

  if $manage_sources {
    include apt
    $ppa_location = $source ? {
      'stable'   => 'http://ppa.launchpad.net/ubuntugis/ppa/ubuntu',
      'unstable' => 'http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu',
      default    => $source
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