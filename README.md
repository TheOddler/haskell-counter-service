Haskell Counter App (Tech Interview)
------------------------------------

This was a tech interview assignment where I needed to make a simple service to count keys and return the count.

# How to run

Note: I'm using Nix as the package manager, channel 22.11.

## Tests


1. Get into the nix-shell so you have all required dependencies: `nix-shell`
2. Run `cabal test --test-show-details=direct`

## Server

1. Get into the nix-shell so you have all required dependencies: `nix-shell`
2. Setup postgresql: `initdb -D ./db -U postgres`
    * Make sure to create the user `postgres` as that's the default we'll use
3. Start postgresql: `postgres -D ./db`
    * You may have to create the `/run/postgres` folder (`sudo mkdir /run/postgresql`)
    and give it the needed permissions (`sudo chmod 777 /run/postgresql/`)
4. (In different shell, so open `nix-shell` again) start the server: `cabal run`

Then you can query the server:

```
curl --request GET 'localhost:9000/query?key=test'
```

```
curl --request POST 'localhost:9000/input' \
  --header 'Content-Type: application/json' \
  --data-raw '"test"'
```
