# iHost Setup Guide for TTS2CUBE-Pico

This guide provides detailed instructions for setting up TTS2CUBE-Pico on your iHost device with proper volume configuration.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Volume Configuration](#volume-configuration)
3. [Add-on Installation](#add-on-installation)
4. [FileBrowser Integration](#filebrowser-integration)
5. [Uploading MP3 Files](#uploading-mp3-files)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

- iHost device (firmware 1.6.2 or later recommended)
- Access to iHost web interface
- Basic understanding of Docker concepts

## Volume Configuration

### Why Use Volumes?

Volumes ensure that your audio files, settings, and tokens persist even if the add-on is restarted or updated.

### Creating a Volume

1. **Access iHost Web Interface**
   - Open browser and navigate to `http://ihost.local` or your iHost IP address
   - Login with your credentials

2. **Navigate to Docker Volumes**
   - Click **Docker** in the sidebar
   - Select **Volumes** tab

3. **Create New Volume**
   - Click **"Create Volume"** button
   - Enter volume name: `tts2cube-data`
   - Click **Create**

### Volume Structure

After configuration, your volume will contain:

```
tts2cube-data/
├── audio/              # Persistent audio files
│   ├── 1234567890.wav
│   └── ...
├── audio-cache/        # Temporary files (auto-cleaned)
├── audio.json          # Audio metadata database
└── token.json          # eWeLink CUBE authentication token
```

## Add-on Installation

### Method 1: From Docker Hub (Recommended)

1. **Open iHost Docker**
   - Navigate to **Docker** → **Add-ons**

2. **Search for Add-on**
   - Search for `tts2cube-pico` in Docker Hub
   - Or enter the full image name if provided by the developer

3. **Configure Before Running**
   - Click the **Settings** icon (⚙️) before running
   - **DO NOT** click "RUN" yet!

4. **Configure Network**
   - Network Mode: `bridge`
   - Port Mapping: `8323:8323`

5. **Configure Volumes**
   - Click **"Add Volume"**
   - Fill in:
     ```
     Volume Name: tts2cube-data
     Container Path: /data
     ```
   - Click **Save**

6. **Configure Environment Variables** (Optional)
   - Most variables have sensible defaults
   - You can customize:
     ```
     LOG_LEVEL=info
     ENABLE_MIDDLEWARE_LOG=1
     ```

7. **Run the Add-on**
   - Click **"RUN"** to start
   - Check logs for successful startup

### Method 2: Manual Docker Command

If you prefer command-line:

```bash
# Create volume
docker volume create tts2cube-data

# Run container
docker run -d \
  --name tts2cube-pico \
  --network bridge \
  -p 8323:8323 \
  -v tts2cube-data:/data \
  -e CONFIG_CUBE_HOSTNAME=ihost \
  -e CONFIG_AUDIO_DATA_PATH=/data \
  -e CONFIG_TOKEN_DATA_PATH=/data \
  your-dockerhub-username/tts2cube-pico:latest
```

## FileBrowser Integration

FileBrowser allows you to upload MP3 files and manage audio files directly.

### Installing FileBrowser

1. **Install FileBrowser Add-on**
   - Navigate to **Docker** → **Add-ons**
   - Search for `filebrowser/filebrowser`
   - **DO NOT run yet!**

2. **Configure FileBrowser Volumes**
   - Click **Settings** icon
   - Network Mode: `bridge`
   - Port Mapping: `8080:80` (or any available port)
   - **Add Volume:**
     ```
     Volume Name: tts2cube-data  (same as TTS2CUBE-Pico!)
     Container Path: /srv
     ```
   - Click **Save**

3. **Run FileBrowser**
   - Click **"RUN"**

4. **Find Login Password**
   - Click on FileBrowser container
   - Go to **Logs** tab
   - Look for: `Generated password: <password>`
   - Note down the password

5. **Access FileBrowser**
   - Open browser: `http://ihost.local:8080`
   - Username: `admin`
   - Password: (from logs)

### Connecting to Shared Volume

Once logged into FileBrowser:

1. You'll see the `/srv` directory
2. This is the same as `/data` in TTS2CUBE-Pico
3. Navigate to `/srv/audio/` to access audio files

## Uploading MP3 Files

### Via FileBrowser Web Interface

1. **Access FileBrowser**
   - Navigate to `http://ihost.local:8080`
   - Login with credentials

2. **Navigate to Audio Directory**
   - Click on `/srv`
   - Click on `audio/` folder

3. **Upload Files**
   - Click **Upload** button (⬆️)
   - Select your MP3 file(s)
   - Wait for upload to complete

4. **Verify Upload**
   - Files should appear in the list
   - You can rename, delete, or organize files

### Via API (Future Feature)

In the future, you'll be able to upload files via REST API:

```bash
# Not yet implemented - coming soon!
curl -X POST http://ihost.local:8323/api/v1/audio/upload \
  -F "file=@/path/to/music.mp3" \
  -F "label=My Music"
```

## Troubleshooting

### Issue: "Host Volume" Won't Change

**Problem:** Volume type shows "Host Volume" and cannot be changed.

**Solution:** This is **normal** behavior on iHost. "Host Volume" means the volume is stored on iHost's disk, which is exactly what you want. Don't try to change it.

### Issue: Files Disappear After Restart

**Problem:** Audio files are lost when add-on restarts.

**Solution:**
1. Check if volume is properly configured
2. Verify volume name matches: `tts2cube-data`
3. Verify container path is: `/data`
4. Make sure you clicked **Save** after adding volume

### Issue: Cannot Access FileBrowser

**Problem:** FileBrowser login fails or page doesn't load.

**Solution:**
1. Check FileBrowser is running (green status in Docker)
2. Verify port mapping (e.g., `8080:80`)
3. Try accessing via IP: `http://192.168.x.x:8080`
4. Check FileBrowser logs for errors

### Issue: FileBrowser Password Not Found

**Problem:** Cannot find generated password in logs.

**Solution:**
1. Stop FileBrowser add-on
2. Delete FileBrowser container (not the volume!)
3. Reinstall FileBrowser add-on
4. Immediately check logs after first start
5. Look for "password" or "admin" in logs

### Issue: MP3 Files Not Playing

**Problem:** Uploaded MP3 files don't play in TTS2CUBE-Pico.

**Solution:**
1. TTS2CUBE-Pico currently only supports **WAV** files generated by TTS
2. MP3 files need to be converted to WAV format
3. Use an API endpoint to handle uploads (future feature)
4. Or manually convert: `ffmpeg -i input.mp3 output.wav`

### Issue: Volume Permission Denied

**Problem:** Cannot write to volume directory.

**Solution:**
1. Check volume exists: iHost → Docker → Volumes
2. Verify both containers use the same volume name
3. Try recreating the volume
4. Check container logs for permission errors

## Advanced Configuration

### Multiple Volumes (Optional)

For better organization, you can create separate volumes:

```
TTS2CUBE-Pico Configuration:
- Volume 1: tts2cube-audio → /data/audio
- Volume 2: tts2cube-config → /data

FileBrowser Configuration:
- Volume 1: tts2cube-audio → /srv/audio
- Volume 2: tts2cube-config → /srv/config
```

### Backup and Restore

To backup your audio files:

1. Access FileBrowser
2. Navigate to `/srv/audio/`
3. Select all files
4. Click **Download** to create a zip archive

To restore:

1. Upload the zip file to FileBrowser
2. Extract in the `/srv/audio/` directory

## Support

For issues or questions:

- Check the [GitHub Issues](https://github.com/your-repo/issues)
- Visit eWeLink Forum: [CUBE Add-ons](https://forum.ewelink.cc/)
- Check official documentation

## Next Steps

After successful setup:

1. Access TTS2CUBE-Pico web interface: `http://ihost.local:8323`
2. Generate your first TTS audio
3. Create automation scenes in eWeLink CUBE
4. Enjoy your text-to-speech system!
