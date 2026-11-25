# open-whisper

## Prerequisites

- Python 3.10.22
- uv
- FFmpeg

## Install

```
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

```
uv sync --locked
```

## Usage

```bash
whisper "audio.mp3" --language Japanese --model small
```

```bash
uv run whisper "audio.mp3" --language Japanese --model small
```
