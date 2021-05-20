require 'spec_helper_acceptance'

describe 'jmxtrans class' do
  context 'minimum parameters' do
    # Using puppet_apply as a helper
    it 'works idempotently with no errors' do
      pp = <<-EOS
      case $facts['os']['family'] {
        'RedHat': {
          $package_name = 'jmxtrans'
          $service_name = 'jmxtrans'
          $package_source = 'https://repo1.maven.org/maven2/org/jmxtrans/jmxtrans/272/jmxtrans-272.rpm'
        }
        'Debian': {
          $package_name = 'jmxtrans'
          $service_name = 'jmxtrans'
          $package_source = 'https://repo1.maven.org/maven2/org/jmxtrans/jmxtrans/272/jmxtrans-272.deb'
        }
      }

      include java

      class { 'jmxtrans':
        package_name   => $package_name,
        service_name   => $service_name,
        package_source => $package_source,
        require        => Class['java'],
      }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe package('jmxtrans') do
      it { is_expected.to be_installed }
    end

    describe service('jmxtrans') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
