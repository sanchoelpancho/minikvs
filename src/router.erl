-module(router).
-export([routes/0]).

routes() ->
    [
        {'_', [
            {"/kvs/:key", kvs_handler, []},  % GET /kvs/{key}, DELETE /kvs/{key}
            {"/kvs", kvs_handler, []}          % POST /kvs
        ]}
    ].