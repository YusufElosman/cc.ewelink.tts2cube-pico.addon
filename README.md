# TTS2CUBE-Pico

TTS2CUBE-Pico is a text-to-speech service provided by Pico, which supports offline conversion. The converted voice files can be played through the browser or through the device speakers. The saved voice files can be played by the hardware speakers through linkage in the scene of eWeLink CUBE.

## Development

### Linux/Mac

1. Init dev environment

    ```
    ./scripts/bootstrap.sh
    ```

2. Start server

    ```
    ./scripts/start-server.sh
    ```

3. Start web dev server

    ```
    ./scripts/start-web.sh
    ```

### Windows

1. Init dev environment

    ```
    .\scripts\bootstrap.bat
    ```

2. Start server

    ```
    .\scripts\start-server.bat
    ```

3. Start web dev server

    ```
    .\scripts\start-web.bat
    ```

## Build

### Linux/Mac

Run the following command to build this addon.

```
./scripts/build.sh
```

### Windows

Run the following command to build this addon.

```
.\scripts\build.bat
```
