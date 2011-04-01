
require 'tzinfo'

module TimeZone
    module Local

        # load the correct module depending on OS
        if /cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM then
            require File.join(File.dirname(__FILE__), 'windows')
            include TimeZone::Local::Windows
        else
            require File.join(File.dirname(__FILE__), 'unix')
            extend TimeZone::Local::Unix
        end

        def self.get

            return @tz if not @tz.nil?

            self.METHODS.each do |m|
                begin
                    @tz = self.send(m)
                    return @tz if not @tz.nil?
                rescue Exception => ex
                end
            end

            nil
        end
    end
end

class TZInfo::Timezone
    def self.get_local_timezone
        TimeZone::Local.get
    end
end
