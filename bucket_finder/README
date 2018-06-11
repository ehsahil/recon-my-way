Bucket Finder
=============

Copyright(c) 2011, Robin Wood <robin@digininja.org>

This project goes alongside my blog post "Whats In Amazon's Buckets?"
http://www.digininja.org/blog/whats_in_amazons_buckets.php , read through that
for more information on what is going on behind the scenes.

This is a fairly simple tool to run, all it requires is a wordlist and it will
go off and check each word to see if that bucket name exists in the Amazon's
S3 system. Any that it finds it will check to see if the bucket is public,
private or a redirect.

Public buckets are checked for directory indexing being enabled, if it is then
all files listed will be checked using HEAD to see if they are public or private.
Redirects are followed and the final destination checked. All this is reported
on so you can later go through and analyse what has been found.

Version
=======
1.0 - Release
1.1 - Added logging to file

Installation
============
I don't think it needs anything more than the built in modules so you shouldn't
need to install any gems. Just grab the file, make it executable and run it.

I've tested it in Ruby 1.8.7 and 1.9.1 so there should be no problems with versions.

Usage
=====
Basic usage is simple, just start it with a wordlist:

./bucket_finder.rb my_words

and it will go off and do your bidding.

You can specify which region you want to run the initial check against by using
the --region parameter:

./bucket_finder.rb --region ie my_words

The script will follow all redirects anyway so even if left at default, US Standard,
everything will be found that can be found but if most of the buckets you are
finding are in a different region then you'll be doing a lot of redirects so doubling
your network traffic.

You can also specify the --download option to download all public files found. Be
careful with this as there are a lot of large files out there. I'd personally do
the general search then only use this option with a select subset of bucket names:

./bucket_finder.rb --download --region ie my_words

The files are downloaded into a folder with the bucket name and then the appropriate
structure from the bucket. 

As some people are having trouble piping the output to files or other apps I've added
a logging option to send all output to a file. To use this just use the --log-file 
parameter:

./bucket_finder.rb --log-file bucket.out my_words

Licence
=======
This project released under the Creative Commons Attribution-Share Alike 2.0
UK: England & Wales

( http://creativecommons.org/licenses/by-sa/2.0/uk/ )
