# @summary Declares the default Nagios contacts.
#
# @param contacts Contacts to declare, as nagios::type::contact titles mapped
#   to their parameters. Defaults to a root contact notified by email.
class nagios::defaults::contacts (
  Hash[String[1], Hash] $contacts,
) {
  $contacts.each |String $contact, Hash $params| {
    nagios::type::contact { $contact:
      * => $params,
    }
  }
}
