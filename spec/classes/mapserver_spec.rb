require 'spec_helper'

describe 'mapserver', :type => :class do   
  let(:facts) { { 
    :osfamily               => 'Debian',
    :operatingsystemrelease => '6',
    :lsbdistcodename        => 'precise',
    :lsbdistid              => 'Debian',
    :concat_basedir         => '/dne',
  } }

  describe 'when apache vhost is managed' do
    let(:params) { {
      :manage_vhost => true,
      :port         => '7000'
    } }
    
    it { should contain_class('apache')}
    it { should contain_class('apache::mod::fcgid')}

    it { should contain_apache__vhost('mapserver').with(
      :port            => '7000',
      :docroot         => '/var/www/mapserver',
      :scriptaliases   => [{
        :alias => '/cgi-bin',
        :path  => '/usr/lib/cgi-bin/'
      }],
      :custom_fragment => 'SetHandler fcgid-script'
    ) }
  end

  describe 'when apache vhost is not managed' do
    let(:params) { { :manage_vhost => false } }

    it { should_not contain_class('apache') }
    it { should_not contain_class('apache::mod::fcgid') }
    it { should_not contain_apache__vhost('mapserver') }
  end

  describe 'when stable ubuntugis is managed' do
    let(:params) { { 
      :ubuntugis => 'stable' 
    } }

    it { should contain_apt__source('ubuntugis-ppa').with(
      :location   => 'http://ppa.launchpad.net/ubuntugis/ppa/ubuntu',
      :repos      => 'main',
      :key        => {
        :id     => '6B827C12C2D425E227EDCA75089EBE08314DF160',
        :server => 'keyserver.ubuntu.com'
      }
    )}
  end

  describe 'when unstable ubuntugis is managed' do
    let(:params) { { 
      :ubuntugis => 'unstable' 
    } }

    it { should contain_apt__source('ubuntugis-ppa').with(
      :location   => 'http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu',
      :repos      => 'main',
      :key        => {
        :id     => '6B827C12C2D425E227EDCA75089EBE08314DF160',
        :server => 'keyserver.ubuntu.com'
      }
    )}
  end

  describe 'when ubuntugis is not managed' do
    let(:params) { { :ubuntugis => false } }

    it { should_not contain_class('apt') }
    it { should_not contain_apt__source('ubuntugis-ppa') }
  end
end
