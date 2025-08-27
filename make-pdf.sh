#!/bin/sh
# assumes "weasyprint" has been installed (available from EPEL).

out=profile.pdf

weasyprint profile.html $out && ls -l $out

