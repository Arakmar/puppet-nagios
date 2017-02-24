#
# nagios module
# nagios.pp - everything nagios related
#
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# Copyright 2008, admin(at)immerda.ch
# Copyright 2008, Puzzle ITC GmbH
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 3 as published by
# the Free Software Foundation.
#

# manage nagios
class nagios(
  $allow_external_cmd = false,
  $server_name = undef
) {
  validate_string($server_name)

  case $::operatingsystem {
    'centos': {
      include nagios::centos
    }
    'debian': {
      include nagios::debian
    }
    default: { fail("No such operatingsystem: ${::operatingsystem} yet defined") }
  }
}
