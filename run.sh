#!/bin/bash
cd parallel_download
mix deps.get
mix compile
echo " "
echo "Running solution..."
echo " "

if [ "$#" -eq "0" ]
  then
    URLS="http://google.com http://www.bing.com http://inactive-domain.blah htpp://not-a-web-url"
  else
    URLS=$@
fi

mix run -e "ParallelDownload.run()"  $URLS
