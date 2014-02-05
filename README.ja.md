Autoparts - A Package Manager for Nitrous.IO
============================================

### 必要な条件

* **「bran」**ボックス: いくつかのパッケージは、「arya」ボックスでは正しく動作しない場合があります。今後新しく作成されるボックスはすべて「bran」ボックスになります。

  ![Bran
  box](https://raw.github.com/nitrous-io/action-assets/a7d29cbd686f2269ac930c01a8928accd19a0b89/support/screenshots/bran-box.png)

* いくつかのパッケージはメインメモリに512MB以上の空き容量を必要とする可能性があります。

### インストール

以下のコマンドをあなたのボックスのターミナルで入力してください。

```sh
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
exec $SHELL -l
```
### 使用方法

`parts help`を参照してください。

### パッケージ・ガイドライン

* インストール後のセットアップ作業(例: confファイルを作成する/空のデータベースファイルを生成する)は、
  `post_install`によって行なってください。
* 設定ファイルは、`Path.etc` (例: `~/.parts/etc`)、または`Path.etc + name` (例: `~/.parts/etc/postgresql`)
  に配置してください。
* データファイル(例: データベースファイル)は、`Path.var + name` (例: `~/.parts/var/postgresql`)
  に配置してください。
* ログファイルは、`Path.var + 'log' + "#{name}.log"` (例:`~/.parts/var/log/postgresql.log`)
  に配置してください。

- - -
Copyright (c) 2013 Irrational Industries Inc.
This software is licensed under the BSD 2-Clause license.
