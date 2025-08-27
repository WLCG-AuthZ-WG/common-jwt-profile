#!/bin/sh
# Assumes "pandoc" has been installed (available from EPEL).
# As its current HTML-to-PDF engine is unsupported since several years,
# we let it convert just to HTML and do the PDF conversion elsewhere.
# We first need to fix and adjust a few things in the HTML, though.

out=profile.html
keep='https:\S+|(compute\.\w+ *)+|(storage\.\w+:/\S* *)+|scope|wlcg\.groups|(/\w+)+'

pandoc --ascii -o $out -css profile.css profile.md &&
    perl -i -pe '
	s/(href="#)(\d+-)/$1s$2/;
	if (s/^(<h[1-6] +id=")([^"]+">)((\d+\.)+)/$1s$3-$2$3/) {
	    while (s/^(<h[1-6] +id="[^"]*)\./$1/) {
	    }
	}
	s,&#x201C\;('"$keep"')&#x201D\;,"$1",g;
	s,\xE2\x80\x9C('"$keep"')\xE2\x80\x9D,"$1",g;
	s/\xE2\x80\x9C/&ldquo\;/g;
	s/\xE2\x80\x9D/&rdquo\;/g;
	s/\xE2\x80\x98/&lsquo\;/g;
	s/\xE2\x80\x99/&rsquo\;/g;
	s/\xE2\x80\x94/&mdash\;/g;
	s/\xC2\xA0/&nbsp\;/g;
	s/(<a [^>]+>)\xE2\x86\xA9\xEF\xB8\x8E/&nbsp\;&nbsp\;&nbsp\;$1&#x21A9\;/g;
	s/(<a [^>]+>&#x21A9\;)/&nbsp\;&nbsp\;&nbsp\;$1/g;
    ' $out &&
    ls -l $out

