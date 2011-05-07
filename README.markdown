# ruby-alibris 

Wrapper for the [Alibris](http://developer.alibris.com/) API, the premier online marketplace for independent sellers of new
and used books, music, and movies, as well as rare and collectible titles.

Travis CI: [![Build Status](http://travis-ci.org/rupakg/ruby-alibris.png)](http://travis-ci.org/rupakg/ruby-alibris)

## Installation

    gem install ruby-alibris

## Features

The [Alibris](http://developer.alibris.com/) API consists of three main features, namely:

* [Search method](http://developer.alibris.com/docs/read/Search_Method)
* [Recommendations method](http://developer.alibris.com/docs/read/Recommendations_Method)
* [Reviews method](http://developer.alibris.com/docs/read/Reviews_API)

This wrapper library provides access to that functionality in an easy and intuitive manner.

### The Search method

The Search object wraps up the [Search method](http://developer.alibris.com/docs/read/Search_Method) of the Alibris API.
The results that are returned are called 'works' in Alibris' terminology. The 'works' are of types books, music and videos.
The Search object can search across all types of works or specifically against books, music or videos. The search object
provides convenient helper methods for other operations like search by author, by title and by topic.

You can find more about the [Search method](http://developer.alibris.com/docs/read/Search_Method) at Alibris' site.

### Usage

The Search object can be instantiated by providing the Alibris API key, and optionally the output type and the number of
results that the search should return. The allowed output types are xml and json, xml being the default, while the default
number of results returned is 25.

Require the wrapper library:

    require 'alibris'

For example, to create a Search object with output type set to 'json', and limit number of results returned to the default value of 25, do:

    s = Alibris::Search.new(:api_key => "your_alibris_api_key_here", :output_type => "json")

And, to create a Search object with output type set to 'json' and limit number of results returned to 10, do:

    s = Alibris::Search.new(:api_key => "your_alibris_api_key_here", :output_type => "json", :num_results => 10)

Let's see some examples, for searching books:

    # search for books by search term
    results = s.books("photography")
    results.work.first.title    # => "Making Movies"
    results.work.first.author   # => "Lumet, Sidney"

    # search for books by author
    results = s.books_by_author("Dan Brown")
    results.work.first.title    # => "The Lost Symbol"

    # search for books by title
    results = s.books_by_title("The Fountainhead")
    results.work.first.author   # => "Rand, Ayn"

    # search for books by topic
    results = s.books_by_topic("Religion")
    results.work.last.author   # => "Hardwick, Susan"
    results.work.last.title    # => "God of freedom"

The Search object adds some functionality by taking values passed via options, as follows:

a) sorting options: {:qsort => value}, which can be,

* r = rating/price (books searches only), default
* t = title, tr = title reverse
* a = author, ar = author reverse
* p = price, pr = price reverse
* d = date (year), dr = date reverse

b) number of results returned: {:chunk => integer}

c) number of results to skip: {:skip => integer}

And, some more examples using options as described above:

    # search for books by author and sorted by title
    results = s.books_by_author("Dan Brown", {:qsort => 't'})
    results.work.last.author   # => "Brown, Dan, and Spence, Cathryn"
    results.work.last.title    # => "Bath: City on Show"

    # search for books by author and sorted by title in reverse
    results = s.books_by_author("Dan Brown", {:qsort => 'tr'})
    results.work.last.author   # => "Brown, Dan"
    results.work.last.title    # => "The Da Vinci Code: Illustrated Screenplay"

    # search for books by author and sorted by title, with only 10 results returned
    results = s.books_by_author("Dan Brown", {:qsort => 't', :chunk => 10})
    results.work.last.author   # => "Birlew, Dan, and Brown, Damon"
    results.work.last.title    # => "Resident Evil 4"

Similarly, some examples, for searching music:

    # search for music by search term
    results = s.music("rock")
    results.work.first.title    # => "Live at the Troubadour"
    results.work.first.author   # => "Carole King & James Taylor"

    # search for music by author
    results = s.music_by_author("The Beatles")
    results.work.last.title    # => "With the Beatles"

Similarly, some examples, for searching videos:

    # search for videos by search term
    results = s.videos("kids")
    results.work.first.title    # => "The Kids Are All Right"
    results.work.first.author   # => "Lisa Cholodenko"

    # search for videos by author
    results = s.videos_by_author("Lisa Cholodenko")
    results.work.last.title    # => "Laurel Canyon"

*Note*: You can apply the options for sorting, number of results returned and number of results skipped as described
for books to music and videos as well.

## Roadmap

1. Implement the other methods from Alibris API:

* Recommendations method
* Reviews method

2. Update the wrapper library to work with output type 'xml'. Currently, only 'json' is supported.

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 [Rupak Ganguly](http://rails.webintellix.com). See LICENSE for details.
