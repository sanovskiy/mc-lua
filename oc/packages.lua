{
  ['sdebug'] = {
    dependencies = {},
    files = {
      ['/lib/sdebug.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sdebug/sdebug.lua'
    },
    afterinstall = {},
    description = 'Library for debug',
    version = '1.0.0',
    addrandom = true
  },
  ['sanlib'] = {
    dependencies = {},
    files = {
      ['/lib/sanstring.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/sanstring.lua',
      ['/lib/santable.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/santable.lua',
      ['/lib/sanfs.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sanlib/sanfs.lua'
    },
    afterinstall = {},
    description = 'Library for my projects',
    version = '1.0.0',
    addrandom = true
  },
  ['san-get'] = {
    dependencies = {'sanlib'},
    files = {
      ['/bin/san-get.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/san-get/san-get.lua',
      ['/usr/man/san-get'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/san-get/san-get.man'
    },
    afterinstall = {},
    description = 'Package manager for my repo',
    version = '1.0.8',
    addrandom = true
  },
  ['sanguilib'] = {
    dependencies = {'sanlib'},
    files = {
      ['/lib/sanguilib.lua'] = 'https://bitbucket.org/sanovskiy/minecraft-lua/raw/master/oc/sangui/sanguilib.lua'
    },
    afterinstall = {},
    description = 'GUI framework',
    version = '1.0.0',
    addrandom = true
  },
  ['mc'] = {
    dependencies = {},
    files = {
      ['/bin/mc.lua'] = 'http://pastebin.com/raw/kE3jp6nD'
    },
    afterinstall = {},
    description = 'Midday commaner. Simple file manafer. Looks like NC',
    version = '1.7'
  }}
