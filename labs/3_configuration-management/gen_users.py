def get_group_str(user, gid):
    """ returns a pp string declaring a group for the given user and id"""
    return 'group { "' + f'{user}":\n' + \
           '   ensure => "present",\n' + \
           '   gid => ' + f'"{gid}"\n' + \
           '}\n'


def get_user_str(user, gid, uid):
    """ returns a pp string declaring a user for the given user and id"""
    return 'user { "' + f'{user}":\n' + \
           '    ensure => "present",\n' + \
           '    gid => ' + f'"{gid}",\n' + \
           '    uid => ' + f'"{uid}",\n' + \
           "    password => '$6$WzFG7Ga3$.BbRW/DFGkx5EIakXIt1udCGxVDPs2uFZg.o8EFzH8BX7cutimTCfTUWDdyHoFjDVTFnBkUWVPGntQTRSo1zp0',\n" + \
           '    shell => "/bin/bash",\n' + \
           f'    home => "/home/{user}",\n' + \
           '    managehome => true,\n' + \
           '}\n'


def get_home_str(user):
    return 'file { "' + f'{user}":\n' + \
           '    ensure => directory,\n' + \
           '    path => "/home/' + f'{user}",\n' + \
           '    owner => "' + f'{user}",\n' + \
           '    group => "' + f'{user}",\n' + \
           '    mode => 0770,\n' + \
           '}\n'



def gen_pp(users, start_gid=500, start_uid=500):
    """ Generate pp string for all users each with a unique GID and UID, starting from the given starting values """
    gid = start_gid
    uid = start_uid
    with open("users.pp", "w+") as f:
        for user in users:
            g = get_group_str(user, gid)
            u = get_user_str(user, gid, uid)
            h = get_home_str(user)
            gid += 1
            uid += 1
            f.write(g+u+h)  # GUHH



if __name__ == "__main__":
    users = ["mscott", "dschrute", "jhalpert", "pbeesly", "abernard", "amartin", "kkapoor", "omartinez", "dphilbin",
             "tflenderson", "kmalone", "plapin", "shudson", "mpalmer", "cbratton"]
    gen_pp(users)
