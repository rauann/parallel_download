#!/bin/bash
cd parallel_download
mix deps.get
MIX_ENV=test mix compile
echo " "
echo "Running tests..."
mix test --trace