# @summary A Nagios 0/1 directive, also accepting booleans.
type Nagios::Flag = Variant[Boolean, Integer[0, 1], Enum['0', '1']]
