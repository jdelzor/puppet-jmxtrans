require 'spec_helper'

describe 'jmxtrans' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'jmxtrans class without any parameters' do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it { is_expected.not_to contain_package('jmxtrans') }
          it { is_expected.not_to contain_service('jmxtrans') }
        end

        context 'jmxtrans class with package name' do
          let(:params) do
            {
              package_name: 'jmxtrans',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it { is_expected.to contain_package('jmxtrans').with_ensure('present') }
          it { is_expected.not_to contain_service('jmxtrans') }
        end

        context 'jmxtrans class with service name' do
          let(:params) do
            {
              service_name: 'jmxtrans',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it { is_expected.not_to contain_package('jmxtrans') }
          it { is_expected.to contain_service('jmxtrans') }
        end

        context 'jmxtrans class with package and service name' do
          let(:params) do
            {
              package_name: 'jmxtrans',
              service_name: 'jmxtrans',
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it { is_expected.to contain_package('jmxtrans').with_ensure('present') }
          it { is_expected.to contain_service('jmxtrans') }
        end

        context 'jmxtrans class with manage_service_file true' do
          context 'with systemd' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end
            let(:params) do
              {
                manage_service_file: true,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service') }
          end

          context 'without systemd' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'initd',
              }
            end

            let(:params) do
              {
                manage_service_file: true,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/init.d/jmxtrans').with_content(%r{This file is originally from Java Service Wrapper 3.2.3 distribution}) }
          end
        end

        context 'jmxtrans class with manage_service_file false' do
          context 'with systemd' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end
            let(:params) do
              {
                manage_service_file: false,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.not_to contain_file('/etc/systemd/system/jmxtrans.service') }
          end

          context 'without systemd' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'initd',
              }
            end

            let(:params) do
              {
                manage_service_file: false,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.not_to contain_file('/etc/init.d/jmxtrans') }
          end
        end

        context 'jmxtrans class with systemd and service unit' do
          context 'no changes' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end
            let(:params) do
              {
                manage_service_file: true,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service') }
            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{ExecStart=/usr/share/jmxtrans/bin/jmxtrans}) }
            it { is_expected.not_to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{EnvironmentFile=/etc/default/jmxtrans}) }
            it { is_expected.not_to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{WorkingDirectory=/usr/share/jmxtrans}) }
          end

          context 'set environment file' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end
            let(:params) do
              {
                manage_service_file: true,
                systemd_environment_file: '/etc/default/jmxtrans',
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service') }
            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{EnvironmentFile=/etc/default/jmxtrans}) }
          end

          context 'set working directory' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end

            let(:params) do
              {
                manage_service_file: true,
             working_directory: '/usr/share/jmxtrans',
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service') }
            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{WorkingDirectory=/usr/share/jmxtrans}) }
          end

          context 'set working directory' do
            let(:facts) do
              {
                path: '/usr/local/sbin',
                service_provider: 'systemd',
              }
            end

            let(:params) do
              {
                manage_service_file: true,
             binary_path: '/usr/share/jmxtrans/bin/jmxtrans.sh',
              }
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service') }
            it { is_expected.to contain_file('/etc/systemd/system/jmxtrans.service').with_content(%r{ExecStart=/usr/share/jmxtrans/bin/jmxtrans.sh}) }
          end
        end

        context 'jmxtrans class with package provider' do
          let(:params) do
            {
              package_name: 'jmxtrans',
           service_name: 'jmxtrans',
           package_provider: 'gem'
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it do
            is_expected.to contain_package('jmxtrans').with({
                                                              'ensure' => 'present',
              'provider' => 'gem',
                                                            })
          end
          it { is_expected.to contain_service('jmxtrans') }
        end

        context 'jmxtrans class with package source' do
          let(:params) do
            {
              package_name: 'jmxtrans',
           service_name: 'jmxtrans',
           package_source: 'foo'
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it { is_expected.to contain_service('jmxtrans') }

          case facts[:osfamily]
          when 'Debian'
            it do
              is_expected.to contain_package('jmxtrans').with({
                                                                'ensure' => 'present',
                'source' => 'foo',
                'provider' => 'dpkg',
                                                              })
            end
          when 'RedHat'
            it do
              is_expected.to contain_package('jmxtrans').with(
                {
                  'ensure' => 'present',
                  'source' => 'foo',
                  'provider' => 'rpm',
                },
              )
            end
          end
        end

        context 'jmxtrans class with package version' do
          let(:params) do
            {
              package_name: 'jmxtrans',
           service_name: 'jmxtrans',
           package_version: '265'
            }
          end

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('jmxtrans::install') }
          it { is_expected.to contain_class('jmxtrans::service').that_subscribes_to('Class[jmxtrans::install]') }

          it do
            is_expected.to contain_package('jmxtrans').with({
                                                              'ensure' => '265',
                                                            })
          end
          it { is_expected.to contain_service('jmxtrans') }
        end
      end
    end
  end
end
