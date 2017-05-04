# Jruby
#
# Install Jruby and create wrapper scripts for the commands:
# * `jgem`
# * `jirb`
# * `jruby`
# * `jrubyc`
#
# @example Installing the module default version of JRuby
#   include JRuby
#
# @example Installing JRuby from your own infrastructure
#   class {'jruby':
#     versions => "9.1.8.0",
#     baseurl  => "https://repo.megacorp.com/jruby",
#   }
# Be sure to specify correct version when specifying a URL
#
# @example Installing several JRubies
#   class {'jruby':
#     versions => ["6.6.6.0", "9.1.7.2", "9.1.8.0"]
#   }
# The first listed version will be installed as the system default
#
# @param versions Array of JRuby versions to install.  The first supplied
#   version will be configured as the system default
# @param prefix Directory to install this version into
# @param baseurl Download location.  Leave blank to use the vendor default for this
#   release or supply a download directory and the correct filename will be
#   computed from the version.  Make sure there isn't a trailing slash.
# @param checksum_values Ensure the downloaded file matches this checksum if set
#   if used, should be a has with a key for each version, eg
#   `{'9.1.8.0'=>'deadbeef'}`
# @param checksum_type Method for computing checksums (@see https://forge.puppet.com/puppet/archive#archive)
class jruby(
    $versions         = ['9.1.8.0'],
    String $prefix    = '/opt/jruby',
    $baseurl          = undef,
    $checksum_values  = {},
    $checksum_type    = undef,
) {

  $_versions = any2array($versions)

  # default `jruby_home` is whatever the prefix was and this ends up as a
  # symlink to the active version
  $jruby_home = $prefix

  # default: symlink /opt/jruby to /opt/jruby-x.x.x.x (user configurable)
  file { $jruby_home:
    ensure => link,
    target => "${jruby_home}-${_versions[0]}",
  }

  # perform the download and extraction.  By default creates
  # /opt/jruby-x.x.x.x
  $_versions.each |$version| {
    if $baseurl {
      $_baseurl = $baseurl
    } else {
      $_baseurl = "http://s3.amazonaws.com/jruby.org/downloads/${version}"
    }
    $package  = "jruby-bin-${version}.tar.gz"
    $url      = "${_baseurl}/${package}"

    archive { "/tmp/${package}":
      ensure        => present,
      extract       => true,
      extract_path  => dirname($prefix),
      source        => $url,
      checksum      => dig($checksum_values, $version),
      checksum_type => $checksum_type,
      creates       => "${jruby_home}-${version}",
      cleanup       => true,
    }
  }
  # Create convience wrappers for each jruby binary.  Seems a file is needed
  # rather then a symlink, presumably because the script sets `JRUBY_HOME`.
  # Note that this uses the default jruby
  ["jgem", "jirb", "jruby", "jrubyc"].each |$binary| {
    # the puppet master giveth and the puppetmaster taketh away againeth
    $epp_p = {'jruby_home' => $jruby_home, 'binary' => $binary}
    file {"/usr/local/bin/${binary}":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => epp("${module_name}/binary.epp", $epp_p),
    }
  }

  environment_variable::variable{ "JRUBY_HOME=${jruby_home}": }
  environment_variable::path_element { "${jruby_home}/bin": }
}
