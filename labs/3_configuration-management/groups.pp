group { "sales":
    ensure => "present",
    gid => "5000",
}
group { "managers":
    ensure => "present",
    gid => "5001",
}
group { "accounting":
    ensure => "present",
    gid => "5002"
}