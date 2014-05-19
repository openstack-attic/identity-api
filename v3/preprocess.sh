#!/bin/sh

# Converts the Markdown source into DocBook format suitable for using
# in the Maven build process.
#
# Adapted from:
#   https://wiki.openstack.org/wiki/Documentation/Builds#Markdown_and_DocBook

SOURCES=`ls src/markdown/*.md`
FILENAME=identity-api-v3
DIRPATH=.

XSL=/usr/share/xml/docbook/stylesheet/docbook5/db4-upgrade.xsl

pandoc -f markdown -t docbook -s $SOURCES | \
    xsltproc -o - $XSL - | \
    xmllint --format -| \
    sed -e "s,<article,<chapter xml:id=\"$FILENAME\"," | \
    sed -e 's,</article>,</chapter>,' > ${DIRPATH}/$FILENAME.xml
