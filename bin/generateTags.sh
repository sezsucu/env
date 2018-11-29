#!/usr/bin/env bash

ETAGS_COMMAND=`which etags`
if [ -e TAGS ]; then
    \rm TAGS
fi
eval find . -name "*.cxx" -o -name "*.hxx" -o -name "*.cpp" -o -name "*.cc" -o -name "*.h" -o -name "*.hh" -o -name "*.hpp" -o -name "*.c" | xargs $ETAGS_COMMAND --append --declarations --language=c++
