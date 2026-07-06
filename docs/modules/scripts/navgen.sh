#!/usr/bin/env sh
find * -type f -name \*.adoc -exec echo "* xref:{}[]" \; | xclip
find * -type f -name nav.adoc -exec echo "- {}" \; | xclip
