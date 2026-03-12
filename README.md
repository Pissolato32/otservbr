# Dockerized TFS 0.4 (Tibia 8.60)

This project provides a complete, dockerized setup for Open Tibia Server using The Forgotten Server (TFS) version 0.4 for Tibia protocol 8.60.

## Requirements
- Docker
- Docker Compose

## Technical Deviations & Decisions
To guarantee a successful compile and execution, the following technical choices were made:

1. **Repository Choice:** The official `otland/forgottenserver` repository largely focuses on modern protocols. To ensure stability and support for CMake and the 8.60 datapack, we utilize the community fork `fir3element/3777` pinned to commit `29eb7a67e6994950687967f5afb69c39b04dd622`.
2. **Lua Version:** The engine is compiled against `liblua5.1-0-dev` rather than `liblua5.4-dev`. TFS 0.4 C++ code uses Lua 5.1 C APIs, which break in 5.4.
3. **MySQL Authentication:** MySQL 8.0 defaults to `caching_sha2_password` which breaks older C++ MySQL connectors. The container is configured with `--default-authentication-plugin=mysql_native_password` to allow TFS to authenticate successfully.

## ⚠️ MANUAL STEP REQUIRED: Map Download
Because large `.otbm` files are typically excluded from source control:
1. Ensure the `./data/world` directory is generated on your host by starting the container once (`docker compose up -d`).
2. Download a global 8.60 map (e.g., from [tibiamaps.io](https://tibiamaps.io)).
3. Rename the downloaded `.otbm` file to `forgotten.otbm`.
4. Place it inside the `./data/world/` directory.

## File Auto-Generation Note
When you run `docker compose up -d` for the first time, Docker will mount the empty host `./data` directory into the container. The `init-db.sh` startup script will detect this, and automatically copy the default 8.60 datapack into the mounted volume so you can edit it locally!

It will do the same for `schema.sql`. Note that due to how Docker handles single-file mounts, you might see `schema.sql/` show up as a directory on your host. Simply delete it and grab the real file from inside the container or let the script auto-fix it from within.

## Folder Structure
- `Dockerfile`: Configuration for building the TFS environment and compiling the source.
- `docker-compose.yml`: Defines `db` (MySQL), `otserver` (TFS), and `adminer`.
- `init-db.sh`: Entrypoint script ensuring the database is initialized idempotently and missing datapack files are seeded to the host.
- `config.lua`: Automatically loads environment variables and configures TFS.

## How to Start the Server
1. Start the services using Docker Compose:
   ```bash
   docker compose up -d --build
   ```
2. To view logs:
   ```bash
   docker compose logs -f otserver
   ```
3. If the server complains about a missing map, perform the manual step mentioned above and restart.

## How to Connect
1. Download a Tibia Client for version **8.60** (can be found on OTClient repositories or archive sites).
2. Set your login IP to `127.0.0.1` (localhost).
3. The server uses default ports `7171` for login and `7172` for game.

## Database & Account Management
1. Open [http://localhost:8080](http://localhost:8080) to access **Adminer**.
2. **System:** MySQL
   **Server:** `db`
   **Username:** `tibia`
   **Password:** `yourpassword`
   **Database:** `tibia`
3. **Default GM Account:** The server uses the `accountManager` logic inside `config.lua`. You can also manually insert an account via Adminer by creating a record in the `accounts` table with `type=5` (God) and tying it to a `players` row with `group_id=3`. Please check standard OTLand wiki/tutorials for TFS 0.4 password hashing (usually plaintext or SHA1 depending on your `config.lua` choice, currently defaulting to standard behavior).

## Customizing Datapack
All files in `./data/` are mounted into the container. You can edit XML or Lua scripts on your local machine. Restart the server container for changes to take effect:
```bash
docker compose restart otserver
```
