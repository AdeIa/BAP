#!/bin/bash
saxon-xslt ./data/result$1.xml ./lib/merge.xslt with=fond$1.xml dontmerge=record > ./data/result$2.xml

rm ./data/result$1.xml ./data/fond$1.xml

