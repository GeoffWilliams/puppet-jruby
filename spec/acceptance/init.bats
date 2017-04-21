@test "jruby extracted" {
  [[ -d /opt/jruby-9.1.8.0 ]]
}

@test "jruby main binary exists" {
  [[ -x /opt/jruby-9.1.8.0/bin/jruby ]]
}

@test "jgem installed" {
  [[ -x /usr/local/bin/jgem ]]
}

@test "jirb installed" {
  [[ -x /usr/local/bin/jirb ]]
}

@test "jruby installed" {
  [[ -x /usr/local/bin/jruby ]]
}

@test "jrubyc installed" {
  [[ -x /usr/local/bin/jrubyc ]]
}
