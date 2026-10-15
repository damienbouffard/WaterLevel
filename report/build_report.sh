#!/bin/sh
# Build the PDF reports (normal and large font figures) from the Markdown source.
# Usage: sh report/build_report.sh   (from the repository root)
set -e
cd "$(dirname "$0")/.."

# large font version: same text, figures replaced by their *_large.png copies
sed -E 's#(!\[[^]]*\]\([^)]+)\.png\)#\1_large.png)#' lake_levels_2026_report.md > lake_levels_2026_report_large.md

for name in lake_levels_2026_report lake_levels_2026_report_large; do
  pandoc "$name.md" -o "$name.pdf" \
    --pdf-engine=xelatex --resource-path=. \
    --lua-filter=report/figure_captions.lua --shift-heading-level-by=-1 \
    --include-in-header=report/preamble.tex \
    -V mainfont="Helvetica Neue" -V geometry:margin=2.2cm -V geometry:headheight=14pt \
    -V fontsize=11pt -V colorlinks=true -V linkcolor=blue -V urlcolor=blue
  echo "built $name.pdf"
done
