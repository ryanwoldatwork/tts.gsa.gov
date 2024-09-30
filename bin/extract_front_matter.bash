#!/usr/bin/env bash

## @file extract_front_matter.bash
## @author TTS Website Team
## @brief extracts YAML front matter from Markdown
## @details
## The situation we encountered was that we had Markdown files that included
## YAML front matter that was improperly formatted.  The Markdown linter we
## were using ignored YAML front matter in Markdown while the YAML linter
## wasn't processing Markdown files (and if it did, the Markdown outside of
## the YAML front matter would cause it to fail.
##
## This Bash script goes line by line through a Markdown file and extracts
## the YAML front matter:
##
## Up to the first `---`, write a `#` (a comment in YAML)
## After the second `---`, do nothing
## After the first and before the second `---`, write the line
##
## Consider the following:
##
## @code
##
## ---
## title: People
## --
## I'm normal markdown
## @endcode
##
## In this case, the line starting with `title` is YAML front matter while
## the line starting `I'm` is Markdown.
##
## Running this filter on the Markdown file would yield:
##
## @code
## ---
## title: People
## ---
## @endcode
##
## The front matter could then be processed by a YAML linter without any
## Markdown gumming up the works.
##
## @par Examples
## @code
## for file in *.md ; do
##   if [ -e "$file" ] ; then
##     tempfile="${file}.yaml"
##     extact_front_matter.bash < "$file" > $"tempfile"
##     yamllint "$tempfile" | sed -Ee "s|$tempfile|$file|g"
##     rm -f "$tempfile"
##  fi
## done
## @endcode

set -euo pipefail

separators=0

while read -r line && [ $separators -lt 2 ] ; do
  if [ "$line" == "---" ] ; then
    separators=$((separators + 1))
  fi

  if [ $separators -eq 0 ] ; then
    echo "#"
  elif [ $separators -gt 0 ] ; then
    echo "$line"
  fi

done
