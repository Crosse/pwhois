module Pwhois
    module Version
        MAJOR = 1
        MINOR = 1
        TINY  = 0
    end
    VERSION = [Version::MAJOR, Version::MINOR, Version::TINY].compact * '.'
end