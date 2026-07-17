-module(kvs_router).
-export([routes/0]).

routes() ->
    [
        {'_', [
            {"/kvs/:key",   kvs_key_handler, []},            % GET /kvs/{key}, DELETE /kvs/{key}
            {"/kvs",        kvs_entry_handler, []}          % PUT /kvs
        ]}
    ].