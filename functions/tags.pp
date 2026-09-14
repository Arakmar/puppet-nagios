# @summary Builds the tags used to route exported fragments to Nagios servers.
#
# @param type Collected type name as used by nagios::collect_type.
# @param server_names Nagios servers the fragment is meant for. When empty the
#   fragment is tagged for servers declared without a server_name.
# @return [Array[String[1]]] The tags to set on the exported fragment.
function nagios::tags(String[1] $type, Array[String[1]] $server_names) >> Array[String[1]] {
  if $server_names.empty {
    ["nagios_${type}"]
  } else {
    $server_names.map |String $server| { "nagios_${type}_${server}" }
  }
}
