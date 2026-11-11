**エラトステネスの篩（Sieve of Eratosthenes）**は、
数論と素数の発見を対話的な視聴覚体験へと変換する数学ゲームおよび
リズムデモです。

## 歴史と背景

紀元前3世紀にギリシャの数学者でありアレクサンドリア図書館の
館長を務めた**キレネのエラトステネス**（紀元前276年頃–紀元前195年頃）
によって考案された「篩（ふるい）」は、すべての素数を効率的に見つけ出すための
最も直感的なアルゴリズムの一つです。

歴史的背景およびアルゴリズムの理論については、
[エラトステネスの篩に関するWikipediaの記事][wiki]をご覧ください。

## 視聴覚アナロジー

素数に固有の原子倍音が割り当てられ、合成数が和音を奏でる仕組みについては、
[視聴覚アナロジー](analogy.html)をご覧ください。

本アプリケーションはDartとFlutterで作成されています。ソースコードは
GitHub（[https://github.com/fredgc/sieve][github]）で公開されています。

不具合の報告や機能のリクエストは[GitHubのIssue][issues]までお寄せください。

その他のアプリや描画ツールは[www.gchouse.org][gchouse]でご覧いただけます。

## プライバシーとデータ保持

このプログラムでは、端末にローカル保存される設定
（SharedPreferences / LocalStorageを使用）をカスタマイズできます。
個人情報は一切収集されません。

Androidでは、アプリをアンインストールするとローカル設定が削除されます。
Webでは、ブラウザのローカルアプリケーションデータを消去すると
設定が削除されます。

[wiki]: https://ja.wikipedia.org/wiki/エラトステネスの篩

[github]: https://github.com/fredgc/sieve

[issues]: https://github.com/fredgc/sieve/issues

[gchouse]: https://www.gchouse.org
