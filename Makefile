.PHONY: help serve start stop build clean

help:
	@echo "Blog Makefile commands:"
	@echo "  make serve   - Start Hugo development server (watch mode)"
	@echo "  make start   - Start Hugo development server in background"
	@echo "  make stop    - Stop Hugo development server"
	@echo "  make build   - Build the static site"
	@echo "  make clean   - Remove public directory"

serve:
	hugo server --logLevel debug

start:
	@echo "Starting Hugo development server..."
	hugo server --logLevel debug &
	@echo "Server started on http://localhost:1313"

stop:
	@echo "Stopping Hugo development server..."
	@pkill -f "hugo server" || echo "No running Hugo server found"

build:
	hugo --minify

clean:
	rm -rf public/

.SILENT: help
