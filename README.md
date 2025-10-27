# TTS2CUBE-Pico

TTS2CUBE-Pico is a text-to-speech service provided by Pico, which supports offline conversion. The converted voice files can be played through the browser or through the device speakers. The saved voice files can be played by the hardware speakers through linkage in the scene of eWeLink CUBE.

## iHost Volume Configuration

### Quick Start

This add-on automatically requests volume configuration when you run it on iHost.

#### Step 1: Install and Run Add-on

1. In **iHost**, find and install **TTS2CUBE-Pico** add-on from Docker Hub
2. Click **"RUN"** - iHost will automatically prompt you to configure volumes

#### Step 2: Configure Volume (Automatic Prompt)

When you click "RUN", iHost will show volume configuration:

1. **Volume for `/data`** will be requested automatically
2. You can either:
   - **Create new volume:** Enter a name like `tts2cube-data`
   - **Use existing volume:** Select from dropdown
3. Click **Save** and **Run**

#### Step 3: Verify

1. Add-on will start with persistent volume
2. Audio files will be saved and persist across restarts
3. Access files via FileBrowser (see below)

### Volume Paths

The add-on uses the following paths inside the container:

- `/data/audio/` - Saved audio files (persistent)
- `/data/audio-cache/` - Temporary cache files (auto-deleted)
- `/data/audio.json` - Audio metadata database
- `/data/token.json` - eWeLink CUBE token storage

### Accessing Files with FileBrowser

To upload MP3 files or access audio files directly:

1. Install **filebrowser/filebrowser** add-on on iHost
2. Configure FileBrowser volumes:
   ```
   Volume Name: tts2cube-data (same volume as TTS2CUBE-Pico!)
   Container Path: /srv
   ```
3. Run FileBrowser and access via web interface
4. Navigate to `/srv/audio/` to manage audio files

**Default Login:**
- Username: `admin`
- Password: Check FileBrowser logs for generated password

### Using docker-compose (Local Development)

For local development, use the provided `docker-compose.yml`:

```bash
# Edit docker-compose.yml with your image name
docker-compose up -d

# View logs
docker-compose logs -f

# Stop
docker-compose down
```

## Development

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

## Build

Run the following command to build this addon.

```
./scripts/build.sh
```
