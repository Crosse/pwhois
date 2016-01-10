pwhois
======

[![Gem Version](https://badge.fury.io/rb/pwhois.svg)](https://badge.fury.io/rb/pwhois)

`pwhois` is a small command-line utility that takes advantage of the
[Ruby Whois][whois] module to parse Whois results and display them in a
coherent style.  From their [Parsers][parsers] page:

> I know what you are thinking and the record is yes: in order to support
> all existing WHOIS servers and registrars, the Whois library should
> provide more than 500 different parsers. And this is exactly one of the
> major development goal.

This utility will not give you the full, parsed output of a whois query
(yet).  It appears that the [Ruby Whois][whois] module supports only a
subset of possible returned properties.  See the gem's
[Properties][properties] page for the list of supported properties.

*(This was a simple project to help me learn a little bit about Ruby.  If
you're a Ruby guru, please don't look too closely at the code.  Or if you
do, let me know where I could do things better.  Thanks!)*

# Installation

    $ gem install pwhois

# Usage
    $ pwhois -h
    Usage: pwhois [options]
    
    Specific options:
        -v, --[no-]verbose               Run verbosely
        -o, --output TYPE                Output style.  One of: csv, tsv, table, list
        -a, --attributes x,y,z           Attributes to return.
        -h, --help                       Show this message

# Output Styles

## CSV (Comma-Separated Values)
    $ pwhois -o csv github.com
    Domain,Created On,Updated On,Registrar Name
    github.com,2013-06-14 19:07:02 -0400,2013-11-27 07:00:15 -0500,"MarkMonitor, Inc."


## TSV (Tab-Separated Values)
    $ pwhois -o tsv github.com
    Domain  Created On      Updated On      Registrar Name
    github.com      2013-06-14 19:07:02 -0400       2013-11-27 07:00:15 -0500       MarkMonitor, Inc.


## List (Default Style)
    $ pwhois -o list github.com
    Domain        : github.com
    Created On    : 2013-06-14 19:07:02 -0400
    Updated On    : 2013-11-27 07:00:15 -0500
    Registrar Name: MarkMonitor, Inc.


## Table
    $ pwhois -o table github.com
    Domain      Created On                 Updated On                 Registrar Name     
    ----------  -------------------------  -------------------------  -----------------  
    github.com  2013-06-14 19:07:02 -0400  2013-11-27 07:00:15 -0500  MarkMonitor, Inc.  


# Multiple Queries

You can give `pwhois` a list of domains and it will return the results in
a format useful to the style.

## CSV/TSV style

The header line is printed only once:

    $ pwhois -o csv $(<domains.txt)
    Domain,Created On,Updated On,Registrar Name
    github.com,2013-06-14 19:07:02 -0400,2013-11-27 07:00:15 -0500,"MarkMonitor, Inc."
    google.com,2002-10-02 03:00:00 -0400,2014-05-19 07:00:17 -0400,"MarkMonitor, Inc."
    cnn.com,1993-09-22 00:00:00 -0400,2013-11-27 04:31:40 -0500,"CSC CORPORATE DOMAINS, INC."
    twitter.com,2000-01-21 11:28:17 -0500,2013-11-28 05:57:01 -0500,"CSC CORPORATE DOMAINS, INC."
    ruby-whois.org,2010-02-03 18:03:27 UTC,2014-03-14 01:20:28 UTC,"eNom, Inc. (R39-LROR)"


## List style

Individual records are separated by a blank line:

    $ pwhois -o list $(<domains.txt)
    Domain        : github.com
    Created On    : 2013-06-14 19:07:02 -0400
    Updated On    : 2013-11-27 07:00:15 -0500
    Registrar Name: MarkMonitor, Inc.

    Domain        : google.com
    Created On    : 2002-10-02 03:00:00 -0400
    Updated On    : 2014-05-19 07:00:17 -0400
    Registrar Name: MarkMonitor, Inc.

    Domain        : cnn.com
    Created On    : 1993-09-22 00:00:00 -0400
    Updated On    : 2013-11-27 04:31:40 -0500
    Registrar Name: CSC CORPORATE DOMAINS, INC.

    Domain        : twitter.com
    Created On    : 2000-01-21 11:28:17 -0500
    Updated On    : 2013-11-28 05:57:01 -0500
    Registrar Name: CSC CORPORATE DOMAINS, INC.

    Domain        : ruby-whois.org
    Created On    : 2010-02-03 18:03:27 UTC
    Updated On    : 2014-03-14 01:20:28 UTC
    Registrar Name: eNom, Inc. (R39-LROR)
 

## Table Style

Columns are sized appropriately for the content.  (Table output with
multiple queries will not output results until the last query is finished,
in order to figure out proper column widths.  If you want to know what's
going on, use the `-v|--verbose` option.)

    $ pwhois -o table $(<domains.txt)
    Domain          Created On                 Updated On                 Registrar Name               
    --------------  -------------------------  -------------------------  ---------------------------  
    github.com      2013-06-14 19:07:02 -0400  2013-11-27 07:00:15 -0500  MarkMonitor, Inc.            
    google.com      2002-10-02 03:00:00 -0400  2014-05-19 07:00:17 -0400  MarkMonitor, Inc.            
    cnn.com         1993-09-22 00:00:00 -0400  2013-11-27 04:31:40 -0500  CSC CORPORATE DOMAINS, INC.  
    twitter.com     2000-01-21 11:28:17 -0500  2013-11-28 05:57:01 -0500  CSC CORPORATE DOMAINS, INC.  
    ruby-whois.org  2010-02-03 18:03:27 UTC    2014-03-14 01:20:28 UTC    eNom, Inc. (R39-LROR)        


# Specifying Attributes to Print

See the [Ruby Whois][whois] documentation for the various
[properties][properties] that can be printed.  Currently there is no way to
specify *all* properties, sorry. (Note that `pwhois` and this document
refer to properties as *attributes*, because reasons.)

## Examples

The default set of attributes printed by the utility are `domain`,
`created_on`, `updated_on`, and `registrar_name`.  If you want to specify
another set of attributes you're interested in, you can do so with the
`-a|--attributes` option:

    $ pwhois -a domain,created_on,status github.com
    Domain    : github.com
    Created On: 2013-06-14 19:07:02 -0400
    Status    : registered

Note that attributes under Registrar can be specified by prepending
"registrar\_" to the attribute name.  For instance, to print the registrar
name and ID:

    $ pwhois -a domain,registrar_name,registrar_id crosse.org
    Domain        : crosse.org
    Registrar Name: eNom, Inc. (R39-LROR)
    Registrar Id  : 48

(I would like to handle `registrant_contacts`, `admin_contacts`,
`technical_contacts`, and `nameservers` similarly, but I haven't done
so yet.)

# Verbose Mode

Useful for table-style output with multiple queries, or if you just want to
see what sort of weird verbose logging I do, you can enable verbose mode:

    $ pwhois -v -o table $(<domains.txt)
    [ collating data, please wait... ]
    [ Querying whois for github.com... ]
    [ Querying whois for google.com... ]
    [ Querying whois for cnn.com... ]
    [ Querying whois for twitter.com... ]
    [ Querying whois for ruby-whois.org... ]
    Domain          Created On                 Updated On                 Registrar Name               
    --------------  -------------------------  -------------------------  ---------------------------  
    github.com      2013-06-14 19:07:02 -0400  2013-11-27 07:00:15 -0500  MarkMonitor, Inc.            
    google.com      2002-10-02 03:00:00 -0400  2014-05-19 07:00:17 -0400  MarkMonitor, Inc.            
    cnn.com         1993-09-22 00:00:00 -0400  2013-11-27 04:31:40 -0500  CSC CORPORATE DOMAINS, INC.  
    twitter.com     2000-01-21 11:28:17 -0500  2013-11-28 05:57:01 -0500  CSC CORPORATE DOMAINS, INC.  
    ruby-whois.org  2010-02-03 18:03:27 UTC    2014-03-14 01:20:28 UTC    eNom, Inc. (R39-LROR)        

Verbose output is printed to `stderr`.


# TODO

- Print datetime values in either localtime or UTC, but at least in the same
  format.
- Handle `registrant_contacts`, `admin_contacts`, `technical_contacts`, and
  `nameservers`.  Note that these are potentially arrays of things.
- Handle timeouts and ECONNRESETs in a happier fashion than dying horribly.

[whois]: http://ruby-whois.org
[properties]: http://ruby-whois.org/manual/parser/properties/
[parsers]: http://ruby-whois.org/manual/parser/
