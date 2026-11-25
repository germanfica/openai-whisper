
ifeq ($(OS),Windows_NT)
	SHELL := cmd.exe
	.SHELLFLAGS := /C
	UV := uv
	PYTHON := .venv\Scripts\python.exe
else
	SHELL := /bin/bash
	UV := $(shell command -v uv 2>/dev/null || printf '%s/.local/bin/uv' "$$HOME")
	PYTHON := .venv/bin/python
endif

APP := main.py

.PHONY: setup install-uv run test clean reset

setup: install-uv
	@echo Installing Python...
	@"$(UV)" python install

	@echo Installing dependencies...
	@"$(UV)" sync --locked

	@echo Project ready.

install-uv:
ifeq ($(OS),Windows_NT)
	@where uv >nul 2>&1 || (echo ERROR: Install uv with scoop install uv & exit /b 1)
else
	@if command -v uv >/dev/null 2>&1; then \
		echo "uv is already installed."; \
	elif [[ -x "$(HOME)/.local/bin/uv" ]]; then \
		echo "uv is already installed."; \
	else \
		command -v curl >/dev/null 2>&1 || { \
			echo "ERROR: curl is required."; \
			exit 1; \
		}; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
	fi
endif

run: setup
	@"$(PYTHON)" "$(APP)" $(ARGS)

test: setup
	@"$(PYTHON)" "$(APP)" --help

clean:
ifeq ($(OS),Windows_NT)
	@if exist .venv rmdir /s /q .venv
	@if exist build rmdir /s /q build
	@if exist dist rmdir /s /q dist
else
	@rm -rf .venv build dist
endif

reset: clean
	@$(MAKE) setup