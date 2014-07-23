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
      :scriptalias     => '/usr/lib/cgi-bin/',
      :custom_fragment => 'SetHandler fcgid-script'
    ) }
  end

  describe 'when apache vhost is not managed' do
    let(:params) { { :manage_vhost => false } }

    it { should_not contain_class('apache') }
    it { should_not contain_class('apache::mod::fcgid') }
    it { should_not contain_apache__vhost('mapserver') }
  end

  describe 'when sources are managed' do
    let(:params) { { :manage_sources => true } }

    it { should contain_class('apt') }
    it { should contain_apt__source('ubuntugis-ppa').with(
      :repos      => 'main',
      :key        => '314DF160',
      :key_server => 'keyserver.ubuntu.com'
    )}
  end

  describe 'when stable sources are managed' do
    let(:params) { { 
      :manage_sources => true,
      :source => 'stable' 
    } }

    it { should contain_apt__source('ubuntugis-ppa').with(
      :location => 'http://ppa.launchpad.net/ubuntugis/ppa/ubuntu'
    )}
  end

  describe 'when unstable sources are managed' do
    let(:params) { { 
      :manage_sources => true,
      :source => 'unstable' 
    } }

    it { should contain_apt__source('ubuntugis-ppa').with(
      :location => 'http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu'
    )}
  end

  describe 'when sources are not managed' do
    let(:params) { { :manage_sources => false } }

    it { should_not contain_class('apt') }
    it { should_not contain_apt__source('ubuntugis-ppa') }
  end
end
