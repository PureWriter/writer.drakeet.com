---
title: 純純執筆（Pure Writer）の使い方ガイド - 純純執筆
description: 純純執筆（Pure Writer）の使い方を、インストールしたばかりの方向けに使い始める順にまとめました。本と文章の作り方、ショートカットバー、Markdown、履歴、クラウドバックアップ、同期、書き出しの入り口を版ごとに紹介します。
date: 2026-11-13
lastmod: 2026-11-13
url: blog/getting-started/
jsonld: article
---

<!--
  博客文章：纯纯写作使用教程（日文版）。底本是简体母稿 index.zh-hans.md，为日本读者重写，不是逐句翻译。
  定位：回答「純純執筆 使い方」「Pure Writer 使い方」。写给刚装上纯纯写作的人的入门导览：按「第一次打开之后会依次用到什么」
  编排成路线图，每一步只写做什么、入口在哪里，细节链接到英文手册的对应问答（官网没有日文手册，链接注明（英語））。不写价格与宣传语。
  与简体母稿的差别：
  - 下载按日文首页：Android 版只给 Google Play，iOS 版给 App Store，桌面版给日文パソコン版页；
  - 删去「中国大陆的用户推荐使用阿里云盘」与支付宝；账号一问按英文手册「Is there a limit to the number of devices…」
    「Can I use a membership bought on one platform on another?」的意思写，不提支付宝；
  - 格式化选项的例子去掉「在汉字与英文之间插入空格」「简繁转换」，只留空行与段首缩进；「繁化姬」按英文手册
    「When your text is sent over the internet」的说法写明只在界面语言为中文时出现；
  - Markdown 教程只有简体中文，改指英文手册的「Pure Writer Markdown User Guide」；备份教程改指英文版；
  - 新增「困ったときは」里的日文 iOS 支持页链接。
  关于纯纯写作的事实取自简体使用手册（与简体母稿的出处相同，见母稿开头的注释），另有日文首页的「ダウンロード」一节、
  日文 iOS 版介绍页的「動作環境・無料体験・メンバーシップ」、日文パソコン版页。
  界面名称一律取自三端的日文资源，逐项出处：
  - Android（values-ja/strings.xml）：settings 設定；createNew 新しい文章（menu_sheet_overflow.xml）；category フォルダ；trash ゴミ箱；
    searchArticles 文章を検索 / 文章へすばやくジャンプ；createShortcutLabel ショートカットを作成；findReplace 検索と置換；redo やり直す；
    spacingsAndMargins 行間・左右の余白；typewriterMode タイプライター；themesAndPapers テーマと背景；formatters「書式オプション\n一括整形」（「⋮」中的菜单项，两行；formatterAction 一括整形）；history 履歴；backupSettingTitle バックアップとクラウドの同期；
    cloudConnection クラウド接続タイプ；signIn ログイン；previewAndExport プレビュー ＆ エクスポート（PDF、長い画像、docx、epub）…；
    exportBook 本を一つのファイルにまとめて出力；
  - iOS（Localizable.xcstrings 的 ja）：settingsTitle 設定；sidebarNewArticle 新しい文章；overflowSearchArticles 文章を検索 / 目的の文章へすばやく移動；
    shortcutItem ショートカット（快捷输入栏末尾「＋」按钮的文字）；overflowFindReplace 検索と置換；shortcutUndo 元に戻す；shortcutRedo やり直す；
    overflowSpacingsAndMargins 行間・左右余白；settingsTypewriterMode タイプライターモード；settingsTheme テーマ；
    overflowFormatters 書式オプション・ワンタップ整形；formattingOneTap ワンタップ整形；markdownSwitchToMarkdown Markdown に切り替え；
    overflowPreviewAndExport プレビュー / PDF・縦長画像・DOCX・EPUB として保存…；overflowHistory 履歴；backupTitle バックアップとクラウド同期；
    backupCloudDriveRow クラウドドライブ；backupICloudTitle iCloud にバックアップ；bookExportTitle まとめて書き出す；booksTrashName ゴミ箱；
  - 桌面版（res/Japanese.kt）：settings 設定；insertNewTextBelow この下に新しい文章を挿入；toggleBottomDrawer ボトムバーの切り替え；
    redo やり直し；font フォント；paragraphSpacing 段落間隔；formatterOptionsTooltip 書式設定オプション（F5：一括整形）（顶栏按钮的提示文字；正文只引用前半，F5 快捷键手册没写，不提）；
    plainText プレーンテキスト；history 履歴；cloudBackupScreenTitle バックアップとクラウド同期。
  Android 顶栏的「⋮」与 iOS 的「…」按日文 iOS 支持页的写法用符号表示，不引用名称。
  维护：手册改了相关说法（入口、菜单名、各端差异、导出格式、Pro 的范围），或三端的日文界面文字改了，这里跟着改。
  页内目录是手写的，各节的 id 写在标题后面，改标题时不必改 id。
-->

# 純純執筆（Pure Writer）の使い方ガイド

純純執筆をインストールしたばかりの方に向けて、使い始めてから順に必要になる機能を並べました。各ステップでは何をするか、どこから操作するかだけを書き、詳しい説明は[ユーザーマニュアル](/en/manual/)（英語）に譲ります。Android 版、iOS 版、パソコン版で操作が異なるところは、版ごとに書き分けています。

1. [ダウンロードとインストール](#install)
2. [本、フォルダ、文章](#books)
3. [最初の文章を書く](#first-article)
4. [入力を快適にする](#input)
5. [表示を整える](#layout)
6. [書式オプションと Markdown](#markdown)
7. [履歴で以前の原稿を取り戻す](#history)
8. [最初の日にクラウドバックアップを設定する](#backup)
9. [複数の端末で同期する](#sync)
10. [書き出し](#export)
11. [困ったときは](#help)

## ダウンロードとインストール {#install}

- **Android 版**：[Google Play](https://play.google.com/store/apps/details?id=com.drakeet.purewriter) からインストールします。基本機能は無料で、一部の機能には純純執筆 Pro が必要です。
- **iOS 版**：[App Store](https://apps.apple.com/app/id6803257195) からダウンロードします。iOS 26 または iPadOS 26 以降が必要です。ダウンロード後 7 日間は、すべての機能を無料でお試しいただけます。体験期間の終了後に文章の編集と新規作成を続けるには、サブスクリプションか永久メンバーシップが必要です（[iOS 版の紹介](/ja/ios/)）。
- **パソコン版**：[純純執筆 パソコン版](/ja/desktop/)のページからダウンロードします。現在は無料で使えます。

## 本、フォルダ、文章 {#books}

- **本**：いちばん外側のまとまりで、たとえば長編小説 1 作、日記 1 冊です。書名をタップすると本の一覧が開き、ほかの本に切り替えられます。書名は Android 版では画面上部、iOS 版では画面下部、パソコン版ではウィンドウ左上にあります。
- **文章**：本の中の一つひとつの文章で、サイドバーの文章リストに並びます。
- **フォルダ**：本の中のグループで、章ごとに文章をまとめられます。Android 版では、フォルダは手動で並べ替えているときだけ表示されます。

誤って削除した文章は、「ゴミ箱」から元に戻せます。

## 最初の文章を書く {#first-article}

新しい文章を作るには、Android 版は右下の ⊕ をタップしてメニューの「新しい文章」を、iOS 版は右下の「＋」をタップして「新しい文章」を選びます。パソコン版は、サイドバーの文章を右クリックして「この下に新しい文章を挿入」を選びます。文章は自動で保存されるので、保存の操作は要りません。

文章を探すには、Android 版は右上の「⋮」の「文章を検索 / 文章へすばやくジャンプ」、iOS 版は右上の「…」のパネルの「文章を検索 / 目的の文章へすばやく移動」を使います。パソコン版はトップバーの検索ボタンか Esc キーです。覚えている一文を入力すれば見つかります（[マニュアル](/en/manual/#search-articles--jump-to-articles-quickly)、英語）。

## 入力を快適にする {#input}

- **ショートカットバー**：キーボードの上のバーに、人物名やかぎかっこ「」などのよく使う文字や、取り消し、やり直し、ワンタップ整形などの操作を置けます。追加するには、Android 版はバーの「⊕ ショートカットを作成」、iOS 版は「＋ ショートカット」をタップします。パソコン版はトップバーの「ボトムバーの切り替え」で表示し、内容はスマートフォンで編集して同期します（[マニュアル](/en/manual/#shortcut-bar)、英語）。
- **検索と置換**：Android 版は「⋮」、iOS 版は「…」のパネルで「検索と置換」を選ぶと、文章をまたいで置換できます（Android 版の置換には純純執筆 Pro が必要です）。パソコン版は Ctrl+F（macOS では Command+F）で、現在の文章だけが対象です（[マニュアル](/en/manual/#find--replace-in-texts)、英語）。
- **取り消しとやり直し**：iOS 版は、右上の文章の形式を表示しているボタンのメニューに「元に戻す」と「やり直す」があります。Android 版の「やり直す」は「⋮」のパネルの下部、パソコン版の「やり直し」は右クリックメニューにあり、キーボードショートカットも使えます（[マニュアル](/en/manual/#redo-content-that-was-mistakenly-undone)、英語）。

## 表示を整える {#layout}

| | Android 版・iOS 版 | パソコン版 |
|---|---|---|
| フォントと文字サイズ | 「設定」のフォントと文字サイズの各項目 | 「設定 › フォント」 |
| 行間、段落の間隔、左右の余白 | 「設定 › 行間・左右の余白」（Android 版）、「設定 › 行間・左右余白」（iOS 版） | 「段落間隔」のオン・オフのみ。ウィンドウが広いときは左右に自動で余白ができる |
| タイプライターモード | 「設定」の「タイプライター」（Android 版）、「タイプライターモード」（iOS 版） | この淡色表示の機能はない |

エディタの背景（用紙）は、Android 版は「設定 › テーマと背景」、iOS 版は「設定 › テーマ」で変えられます。タイプライターモードでは、カーソルのある段落だけが通常どおり表示され、ほかの文字は淡くなります（[タイプライターモードとは？](/ja/blog/typewriter-mode/)）。

## 書式オプションと Markdown {#markdown}

純純執筆の本文はプレーンテキストで、文字を直接太字にはできません。全体を整えるには書式オプションを、見出しや太字が必要なときは Markdown を使います。

**書式オプション**は、余分な空行を取り除く、段落の頭に字下げを入れる、といった整理を全体に一度で行います。よく使う整理をまとめて実行する「ワンタップ整形」（Android 版とパソコン版では「一括整形」）もあります。Android 版は「⋮」の「書式オプション」、iOS 版は「…」のパネルの「書式オプション・ワンタップ整形」、パソコン版はトップバーの「書式設定オプション」ボタンから使い、結果が気に入らなければ取り消せます。

**Markdown** は `**太字**` や `# 見出し` のような記号で書式を示す書き方で、文章ごとに切り替えます。

- **Android 版**：トップバー右側の `TXT` アイコンをタップします。右下の ⊕ の横にある小さな `M↓` ボタンでプレビューできます。
- **iOS 版**：エディタ右上の文章の形式を表示しているボタンをタップし、「Markdown に切り替え」を選びます。仕上がりは「…」のパネルの「プレビュー / PDF・縦長画像・DOCX・EPUB として保存…」で確認します。
- **パソコン版**：ウィンドウ下部のステータスバーにある「プレーンテキスト」をクリックし、「Markdown」を選びます。パソコン版には今のところプレビューがありません。

書き方は[マニュアルの Markdown ガイド](/en/manual/#pure-writer-markdown-user-guide)（英語）にあります。

## 履歴で以前の原稿を取り戻す {#history}

書き直しに失敗したり消しすぎたりしたときは、「履歴」でその文章が最近保存された版をプレビューし、元に戻せます。Android 版は「⋮」、iOS 版は「…」のパネルから、パソコン版はトップバーの「履歴」ボタンから開きます。履歴はその端末にだけ保存され、件数にも上限があるので、バックアップの代わりにはなりません（[マニュアル](/en/manual/#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history)、英語）。

## 最初の日にクラウドバックアップを設定する {#backup}

純純執筆は端末の中に自動でバックアップを作りますが、文章と同じ端末にあるため、端末をなくしたり壊れたりすると一緒に失われます。iOS 版の本体のバックアップは、App を削除したときにも削除されます。最初の日にクラウドドライブに接続しておけば、以後はバックアップが自動でアップロードされます。

- **Android 版**：「設定 › バックアップとクラウドの同期」で「クラウド接続タイプ」をタップしてクラウドドライブを選び、「ログイン」します。
- **iOS 版**：「設定 › バックアップとクラウド同期 › クラウドドライブ」でクラウドドライブを連携します。このほか「iCloud にバックアップ」もあり、システムの iCloud が使えるときは初期設定でオンになっています。
- **パソコン版**：ウィンドウ右上のクラウドのアイコンをクリックし、「バックアップとクラウド同期」ウィンドウでクラウドドライブにログインします。

3 つの版とも Dropbox、OneDrive、AliyunDrive に対応しています。画面つきの手順は[バックアップのチュートリアル](/en/backups/)（英語）にあります。

## 複数の端末で同期する {#sync}

各端末で同じクラウドドライブの同じアカウントに接続し、「クラウド同期」をオンにすると、スマートフォンとパソコンの間で文章が同期されます（[手順と注意点](/ja/blog/sync-writing-between-phone-and-computer/)）。

## 書き出し {#export}

- **Android 版・iOS 版**：1 つの文章は、Android 版は「プレビュー ＆ エクスポート（PDF、長い画像、docx、epub）…」、iOS 版は「プレビュー / PDF・縦長画像・DOCX・EPUB として保存…」から、TXT、MD、PDF、DOCX、EPUB、画像として保存できます。本をまるごと書き出すには、サイドバーのメニューで「本を一つのファイルにまとめて出力」（Android 版）、「まとめて書き出す」（iOS 版）を選びます（TXT、DOCX、EPUB）。Android 版のこの 2 つには純純執筆 Pro が必要です。
- **パソコン版**：今のところ文章を書き出すことはできません。

詳しくは[マニュアル](/en/manual/#is-it-possible-to-save-the-article-as-docx-or-epub)（英語）をご覧ください。

## 困ったときは {#help}

[ユーザーマニュアル](/en/manual/)（英語）と[純純執筆 iOS 版 サポート](/ja/ios/support/)をご確認ください。解決しないときは、[writer@drakeet.com](mailto:writer@drakeet.com) までメールでお問い合わせください。

## よくある質問 {#faq}

### 純純執筆を使うのに、アカウント登録は必要ですか？

書くためにアカウント登録は必要ありません。純純執筆のアカウントは一部のメンバーシップの管理に使うもので、Google Play や App Store で購入した場合は不要です。パソコン版もログインせずに使えます。クラウドバックアップとクラウド同期には、純純執筆のアカウントとは別に、ご自身のクラウドドライブのアカウントを使います。

### 純純執筆にパソコン版はありますか？

あります。Windows と macOS に対応し、現在は無料で使えます。[純純執筆 パソコン版](/ja/desktop/)のページからダウンロードでき、クラウドドライブを通じてスマートフォンと同期します。

### 純純執筆は iPhone や iPad で使えますか？

使えます。純純執筆 iOS 版は App Store で配信中で、iOS 26 または iPadOS 26 以降の iPhone と iPad に対応しています。ダウンロード後 7 日間は、すべての機能を無料でお試しいただけます。

### 純純執筆の文章はどこに保存されますか？

文章と本体のバックアップは、端末の中に保存されます。クラウドドライブに接続すると、バックアップはご自身のクラウドドライブにアップロードされます。iOS 版は、システムの iCloud が使えるとき、初期設定で自動バックアップをご自身の iCloud にも保存します。ご自身で使う一部のオンライン機能（アプリの言語が中国語のときに表示される「繁化姬」の変換と、Android 版の AI 機能）を除き、文章が純純執筆のサーバーに送られることはありません（[マニュアル](/en/manual/#is-there-a-risk-of-articles-being-leaked-by-using-pure-writer)、英語）。
