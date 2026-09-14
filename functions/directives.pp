# @summary Normalizes a hash of Nagios object directives for rendering.
#
# Entries whose value is undef or an empty array are dropped, arrays are
# joined with commas, booleans become 1/0 and every other value is
# stringified. Insertion order is preserved.
#
# @param directives Raw directives as built by the nagios::type::* defines.
# @return [Hash[String[1], String]] Directives ready to be rendered.
function nagios::directives(Hash[String[1], Any] $directives) >> Hash[String[1], String] {
  $kept = $directives.filter |$key, $value| {
    $value =~ NotUndef and !($value =~ Array and $value.empty)
  }

  Hash($kept.map |$key, $value| {
      $rendered = $value ? {
        Array   => $value.join(','),
        Boolean => String(Integer($value)),
        default => String($value),
      }
      [$key, $rendered]
  })
}
