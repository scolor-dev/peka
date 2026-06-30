# peka

最小限のWebページビューア。単一のURLをネイティブのwebviewウィンドウで開く。

## ビルド

```sh
git submodule update --init
zig build
```

Zig 0.16.0以降が必要。

Linuxではさらに `gtk-3` と `webkit2gtk-4.0` の開発パッケージが必要。

## 使い方

```sh
zig build run -- https://example.com
# または
./zig-out/bin/peka https://example.com
```

## キーボード操作

| キー | 動作 |
|---|---|
| Alt+Left / Cmd+[ | 戻る |
| Alt+Right / Cmd+] | 進む |
| F5 / Ctrl+R / Cmd+R | リロード |

## プラットフォーム対応状況

- macOS: ビルド・動作確認済み
- Windows: ビルド可能(クロスコンパイルで確認済み)。実機では未検証。実行時に `WebView2Loader.dll` が必要(Windows 10/11では標準搭載のEvergreen WebView2 Runtimeから提供される)
- Linux: ビルド設定済み、未検証
