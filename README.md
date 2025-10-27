# TTS2CUBE-Pico

TTS2CUBE-Pico is a text-to-speech service provided by Pico, which supports offline conversion. The converted voice files can be played through the browser or through the device speakers. The saved voice files can be played by the hardware speakers through linkage in the scene of eWeLink CUBE.

## iHost Volume Configuration

### Quick Start

When running this add-on on iHost, you need to configure volumes to persist your audio files and settings.

#### Step 1: Create Volume (iHost Web Interface)

1. Open **iHost Web Interface** → **Docker** → **Volumes**
2. Click **"Create Volume"**
3. Volume name: `tts2cube-data` (or any name you prefer)
4. Click **Create**

#### Step 2: Configure Add-on

1. In iHost, find **TTS2CUBE-Pico** add-on
2. Before running, click **"Configure"** or **Settings icon**
3. Go to **Volumes** section
4. Click **"Add Volume"** and configure:
   ```
   Volume Name: tts2cube-data
   Container Path: /data
   ```
5. Click **Save**

#### Step 3: Run Add-on

1. Click **"RUN"** to start the add-on
2. Your audio files will now be persisted in the volume

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
