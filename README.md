# CFG_BACKUP

CFG_BACKUP is a tool for backup robot configuration from CA UIM, written in BASH and LUA. It will rotate backups on every run, keeps 4 rotations in disk.
It was made using NSA from CA UIM repository, I suppose that any LUA compiler will work; don't know. Just put NSA (Nimsoft Script Agent) binary into directory bin.

## Installation

Clone repository into one hub (to gain access to robots) and run it from there.

```bash
git clone project
```

## Files to edit
```
vi lua/modules/my_login.lua     ## Credentials
vi config/backup_conf.sh        ## General config
vi config/hubs.txt              ## HUBS to interrogate
```

## Usage
Just run from bash interactiveley or by cron

## Contributing
Feel free to fork.

