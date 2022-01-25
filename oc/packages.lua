{
  ['sdebug'] = {
    info = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/sdebug/info.lua',
    description = 'Library for debug',
  },
  ['sanlib'] = {
    info = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/sanlib/info.lua',
    description = 'Library for my projects',
  },
  ['san-get'] = {
    info = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/san-get/info.lua',
    description = 'Package manager',
  },
  ['sanguilib'] = {
    info = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/sanguilib/info.lua'
    dependencies = {'sanlib'},
    description = 'GUI framework',
  },
  ['mc'] = {
    dependencies = {},
    files = {
      ['/bin/mc.lua'] = 'http://pastebin.com/raw/kE3jp6nD'
    },
    afterinstall = {},
    description = 'Midday commaner. Simple file manager. Looks like NC',
    version = '1.8'
  }}
