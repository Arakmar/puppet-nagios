# @summary A TCP port, as an integer or a numeric string.
type Nagios::Port = Variant[Stdlib::Port, Pattern[/\A\d{1,5}\z/]]
