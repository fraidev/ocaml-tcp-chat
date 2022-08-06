# OCaml TCP Chat

Install dependencies:

```
opam switch create . 4.14.0 --no-install
opam install . --deps-only --with-test
```


Execute the server:

```
dune exec bin/server/server.exe
```

Execute the client: 

```
dune exec bin/client/client.exe
```
