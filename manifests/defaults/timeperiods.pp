class nagios::defaults::timeperiods {
  nagios::type::timeperiod {
    '24x7':
      timeperiod_alias => '24 Hours A Day, 7 Days A Week',
      sunday           => '00:00-24:00',
      monday           => '00:00-24:00',
      tuesday          => '00:00-24:00',
      wednesday        => '00:00-24:00',
      thursday         => '00:00-24:00',
      friday           => '00:00-24:00',
      saturday         => '00:00-24:00';
    'workhours':
      timeperiod_alias => 'Standard Work Hours',
      monday           => '09:00-17:00',
      tuesday          => '09:00-17:00',
      wednesday        => '09:00-17:00',
      thursday         => '09:00-17:00',
      friday           => '09:00-17:00';
    'nonworkhours':
      timeperiod_alias => 'Non-Work Hours',
      sunday           => '00:00-24:00',
      monday           => '00:00-09:00,17:00-24:00',
      tuesday          => '00:00-09:00,17:00-24:00',
      wednesday        => '00:00-09:00,17:00-24:00',
      thursday         => '00:00-09:00,17:00-24:00',
      friday           => '00:00-09:00,17:00-24:00',
      saturday         => '00:00-24:00';
    'never':
      timeperiod_alias => 'Never';
  }

}
