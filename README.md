# Real time message protocol (RMTP)


- This is a flutter demo that shows how to publish live camera feed into any rtmp server (twitch, facebook, custom, etc...)

- to test this demo, you need a running rtmp server, that you will be publishing video/audio stream to it, and then play the stream from the player.

- The simple-real-time-server has a good implementation of an rtmp server.

```zsh
cd simple-real-time-server
```
```zsh
docker run --rm -it -p 1935:1935 ossrs/srs:5
```

- This command will start the server locally, and then the mobile apps are configured to publish-to/player-from it.
