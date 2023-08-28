# BattleBit Docker

### :warning: HIGHLY EXPERIMENTAL :warning:

### How to run:
**1.** Copy the `.env.example` to the `config/` folder, rename it to `.env` and set steam username and password (make sure 2FA is off)<br>

**2.** Change the `port` to your servers port inside the `docker-compose` file and also make sure you add one port above it (`30000` and `30001` in the example file).<br>

**3.** Start the containers with `docker compose up -d` after configuring the server inside `config/server.conf`<br>

**4.** Success!<br>

---

### FAQ

- [Question: I'm getting the error 'Couldn't read the package, Disconnected from the master server ()'.](#question-im-getting-the-error-couldnt-read-the-package-disconnected-from-master-server)
- [Question: I can't connect to my server, I have 'Error while joining: NoResponse' on the top left of my screen.](#question-i-cant-connect-to-my-server-i-have-error-while-joining-noresponse-on-the-top-left-of-my-screen)
- [Question: I can't connect to my server, I have 'Failed to connect! : CODE [NoResponse : 1]' on the loading screen.](#question-i-cant-connect-to-my-server-i-have-failed-to-connect--code-noresponse--1-on-the-loading-screen)

### Question: I'm getting the error `Couldn't read the package, Disconnected from master server`.
Answer ➜ You're not whitelisted or your firewall prevents the GameServer from registering on the Master server.

### Question: I can't connect to my server, I have `Error while joining: NoResponse` on the top left of my screen.
Answer ➜ Something prevents you from connecting to the GameServer. It could be your firewall, using the wrong ports, or not forwarding them correctly.
    1. Make sure you are using the correct ports (the ones you provided to Oki, and the same port +1).
    2. The game uses UDP ports, so ensure the ports are open in your firewall (e.g., ufw).

### Question: I can't connect to my server, I have `Failed to connect! : CODE [NoResponse : 1]` on the loading screen.
Answer ➜ This Docker uses ApiEndpoint in the launch args:
   1. If you want to use an API, make sure you're using the correct `IP:port`. If you're running your API server on the host, the IP should be `172.17.0.1`.
   2. If you don't want to use an API, delete the line "-ApiEndpoint=$ApiEndpoint" from `run.sh`.
