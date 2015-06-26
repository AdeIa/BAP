#!/bin/bash

saxon-xslt ./data/fond1.xml ./lib/merge.xslt with=fond2.xml dontmerge=record > ./data/result3.xml

rm ./data/fond1.xml ./data/fond2.xml
