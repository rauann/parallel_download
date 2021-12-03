# ParallelDownload

The ParallelDownload application uses elixir processes to perform GET requests on a list of URLs.

It uses the Elixir Task module to spawn and await processes executions for each given URL.

The parallelism/concurrent execution of the GET requests is achieved by the Erlang VM schedulers
that allocate CPU time from all cores to the running processes.

The application was built as a Mix application to facilitate the modules accesses and test setup.

The Tesla (https://hexdocs.pm/tesla/readme.html) library is used as an HTTP client and was chosen
due to the easy test mock setup provided.

An library called ValidUrl (https://hexdocs.pm/valid_url/readme.htmll) is used to validate the URLs
before the each request.

## How to run

At the same level of the project dir you can run `./run.sh` to run the application with the default
URLs (http://google.com http://www.bing.com http://inactive-domain.blah htpp://not-a-web-url)

It is also possible to run the application for other URLs passing them as arguments, e.g.:
`./run.sh http://www.youtube.com/`

The tests can be executed running `./test.sh`


