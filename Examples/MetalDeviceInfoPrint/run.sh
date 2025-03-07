#!/bin/sh

run_jdb() {
	./MetalDeviceInfoPrint |
		jq |
		dasel --read=json --write=toml |
		bat --language=toml
}

which jq     | fgrep -q jq    || exec ./MetalDeviceInfoPrint
which dasel  | fgrep -q dasel || exec ./MetalDeviceInfoPrint
which bat    | fgrep -q bat   || exec ./MetalDeviceInfoPrint

run_jdb
