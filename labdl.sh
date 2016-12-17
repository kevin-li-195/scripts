#!/bin/bash

HASPATH=0
HASURL=0
P=
URL=
CLIPBOARD=0

while (( $# )) ; do
    case "$1" in
        "-c")
            if [ $CLIPBOARD -eq 1 ] ; then
                echo "an explicit URL was set so clipboard mode cannot be " \
                    "used" >&2
                exit 1
            fi
            CLIPBOARD=1
            ;;
        *)
            if [ $HASPATH -eq 0 ] ; then
                HASPATH=1
                P="$1"
            elif [ $HASURL -eq 0 ] ; then
                if [ $CLIPBOARD -eq 1 ] ; then
                    echo "clipboard mode was set so an explicit URL cannot " \
                        "be provided" >&2
                    exit 1
                fi
                HASURL=1
                URL="$1"
            else
                echo "unexpected command line argument" >&2
                exit 1
            fi
    esac
    shift
done

if [ $CLIPBOARD -eq 1 ] ; then
    URL="$(xclip -o)"
    echo "URL from clipboard: $URL"
    HASURL=1
fi

if [ $HASPATH -eq 0 -a $HASURL -eq 0 ] ; then
    echo "both a path and a URL are needed" >&2
    exit 1
fi

curl -v \
    --data "{ \"url\": \"$URL\", \"path\": \"$P\" }" \
    -H "Content-Type: application/json" \
    http://labcoders.club:8082/download
