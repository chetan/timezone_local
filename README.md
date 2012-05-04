# timezone_local

timezone_local is a Ruby port of the Perl CPAN module [DateTime::TimeZone::Local](https://metacpan.org/module/DateTime::TimeZone::Local) for determining the local system's timezone. Currently only Unix platforms are supported but pull requests are welcome!

## Usage

    $ gem install timezone_local

    require 'timezone_local'
    tz = TimeZone::Local.get() # => #<TZInfo::LinkedTimezone: US/Eastern>

