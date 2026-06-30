# AGENTS.md

## プロジェクト概要

peka は最小限を目標としたWebページ閲覧アプリ（Ghosttyのターミナルエミュレータと同じ思想のWebブラウザ版）。汎用ブラウザではなく、CLIから渡した単一URLをネイティブのwebviewウィンドウで表示するだけのツール。Zig + webview ライブラリで実装し、macOS / Windows / Linux に対応する。

## 開発ルール

- Zig version: 0.16.0+（`build.zig.zon` の `.minimum_zig_version` を参照）。
- `README.md` を編集した場合は、必ず `README.ja.md` にも同じ変更を反映すること。
