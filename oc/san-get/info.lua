{
    name='san-get',
    version = '1.0.11',
    dependencies = {'sanlib'},
    files = {
      ['/bin/san-get.lua'] = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/san-get/san-get.lua',
      ['/usr/man/san-get'] = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/san-get/san-get.man'
    },
    afterinstall = {},
    description = 'Package manager for my repo',
    addrandom = true
}