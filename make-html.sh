#!/bin/sh
# Assumes "pandoc" has been installed (available from EPEL).
# As its current HTML-to-PDF engine is unsupported since several years,
# we let it convert just to HTML and do the PDF conversion elsewhere.
# Replace binary unicode sequences: some PDF converters cannot handle them.

out=profile.html
keep='(compute\.\w+ *)+|(storage\.\w+:/\S* *)+|scope|wlcg\.groups|(/\w+)+'

pandoc -o $out -css profile.css profile.md &&
    perl -i -pe '
	s/^(<h[1-6] +id="[^"]*)\./$1/;
	s,\xE2\x80\x9C('"$keep"')\xE2\x80\x9D,"$1",g;
	s/\xE2\x80\x9C/&ldquo\;/g;
	s/\xE2\x80\x9D/&rdquo\;/g;
	s/\xE2\x80\x98/&lsquo\;/g;
	s/\xE2\x80\x99/&rsquo\;/g;
	s/\xC2\xA0/&nbsp\;/g;
	s/(<a [^>]+>)\xE2\x86\xA9\xEF\xB8\x8E/&nbsp;&nbsp;&nbsp;$1&#x21A9\;/g;
    ' $out

