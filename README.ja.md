# Autoparts
*Nitrous.IOのためのパッケージマネージャー*

### インストール方法

Autopartsは、全てのNitrousボックスの`~/.parts/autoparts`の中に入っています。
そして、`parts` コマンドによって利用することが可能です。

もし、Autopartsがインストールされていない場合(もしくは、削除されている場合)、
以下のコマンドをコンソールから入力してください。

```sh
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
exec $SHELL -l
```

### 実行環境

* パッケージによっては、512MB以上のRAMを必要とする場合があります。

### 使用方法
※このドキュメントでは、インストール可能なパッケージを「パーツ」と呼びます。

以下のコマンドによって、全てのパーツを確認することが可能です。

    $ parts search

Autopartsはボックスが起動すると、自動的に更新されます。
しかし、必要な場合/最新でないと思われる場合は、以下のコマンドから
手動での更新が可能です。

    $ parts update

パーツのインストール(もしくはパーツの更新)を行うためには、インストールコマンドを使用します。
例えば、以下のコマンドでPostgreSQLをインストールすることができます。

    $ parts install postgresql

データベース等のいくつかのパーツは、使用のために起動が必要となります。
いくつかのボックステンプレートでは起動に際してデータベースが起動されますが、
そうでない場合は起動と停止を手動で行うことができます。

    $ parts start postgresql
    $ parts stop postgresql

全てのコマンドのリストを確認は、`parts help`を実行してください。

### Nitrous.IOでの開発

今すぐ、Nitrous.IO
[Nitrous.IO](https://www.nitrous.io/?utm_source=github.com&utm_campaign=Autoparts&utm_medium=hackonnitrous)
でこのパッケージマネージャを利用した開発を始められます。

[![Hack nitrous-io/autoparts on Nitrous.IO](https://d3o0mnbgv6k92a.cloudfront.net/assets/hack-l-v1-3cc067e71372f6045e1949af9d96095b.png)](https://www.nitrous.io/hack_button?source=embed&runtime=rails&repo=nitrous-io%2Fautoparts&file_to_open=docs%2Fcontributing.md)

### コントリビュート

View [contributing.md](https://github.com/nitrous-io/autoparts/tree/master/docs/contributing.md) for full documentation.

### その他の言語

[English](https://github.com/action-io/autoparts/blob/master/README.md)

- - -
Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).
