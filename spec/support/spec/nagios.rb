# frozen_string_literal: true

# The values of the module data the specs expect on the OS of the example.
module NagiosSpecHelpers
  def fqdn
    facts[:networking]['fqdn']
  end

  # Directory of the Nagios configuration
  def cfg_dir
    (facts[:os]['family'] == 'Debian') ? '/etc/nagios4' : '/etc/nagios'
  end

  # Package and service of Nagios
  def nagios_package
    (facts[:os]['family'] == 'Debian') ? 'nagios4' : 'nagios'
  end

  # Directory of the monitoring plugins
  def plugin_dir
    case facts[:os]['family']
    when 'Debian' then '/usr/lib/nagios/plugins'
    when 'Archlinux' then '/usr/lib/monitoring-plugins'
    else '/usr/lib64/nagios/plugins'
    end
  end

  # Package of the monitoring plugins
  def plugins_package
    (facts[:os]['family'] == 'RedHat') ? 'nagios-plugins' : 'monitoring-plugins'
  end
end

RSpec.configure do |c|
  c.include NagiosSpecHelpers
end
