require_relative '../../../../spec_helper'

describe 'usermgmt', :type => :class do

  context 'with explicit data' do
    let(:params) {{
      :userhash => {
        'testuser' => { 'fullname' => 'Test User',
                        'email'    => 'test@test.test',
                        'ssh_pub_keys' => { 
                          'type' => 'ssh-rsa',
                          'key'  => 'testkey',
                        },
                        'groups' => 'testgroup',
                        'ssh_private_keys' => {
                          '/home/testuser/.ssh/test_private_key' => {
                            'content' => 'test-key',
                          }
                        },
                        'home_dir_files' => {
                          '/home/testuser/.special_test_file' => {
                            'content' => 'test test',
                          },
                        }
        }
      },
      :grouphash => {
        'testgroup' => {},
      }
    }}


  it { should contain_package('libshadow').with({ 'ensure' => 'present',  })}
  it { should contain_user('testuser').with({ 'ensure' => 'present',  })}
  it { should contain_group('testgroup').with({ 'ensure' => 'present',  })}
  it { should contain_file('/home/testuser').with({ 'ensure' => 'directory',  })}
  it { should contain_file('/home/testuser/.ssh').with({ 'ensure' => 'directory',  })}
  #it { should contain_file('/home/testuser/.ssh/authorized_keys').with_content(directorysa testkey/) }
  it { should contain_file('/home/testuser/.ssh/test_private_key').with({ 'ensure' => 'present',  })}
  it { should contain_file('/home/testuser/.special_test_file').with({ 'ensure' => 'present',  })}
  it { should contain_file('/home/testuser/.bashrc').with({ 'ensure' => 'present',  })}
  it { should contain_file('/home/testuser/.bash_logout').with({ 'ensure' => 'present',  })}
  it { should contain_file('/home/testuser/.bash_history').with({ 'ensure' => 'absent',  })}
  it { should contain_file('/home/testuser/.viminfo').with({ 'ensure' => 'present',  })}

  end
end

