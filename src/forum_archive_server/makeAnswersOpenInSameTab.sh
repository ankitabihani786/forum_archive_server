#!/usr/bin/env bash

#------------------------------------------------
#
# Changes all wordclouds/week*/index.html files so that
# they will cause the question/answers to open in the
# same browser tab as the wordcloud when a word is clicked.
#
# Before any changes, the index.html file is copied to
# index.htmlOLD, unless that file already exists.
#
# Action: replaces the 'target="wordcloud"' attribute
#         in each imagemap to 'target="_self"'
#
# Can safely be run many times.
#
#------------------------------------------------

# Find paths to index.html below the 'wordclouds' directory
# that is assumed to reside in the same dir as this script:

find wordclouds -name index.html | while read EXISTING_INDEX_FILE; do

    echo "Processing wordcloud file '${EXISTING_INDEX_FILE}'"

    # Construct a path to a filename for saving the original index.html:
    SAVED_FILE_NAME=$(dirname ${EXISTING_INDEX_FILE})/index.htmlORIG

    # Only copy index.html to the save-file if that file doesn't
    # already exist:

    if [[ ! -e ${SAVED_FILE_NAME} ]]
    then
        echo "     Saving wordloud file to ${SAVED_FILE_NAME}..."
        cp ${EXISTING_INDEX_FILE} ${SAVED_FILE_NAME}
    fi

    # Make the wordcloud file corrections:
    #   sed #1: add import of javascript ../../js/wordclouds.js in <head>
    #   sed #2: add onclick="cloudClick(this)" to each <area> entry
    #   sed #3: change target in each <area> from "wordcloud" to "_self"
    #       so that result pages open in same browser tab as wordcloud:

    cat ${SAVED_FILE_NAME} | \
         sed 's|</head>|<script type="text/javascript" src="../../js/wordclouds.js"></script></head>|' | \
         sed 's/<area /<area onclick="cloudClick(this)" /p' |\
         sed 's/target="wordcloud"/target="_self"/p' > ${EXISTING_INDEX_FILE}
done
echo "Done."

