# @summary Renders one Nagios object definition.
#
# @param type Nagios object type, for example `host` or `service`.
# @param directives Directives of the object, see nagios::directives for the
#   normalisation applied.
# @return [String] The `define <type> { ... }` block.
function nagios::object(String[1] $type, Hash[String[1], Any] $directives) >> String {
  epp('nagios/object.epp', {
      'type'       => $type,
      'directives' => nagios::directives($directives),
  })
}
