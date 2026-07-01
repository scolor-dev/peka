# peka

[日本語](README.ja.md)

Minimal web page viewer. Opens a single URL in a native webview window.

## Build

```sh
git submodule update --init
zig build
```

Requires Zig 0.16.0+.

Linux additionally requires `gtk-3` and `webkit2gtk-4.0` dev packages.

## Usage

```sh
zig build run -- https://example.com
# or
./zig-out/bin/peka https://example.com
```

## Keyboard

| Key | Action |
|---|---|
| Alt+Left / Cmd+[ | Back |
| Alt+Right / Cmd+] | Forward |
| F5 / Ctrl+R / Cmd+R | Reload |

## Platform status

- macOS: built and tested
- Windows: built and tested. Needs `WebView2Loader.dll` available at runtime (ships with Windows 10/11 by default via the Evergreen WebView2 Runtime).
- Linux: build configured, untested
