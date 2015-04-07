class wbez_dev_stack {

    $git_host = 'github.com'
    $doc_root = '/var/www/'

    Package {
        ensure => "installed",
        require => Exec["apt-get -y update"],
    }

    exec { "apt-get -y update":
        command => "/usr/bin/apt-get -y update",
    }

    Exec {
        path => '/usr/local/bin:/usr/sbin:/usr/bin:/bin',
    }

    include wbez_dev_stack_system

    if ($project_base == 'drupal') {

        include wbez_dev_stack_drupal

    }

}

class wbez_dev_stack_system {

    package { "openssl":
        ensure => "installed"
    }

    package { "vim":
        ensure => "installed"
    }

    package { "ntp":
        ensure => "installed"
    }

    service { "ntp":
        ensure => "running"
    }

    include wbez_dev_stack_git
    include wbez_dev_stack_apache
    include stdlib

}

class wbez_dev_stack_mysql {

    class { '::mysql::server':

        root_password    => 'root',
        override_options => { 'mysqld' => { 'max_connections' => '1024' } },
        users => {
            "$wbez_dev_stack::client_key@localhost" => {
                ensure                   => 'present',
                max_connections_per_hour => '0',
                max_queries_per_hour     => '0',
                max_updates_per_hour     => '0',
                max_user_connections     => '0',
                password_hash            => mysql_password($wbez_dev_stack::client_key)
            }
        },
        grants => {
            "$wbez_dev_stack::client_key@localhost/$wbez_dev_stack::client_key.*" => {
                ensure     => 'present',
                options    => ['GRANT'],
                privileges => ['CREATE', 'DROP', 'SELECT', 'INSERT', 'UPDATE', 'DELETE'],
                table      => "$wbez_dev_stack::client_key.*",
                user       => "$wbez_dev_stack::client_key@localhost",
            }
        },
        databases => {
            "$wbez_dev_stack::client_key" => {
                ensure  => 'present',
                charset => 'utf8',
            }
        }

    }


    package { "debconf-utils":
        ensure => "installed",
        before => Class["phpmyadmin"]
    }

    include phpmyadmin
}

class wbez_dev_stack_drupal {

    include wbez_dev_stack_mysql
    include wbez_dev_stack_apache
    include wbez_dev_stack_php

    package { "drush":
        ensure => "installed"
    }

    package { "drush-make":
        ensure => "installed"
    }

}

class wbez_dev_stack_git {

    package { "git-core":
        ensure => "installed"
    }

    if $wbez_dev_stack::git_ssh {

        exec { "git clone":
            command => "git clone ${wbez_dev_stack::git_ssh} ${wbez_dev_stack::doc_root}",
            creates => "/var/www/.git",
            require => [Exec["empty docroot"]],
            user => "vagrant"
        }

        class { 'ssh':
            storeconfigs_enabled => false,
            client_options => {
                "Host ${wbez_dev_stack::git_host}" => {
                    "StrictHostKeyChecking" => 'no',
                }
            }
        }

        exec { "empty docroot":
            command => "rm -Rf ${wbez_dev_stack::doc_root}/*",
            user => "root",
            unless => "test -d ${wbez_dev_stack::doc_root}/.git"
        }

    }

}

class wbez_dev_stack_php {

    package { "php5":
        ensure => "installed"
    }

    file { "php.ini":
        name => '/etc/php5/apache2/conf.d/php.ini',
        ensure        => present,
        source        => '/vagrant/files/conf/php5/apache2/php.ini',
        owner         => root,
        group         => root,
        mode          => 0640,
        require       => Package["apache2"]
    }

}

class wbez_dev_stack_apache {

    package { "apache2":
        ensure => "installed"
    }

    package { "apache2.2-common":
        ensure => "installed"
    }

    package { "libapache2-mod-php5":
        ensure => "installed"
    }

    package { "libapache2-mod-auth-mysql":
        ensure => "installed"
    }

    file { "apache.conf":
        name => '/etc/apache2/sites-available/default',
        ensure        => present,
        source        => '/vagrant/files/conf/apache2/default',
        owner         => root,
        group         => root,
        mode          => 0640,
        require       => Package["apache2"]
    }

    service { "apache2":
        ensure => "running",
        enable => true,
        require => Package["apache2"]
    }

    exec { "a2enmod rewrite":
        command => "a2enmod rewrite",
        require => Package["apache2"],
        path => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin',
        user => 'root'
    }

    exec { "enable_mod_rewrite":
        require => Package["apache2"],
        before => Service["apache2"],
        command => "/usr/sbin/a2enmod rewrite",
    }

}

include wbez_dev_stack
