{
    name='ic2-components',
    version = '1.0.0',
    dependencies = {'sanlib'},
    files = {
      ['/lib/ic2_energy_storage.lua'] = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/ic2-components/energy_storage.lua',
      ['/lib/ic2_reactor.lua'] = 'https://raw.githubusercontent.com/sanovskiy/mc-lua/master/oc/ic2-components/reactor.lua'
    },
    afterinstall = {},
    description = 'Industrial Craft 2 components library',
    addrandom = true
}