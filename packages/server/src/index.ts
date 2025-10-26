import fs from 'node:fs/promises';
import process from 'node:process';
import path from 'node:path';
import express from 'express';
import cors from 'cors';
import schedule from 'node-schedule';
import log from './middlewares/log';
import auth from './middlewares/auth';
import apiv1 from './controllers/api_v1';
import logger from './logger';
import {
    SERVER_LISTEN_HOST,
    SERVER_LISTEN_PORT,
} from './const';
import { initCubeApi } from './api/cube';
import { initAudioStore } from './store/audio';
import { printBuildinfo } from './utils/welcome';
import { getAudioCacheFilesDir, getAudioFilesDir } from './utils/etc';

logger.info('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ START @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

const {
    ENABLE_PRINT_BUILDINFO,
    ENABLE_MIDDLEWARE_LOG,
    ENABLE_MIDDLEWARE_AUTH,
} = process.env;

// Enable print build info.
if (ENABLE_PRINT_BUILDINFO === '1') {
    printBuildinfo();
}

// Init eWeLink Cube API.
initCubeApi();

// Init audio store.
initAudioStore();

const server = express();

// Enable CORS for development (allow requests from web dev server)
server.use(cors({
    origin: true,
    credentials: true
}));

server.use(express.json());

// Enable log middleware.
if (ENABLE_MIDDLEWARE_LOG === '1') {
    server.use(log);
}

// Enable auth middleware.
if (ENABLE_MIDDLEWARE_AUTH === '1') {
    server.use(auth);
}

// Serve web static files.
server.use(express.static(path.join(process.cwd(), 'public')));

// Serve audio static files.
server.use('/_audio', express.static(getAudioFilesDir()));
server.use('/_audio-cache', express.static(getAudioCacheFilesDir()));

server.use(apiv1);

server.listen(SERVER_LISTEN_PORT, SERVER_LISTEN_HOST, async () => {
    logger.info(`Server listen at port ${SERVER_LISTEN_PORT}`);

    // Init audio files dir
    const audioDir = getAudioFilesDir();
    await fs.mkdir(audioDir, { recursive: true });

    // Init audio cache files dir
    const audioCacheDir = getAudioCacheFilesDir();
    await fs.rm(audioCacheDir, { recursive: true, force: true });
    await fs.mkdir(audioCacheDir, { recursive: true });

    // Start remove audio cache files schedule
    schedule.scheduleJob('0 0 * * * *', async () => {
        try {
            const cleanTime = Date.now() - 600000;  // 10 mins ago
            const dirname = getAudioCacheFilesDir();
            const filenameList = await fs.readdir(dirname);
            const removeList = [];

            for (const filename of filenameList) {
                const fileCreateTime = filename.slice(0, -4);   // '123456.wav' -> '123456'
                if (parseInt(fileCreateTime) < cleanTime) {
                    removeList.push(path.join(dirname, filename));
                }
            }

            // Remove old files using Node.js fs instead of shell commands
            for (const file of removeList) {
                await fs.unlink(file).catch(() => {});
            }
        } catch (err: any) {
            logger.error(`(schedule) error: ${err.message}`);
        }
    });
});

// Log signal
process.on('SIGTERM', async () => {
    logger.info('................................ GOT SIGTERM ................................');
    await schedule.gracefulShutdown();
    process.exit(0);
});
