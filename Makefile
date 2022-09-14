GO_FLAGS   ?=
NAME       := k9s
OUTPUT_BIN ?= execs/${NAME}
PACKAGE    := github.com/derailed/$(NAME)
GIT_REV    ?= $(shell git rev-parse --short HEAD)
DATE       ?= $(shell python -c 'from datetime import datetime, timezone, timedelta; print(datetime.now(timezone(timedelta(hours=+0))).isoformat())')
VERSION    ?= v0.26.3
IMG_NAME   := derailed/k9s
IMAGE      := ${IMG_NAME}:${VERSION}

default: help

test: ## Run all tests
	@go clean --testcache && go test ./...

cover: ## Run test coverage suite
	@go test ./... --coverprofile=cov.out
	@go tool cover --html=cov.out

build: test ## Builds the CLI
	@go build ${GO_FLAGS} \
	-ldflags "-w -s -X ${PACKAGE}/cmd.version=${VERSION} -X ${PACKAGE}/cmd.commit=${GIT_REV} -X ${PACKAGE}/cmd.date=${DATE}" \
	-a -tags netgo -o ${OUTPUT_BIN} main.go

haha:
	@echo ${DATE}

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":[^:]*?## "}; {printf "\033[38;5;69m%-30s\033[38;5;38m %s\033[0m\n", $$1, $$2}'
