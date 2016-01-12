require 'optparse'
require 'whois'
require 'pwhois/version'

class Symbol
    def titleize()
        to_s.split('_').map { |words| words.capitalize }.join(' ')
    end
end

module Pwhois
    OUTPUT_STYLES = [ :csv, :tsv, :table, :list ]

    class WhoisParser
        # Constants
        UNKNOWN = "UNKNOWN"

        # Instance variables
        attr_accessor :verbose, :output_style, :attributes

        def initialize()
            @whois_client = Whois::Client.new
            @verbose = false
            @output_style = :list
            @attributes = [:domain, :created_on, :updated_on, :registrar_name]
        end # initialize()


        def get_attr(record, attr)
            if record == nil
                raise(ArgumentError, ":record must not be nil")
            end

            if "#{attr}".start_with?("registrar")
                if record.registrar != nil
                    a = "#{attr}".split('_')[1]
                    get_attr(record.registrar, a)
                end
            else
                if record.respond_to?(attr)
                    record.send(attr)
                else
                    raise(ArgumentError, "Warning:  attribute \"#{ attr }\" does not exist for this domain")
                end
            end
        end # get_attr()


        def query(q)
            query_list([ q ])
        end # query()


        def query_list(querys)
            print_header()

            # only required for table listings.
            results = []

            querys.each do |q|
                result = Hash.new
                begin
                    print_verbose("Querying whois for #{q}...")
                    record = @whois_client.lookup(q)
                    if !record
                        $stderr.puts "No WHOIS record found for #{q}"
                    end

                    attributes.each do |a|
                        begin
                            result[a] = get_attr(record, a)
                        rescue ArgumentError => e
                            $stderr.puts e.message
                        end
                    end

                    if output_style == :table
                        results.push(result)
                    else
                        print_item(result)
                    end
                rescue Whois::ConnectionError => e
                    $stderr.puts e.message
                rescue NoMethodError => e
                    $stderr.puts e.message
                    $stderr.puts e.backtrace
                rescue Timeout::Error => e
                    $stderr.puts "Timeout encountered retrieving data for #{q}"
                rescue SystemExit,Interrupt
                    print_verbose("Ctrl-C pressed, exiting")
                    exit
                rescue StandardError => e
                    $stderr.puts e.message
                    $stderr.puts e.backtrace
                    exit
                end
            end # querys.each

            if output_style == :table
                print_table(results)
            end
        end # query_list()


        private
        def print_verbose(msg)
            if verbose
                $stderr.puts("[ #{msg} ]")
            end
        end # verbose()


        private
        def quote_if_include(str, char)
            if "#{str}".include?(char)
                "\"#{str}\""
            else
                "#{str}"
            end
        end


        private
        def print_header()
            case output_style
            when :csv
                puts attributes.map{ |a| quote_if_include(a.titleize, ',') }.join(',')
            when :tsv
                puts attributes.map{ |a| quote_if_include(a.titleize, "\t") }.join("\t")
            when :table
                print_verbose("collating data, please wait...")
            end
        end # print_header()


        private
        def print_item(result)
            case output_style
            when :csv
                puts attributes.map{ |a| quote_if_include(result[a], ',') }.join(',')
            when :tsv
                puts attributes.map{ |a| result[a] }.join("\t")
            when :list
                print_list_item(result)
            end
        end # print_item()


        private
        def print_list_item(result)
            l = attributes.map{ |a| a.length }.sort.last
            attributes.each do |a|
                printf("%-#{l}s:\t%s\n", a.titleize, result[a])
            end
            puts
        end # print_list_item()


        private
        def print_table(records)
            attr_lengths = Hash.new
            attributes.each do |a|
                l = records.map{ |r| r[a].to_s.length }.sort.last
                attr_lengths[a] = (a.length > l) ? a.length : l
            end

            # print the header row
            attributes.each do |a|
                printf("%-#{attr_lengths[a]}s  ", a.titleize)
            end
            printf("\n")
            attributes.each do |a|
                print '-' * attr_lengths[a]
                print '  '
            end
            printf("\n")

            records.each do |r|
                attributes.each do |a|
                    printf("%-#{attr_lengths[a]}s  ", r[a])
                end
                printf("\n")
            end
        end # print_table()

    end # class WhoisParser


end
