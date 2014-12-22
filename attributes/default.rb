# lighttpd
default['lighttpd']['port'] = 443

# php
default['php']['packages'] = %w[ php5 php5-cli php5-fpm ]

# rTorrent
default['rtorrent']['debfile'] = "rtorrent_0.9.2-1_amd64.deb"

# libTorrent
default['rtorrent']['libtorrent']['debfile'] = "libtorrent_0.13.2-1_amd64.deb"

# xmlrpc-c
default['rtorrent']['xmlrpc']['debfile'] = "xmlrpc-c_1.33.14-1_amd64.deb"

# ruTorrent
default['rutorrent']['version'] = "3.6"
default['rutorrent']['source'] = "https://bintray.com/artifact/download/novik65/generic/rutorrent-#{rutorrent[:version]}.tar.gz"
default['rutorrent']['plugins'] = "https://bintray.com/artifact/download/novik65/generic/plugins-#{rutorrent[:version]}.tar.gz"
