class nagios::defaults::hostgroups {
  nagios::type::hostgroup {
    'all':
      hostgroup_alias => 'All Servers',
      members         => ['*'];
    'debian-servers':
      hostgroup_alias => 'Debian GNU/Linux Servers';
    'centos-servers':
      hostgroup_alias => 'CentOS GNU/Linux Servers';
    'http-servers':
      hostgroup_alias => "HTTP servers";
    'ftp-servers':
      hostgroup_alias => "FTP servers";
    'sftp-servers':
      hostgroup_alias => "SFTP servers";
    'mysql-servers':
      hostgroup_alias => "MySQL servers";
    'dns-servers':
      hostgroup_alias => "DNS servers";
    'mail-servers':
      hostgroup_alias => "mail servers";
    'routers':
      hostgroup_alias => "Routers"
  }
}
