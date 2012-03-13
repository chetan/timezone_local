
require 'find'
require 'fileutils'

module TimeZone::Local
    module Unix

        def METHODS
            [ :from_env, :from_etc_localtime, :from_etc_timezone, :from_etc_TIMEZONE,
              :from_etc_sysconfig_clock, :from_etc_default_init ]
        end

        def from_env
            return ENV["TZ"] if ENV.include? "TZ"
        end

        def from_etc_localtime

           lt_file = "/etc/localtime"

           # check if it is symlinked
           real_name = expand_symlink(lt_file)

           # search for it not found
           real_name ||= find_matching_zoneinfo_file(lt_file)

           return nil if real_name.nil?

           dirs, file = File.split(real_name)
           parts = dirs.split(File::Separator).reject{ |f| f.empty? } << file
           parts.reverse.each_with_index do |part, x|
               name = x < parts.size ? parts[x..parts.size].join("/") : part
               tz = load_tz(name)
               return tz if not tz.nil?
           end

        end

        def expand_symlink(f)
            return nil if File.symlink?(f)
            File.expand_path(File.readlink(f), File.dirname(File.expand_path(f)))
        end

        def find_matching_zoneinfo_file(file_to_match)

            zoneinfo = '/usr/share/zoneinfo'
            return if not (File.exists? file_to_match and File.directory? zoneinfo)

            size = File.size(file_to_match) # look for this

            match = nil
            Find.find(zoneinfo) do |path|
                if File.file? path and
                   File.size(path) == size and
                   File.basename(path) != 'posixrules' and
                   File.compare(file_to_match, path) then

                   match = path
               end
            end

            return match
        end

        def from_etc_timezone

            tz_file = '/etc/timezone'

            return nil if not (File.exists? tz_file and File.file? tz_file and File.readable? tz_file)

            name = IO.read(tz_file).strip

            return nil if not is_valid_name? name
            return load_tz(name)
        end

        def from_etc_TIMEZONE
            tz_file = '/etc/timezone'

            return nil if not (File.exists? tz_file and File.file? tz_file and File.readable? tz_file)

            IO.readlines(tz_file).each do |line|
                if line =~ /\A\s*TZ\s*=\s*(\S+)/ then
                    name = $1
                    break
                end
            end

            return nil if not is_valid_name? name
            return load_tz(name)
        end

        def from_etc_sysconfig_clock
            tz_file = '/etc/sysconfig/clock'
            return nil if not (File.exists? tz_file and File.file? tz_file and File.readable? tz_file)
            IO.readlines(tz_file).each do |line|
                if line =~ /^(?:TIME)?ZONE="([^"]+)"/ then
                    name = $1
                    break
                end
            end

            return nil if not is_valid_name? name
            return load_tz(name)
        end

        def from_etc_default_init
            tz_file = '/etc/default/init'
            return nil if not (File.exists? tz_file and File.file? tz_file and File.readable? tz_file)

            IO.readlines(tz_file).each do |line|
                if line =~ /^TZ=(.+)/ then
                    name = $1
                    break
                end
            end

            return nil if not is_valid_name? name
            return load_tz(name)
        end

        def load_tz(name)
            begin
                tz = TZInfo::Timezone.get(name)
                return tz
            rescue Exception => ex
            end
            return nil
        end

        def is_valid_name?(name)
            return false if name.nil? or name.empty? or name == 'local'
            return name =~ %r{^[\w/\-\+]+$}
        end

    end # Unix
end # DateTime

