#!/usr/bin/env sh
go install cuelang.org/go/cmd/cue@latest

EJSON_PUBLIC_KEY="5df4cad7a4c3a2937a863ecf18c56c23274cb048624bc9581ecaac56f2813107"
EJSON_KEY_PATH="$HOME/.config/ejson/keys/$EJSON_PUBLIC_KEY"

if [! -f "$EJSON_KEY_PATH" ]; then
	curl -Ls https://github.com/Shopify/ejson/releases/download/v1.4.1/ejson_1.4.1_linux_amd64.tar.gz | tar xz --directory ~/.local/bin ejson
	mkdir -p "$HOME"/.config/ejson/keys
	op read op://Personal/ejson/"$EJSON_PUBLIC_KEY" --out-file "$EJSON_KEY_PATH"
fi

EJSON_KEYDIR=~/.config/ejson/keys chezmoi apply --init
