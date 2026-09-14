# @summary Declares a Nagios contact on the server.
#
# @param contact_name Name of the contact, defaults to the resource title.
# @param template_name Registers the object as a template with this name.
# @param use Contact template to inherit from.
# @param contact_alias Long name of the contact.
# @param service_notification_period Timeperiod for service notifications.
# @param host_notification_period Timeperiod for host notifications.
# @param service_notification_options Service states to notify about.
# @param host_notification_options Host states to notify about.
# @param service_notification_commands Commands used for service notifications.
# @param host_notification_commands Commands used for host notifications.
# @param email Email address of the contact.
# @param register Whether the object is a real contact (1) or a template (0).
define nagios::type::contact (
  String[1]                                    $contact_name                  = $name,
  Optional[String[1]]                          $template_name                 = undef,
  String[1]                                    $use                           = 'generic-contact',
  Optional[String[1]]                          $contact_alias                 = undef,
  Optional[String[1]]                          $service_notification_period   = undef,
  Optional[String[1]]                          $host_notification_period      = undef,
  Optional[String[1]]                          $service_notification_options  = undef,
  Optional[String[1]]                          $host_notification_options     = undef,
  Optional[Variant[String[1], Array[String[1]]]] $service_notification_commands = undef,
  Optional[Variant[String[1], Array[String[1]]]] $host_notification_commands    = undef,
  String[1]                                    $email                         = 'root@localhost',
  Optional[Nagios::Flag]                       $register                      = undef,
) {
  $cfg_dir = lookup('nagios::cfg_dir', Stdlib::Absolutepath)

  concat::fragment { "nagios_contact_${name}_${facts['networking']['fqdn']}":
    target  => "${cfg_dir}/conf.d/nagios_contact.cfg",
    order   => '30',
    tag     => 'nagios_contact',
    content => nagios::object('contact', {
        'contact_name'                  => $contact_name,
        'name'                          => $template_name,
        'use'                           => $use,
        'alias'                         => $contact_alias,
        'service_notification_period'   => $service_notification_period,
        'host_notification_period'      => $host_notification_period,
        'service_notification_options'  => $service_notification_options,
        'host_notification_options'     => $host_notification_options,
        'service_notification_commands' => $service_notification_commands,
        'host_notification_commands'    => $host_notification_commands,
        'email'                         => $email,
        'register'                      => $register,
    }),
  }
}
