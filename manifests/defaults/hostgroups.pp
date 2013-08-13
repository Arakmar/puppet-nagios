class nagios::defaults::hostgroups
(
    $server_name = "default"
) {
  nagios::type::hostgroup {
    'all':
      server_name => $server_name,
      hostgroup_alias   => 'All Servers',
    	members => ['*'];
    'debian-servers':
      server_name => $server_name,
      hostgroup_alias   => 'Debian GNU/Linux Servers';
    'centos-servers':
      server_name => $server_name,
      hostgroup_alias   => 'CentOS GNU/Linux Servers';
    'http-servers':
      server_name => $server_name,
      hostgroup_alias   => "HTTP servers";
    'ftp-servers':
      server_name => $server_name,
      hostgroup_alias   => "FTP servers";
    'sftp-servers':
      server_name => $server_name,
      hostgroup_alias   => "SFTP servers";
    'mysql-servers':
      server_name => $server_name,
      hostgroup_alias   => "MySQL servers";
    'dns-servers':
      server_name => $server_name,
      hostgroup_alias   => "DNS servers";
    'mail-servers':
      server_name => $server_name,
      hostgroup_alias   => "mail servers";
    'routers':
      server_name => $server_name,
      hostgroup_alias   => "Routers"
  }
}
