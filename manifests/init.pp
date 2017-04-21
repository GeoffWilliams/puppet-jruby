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
#     version => "9.1.8.0",
#     baseurl => "https://repo.megacorp.com/jruby",
#   }
# Be sure to specify correct version when specifying a URL
#
# @param version Version of JRuby to install
# @param prefix Directory to install this version into
# @param baseurl Download location.  Leave blank to use the vendor default for this
#   release or supply a download directory and the correct filename will be
#   computed from the version.  Make sure there isn't a trailing slash.
# @param checksum_value Ensure the downloaded file matches this checksum if set
# @param checksum_type Method for computing checksums (@see https://forge.puppet.com/puppet/archive#archive)
class jruby(
    String $version = '9.1.8.0',
    String $prefix  = '/opt/jruby',
    $baseurl        = undef,
    $checksum_value = undef,
    $checksum_type  = undef,
) {

  # default `jruby_home` is whatever the prefix was and this ends up as a
  # symlink to the active version
  $jruby_home = $prefix
  $package    = "jruby-bin-${version}.tar.gz"

  if $baseurl {
    $_baseurl = $baseurl
  } else {
    $_baseurl = "http://s3.amazonaws.com/jruby.org/downloads/${version}"
  }

  $url = "${_baseurl}/${package}"

  # default: symlink /opt/jruby to /opt/jruby-x.x.x.x (user configurable)
  file { $jruby_home:
    ensure => link,
    target => "${jruby_home}-${version}",
  }

  # perform the download and extraction.  By default creates /opt/jruby-x.x.x.x
  archive { "/tmp/${package}":
    ensure        => present,
    extract       => true,
    extract_path  => dirname($prefix),
    source        => $url,
    checksum      => $checksum_value,
    checksum_type => $checksum_type,
    creates       => "${jruby_home}-${version}",
    cleanup       => true,
  }

  # Create convience wrappers for each jruby binary.  Seems a file is needed
  # rather then a symlink, presumably because the script sets `JRUBY_HOME`
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
}
