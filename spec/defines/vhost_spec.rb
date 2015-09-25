require 'spec_helper'

describe 'mapserver::vhost', :type => :define do   
  let(:facts) { { 
    :osfamily               => 'Debian',
    :operatingsystemrelease => '6',
    :lsbdistcodename        => 'precise',
    :lsbdistid              => 'Debian',
    :concat_basedir         => '/dne',
  } }

  let :pre_condition do
    'class { "mapserver": manage_vhost => false}'
  end

  let(:title) {'name' }

  let(:params) {{
    :port       => '1234',
    :docroot    => '/var/maps',
    :extension  => '.maps',
    :servername => 'servername'
  }}

  it { should contain_apache__vhost('mapserver-name').with(
    :servername      => 'servername',
    :port            => '1234',
    :docroot         => '/var/maps',
    :scriptaliases   => [{
      :alias => '/cgi-bin',
      :path  => '/usr/lib/cgi-bin/'
    }],
    :rewrites        => [{
      :rewrite_cond => '/var/maps/%{REQUEST_FILENAME}.maps -f',
      :rewrite_rule => '^/(.*)$ /cgi-bin/mapserv?map=/var/maps/$1.maps [QSA,L,NC,PT]'
    }],
    :custom_fragment => 'SetHandler fcgid-script'
  ) }
end
