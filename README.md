# BattleBit Docker

# :warning: HIGHLY EXPERIMENTAL :warning:

### How to run:

1. Copy the `.env.example` to the `config/` folder, rename it to `.env` and set steam username and password (make sure 2FA is off)
2. Start the containers with `docker compose up -d` after configuring the server inside `config/server.conf`
3. Success!


# FAQ

### I'm getting the error `Couldn't read the package, Disconnected from master server ()`.
 => You're not whitelisted or your firewall prevents the GameServer from registering on the Master server

### I can't connect to my server, I have `Error while joining: NoResponse` on the top left on my screen.
 => Something prevents you from connecting to the GameServer, It could be your firewall, using wrong ports or not forwarding them correctly.
    1. Make sure you are using the good ports (the one you gave to Oki, and the same port +1)
    2. The game uses udp port, make sure the ports are open in your firewall (ufw for example)

### I can't connect to my server, I have `Failed to connect! : CODE [NoResponse : 1]` in the loading screen.
 => This docker uses ApiEndpoint in the launch args :
   1. If you want an API, make sure you're using the right ip:port, if you're running your API server on the host, the IP should be `172.17.0.1`
   2. If you don't want to use an API, delete the line `"-ApiEndpoint=$ApiEndpoint"` from `run.sh`
