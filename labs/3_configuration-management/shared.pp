file { "managers":
    ensure => directory,
    path => "/home/managers",
    owner => "mscott",
    group => "managers",
    mode => 0770,
}
file { "accounting":
    ensure => directory,
    path => "/home/accounting",
    owner => "amartin",
    group => "accounting",
    mode => 0770,
}
file { "sales":
    ensure => directory,
    path => "/home/sales",
    owner => "abernard",
    group => "sales",
    mode => 0770,
}
