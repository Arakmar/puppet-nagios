# @summary A non negative Nagios interval, attempt count or timeout.
type Nagios::Interval = Variant[Numeric, Pattern[/\A\d+(\.\d+)?\z/]]
