group { "mscott":
   ensure => "present",
   gid => "500"
}
user { "mscott":
    ensure => "present",
    gid => "500",
    groups => ["managers"],
    uid => "500",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/mscott",
    managehome => true,
}
file { "mscott":
    ensure => directory,
    path => "/home/mscott",
    owner => "mscott",
    group => "mscott",
    mode => 0770,
}
group { "dschrute":
   ensure => "present",
   gid => "501"
}
user { "dschrute":
    ensure => "present",
    gid => "501",
    groups => ["managers"],
    uid => "501",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/dschrute",
    managehome => true,
}
file { "dschrute":
    ensure => directory,
    path => "/home/dschrute",
    owner => "dschrute",
    group => "dschrute",
    mode => 0770,
}
group { "jhalpert":
   ensure => "present",
   gid => "502"
}
user { "jhalpert":
    ensure => "present",
    gid => "502",
    groups => ["managers"],
    uid => "502",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/jhalpert",
    managehome => true,
}
file { "jhalpert":
    ensure => directory,
    path => "/home/jhalpert",
    owner => "jhalpert",
    group => "jhalpert",
    mode => 0770,
}
group { "pbeesly":
   ensure => "present",
   gid => "503"
}
user { "pbeesly":
    ensure => "present",
    gid => "503",
    uid => "503",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/pbeesly",
    managehome => true,
}
file { "pbeesly":
    ensure => directory,
    path => "/home/pbeesly",
    owner => "pbeesly",
    group => "pbeesly",
    mode => 0770,
}
group { "abernard":
   ensure => "present",
   gid => "504"
}
user { "abernard":
    ensure => "present",
    gid => "504",
    groups => ["sales"],
    uid => "504",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/abernard",
    managehome => true,
}
file { "abernard":
    ensure => directory,
    path => "/home/abernard",
    owner => "abernard",
    group => "abernard",
    mode => 0770,
}
group { "amartin":
   ensure => "present",
   gid => "505"
}
user { "amartin":
    ensure => "present",
    gid => "505",
    groups => ["sales"],
    groups => ["sales"],
    uid => "505",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/amartin",
    managehome => true,
}
file { "amartin":
    ensure => directory,
    path => "/home/amartin",
    owner => "amartin",
    group => "amartin",
    mode => 0770,
}
group { "kkapoor":
   ensure => "present",
   gid => "506"
}
user { "kkapoor":
    ensure => "present",
    gid => "506",
    uid => "506",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/kkapoor",
    managehome => true,
}
file { "kkapoor":
    ensure => directory,
    path => "/home/kkapoor",
    owner => "kkapoor",
    group => "kkapoor",
    mode => 0770,
}
group { "omartinez":
   ensure => "present",
   gid => "507"
}
user { "omartinez":
    ensure => "present",
    gid => "507",
    uid => "507",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/omartinez",
    managehome => true,
}
file { "omartinez":
    ensure => directory,
    path => "/home/omartinez",
    owner => "omartinez",
    group => "omartinez",
    mode => 0770,
}
group { "dphilbin":
   ensure => "present",
   gid => "508"
}
user { "dphilbin":
    ensure => "present",
    gid => "508",
    uid => "508",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/dphilbin",
    managehome => true,
}
file { "dphilbin":
    ensure => directory,
    path => "/home/dphilbin",
    owner => "dphilbin",
    group => "dphilbin",
    mode => 0770,
}
group { "tflenderson":
   ensure => "present",
   gid => "509"
}
user { "tflenderson":
    ensure => "present",
    gid => "509",
    uid => "509",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/tflenderson",
    managehome => true,
}
file { "tflenderson":
    ensure => directory,
    path => "/home/tflenderson",
    owner => "tflenderson",
    group => "tflenderson",
    mode => 0770,
}
group { "kmalone":
   ensure => "present",
   gid => "510"
}
user { "kmalone":
    ensure => "present",
    gid => "510",
    groups => ["sales"],
    uid => "510",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/kmalone",
    managehome => true,
}
file { "kmalone":
    ensure => directory,
    path => "/home/kmalone",
    owner => "kmalone",
    group => "kmalone",
    mode => 0770,
}
group { "plapin":
   ensure => "present",
   gid => "511"
}
user { "plapin":
    ensure => "present",
    gid => "511",
    groups => ["sales"],
    uid => "511",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/plapin",
    managehome => true,
}
file { "plapin":
    ensure => directory,
    path => "/home/plapin",
    owner => "plapin",
    group => "plapin",
    mode => 0770,
}
group { "shudson":
   ensure => "present",
   gid => "512"
}
user { "shudson":
    ensure => "present",
    gid => "512",
    groups => ["sales"],
    uid => "512",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/shudson",
    managehome => true,
}
file { "shudson":
    ensure => directory,
    path => "/home/shudson",
    owner => "shudson",
    group => "shudson",
    mode => 0770,
}
group { "mpalmer":
   ensure => "present",
   gid => "513"
}
user { "mpalmer":
    ensure => "present",
    gid => "513",
    uid => "513",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/mpalmer",
    managehome => true,
}
file { "mpalmer":
    ensure => directory,
    path => "/home/mpalmer",
    owner => "mpalmer",
    group => "mpalmer",
    mode => 0770,
}
group { "cbratton":
   ensure => "present",
   gid => "514"
}
user { "cbratton":
    ensure => "present",
    gid => "514",
    uid => "514",
    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',
    shell => "/bin/bash",
    home => "/home/cbratton",
    managehome => true,
}
file { "cbratton":
    ensure => directory,
    path => "/home/cbratton",
    owner => "cbratton",
    group => "cbratton",
    mode => 0770,
}
