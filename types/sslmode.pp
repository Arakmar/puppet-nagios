# @summary How nagios::service::http checks a site over http and https.
#
# - `false`: check http only
# - `true`: check http and https
# - `force`: check https and that http redirects to https
# - `only`: check https only
type Nagios::SslMode = Variant[Boolean, Enum['force', 'only']]
