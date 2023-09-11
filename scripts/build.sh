#!/usr/bin/env bash

# Disable LSPs to have more RAM
"$REPL_HOME/scripts/disableSvelteServer.sh"

# Run the SvelteKit build adapter
pnpm run build

# Reenable LSPs
"$REPL_HOME/scripts/enableSvelteServer.sh"
