---
title: Pure Writer User Manual
description: This manual introduces the features of Pure Writer for Android, iOS, and desktop (Windows and macOS), and helps you troubleshoot and solve problems you run into in everyday use.
lastmod: 2026-11-07
---

<!--
  使用手册（英文）。旧地址 /wiki_en，服务器 301 到这里；Android 版的帮助入口按地区打开它。

  来历：2026-11-07 官网重建的第 F 步，据改写后的简体中文手册（index.zh-hans.md）整份重做，问答与简体一一对应。
  只适合中国大陆、或只在简体中文界面出现的内容不写（docs/content.md 第七节）：
  - 支付宝付费与激活码：「通过 Google Play 购买与通过支付宝购买有什么区别？」「可以从第三方购买纯纯写作激活码吗？」
    「为什么之前囤积的激活码不能使用了？」三条不写，其余问答里提到支付宝与激活码的句子也删去。
  - 纯纯写作账号的登录与找回密码：Android 只在支付宝付费方式下出现账号登录（Pro.kt 的 isChinaMainlandMode），
    iOS 的登录入口只在简体中文界面显示（iOS 仓库 docs/pro-account.md 3.1），所以「为什么重新登录纯纯写作账号后激活状态消失了？」
    「忘记纯纯写作账号的密码怎么办？」两条不写，其余问答里引导去登录账号的句子也删去。
    登录设备数量与注销账号两条保留：已经登录的账号各语言都可能有，注销的方法要能查到。
  - 坚果云一组：「为什么坚果云的 WebDAV 不能登录？」与 403、503、流量三条不写。「错误提示：WebDAV 云存储账号或密码错误」也不写：
    这条提示只在中文界面出现（Android cloud/WebDAV.kt 判断 isZh），其余内容都是坚果云的。
    「为什么纯纯写作如今不再推荐使用坚果云？」改成通用的「Why doesn’t Pure Writer recommend WebDAV anymore?」。
  - 「纯纯写作可以使用百度网盘备份吗？」改成通用的问法，沿用旧英文页「Can I use [insert cloud drive provider name]…」的 id。
  - 蓝奏云备用下载、360 的提示、「中国大陆的用户推荐使用阿里云盘」一句。
  Android 的 AI 服务照英文界面写：简体界面的「自行提供的国产 AI 服务」，英文界面叫「OpenAI」。
  改动记录在 iOS 仓库不入库的 evidence/website-rebuild-2026-11/manual-review/（简体的改动总览与逐条记录）。

  写法：
  - 只写各端已经发布的现行行为，与简体同一口径。几端都适用的问答按端分写，用「**Android**:」「**iOS**:」「**Desktop**:」
    开头的列表项或段落，各端相同的合起来写（「**Android and iOS**:」）；只与一端有关的问答，在标题末尾注明「(Android)」。
  - 核心对象称 document，书内分组称 folder（iOS 仓库 docs/terminology.md）；Android 侧栏的「Add chapter above」等照界面原文。
  - 界面名称照各端英文界面的实际写法（Android values/strings.xml、iOS Localizable.xcstrings 的 en、桌面版 res/StringRes.kt），
    用弯引号括起，菜单路径用 ›；动作写 tap（手机）、click（电脑）、touch and hold、right-click。
    三端叫法不同时分别写出，例如少数派选项：Android 叫「Fine-tuning」，iOS 叫「Advanced Options」，桌面版叫「Advanced options」。
    只在中文界面出现的条目（带「繁化姬」字样的转换、Android 注销账号的入口）照中文原样引用。
  - 网盘统一写 AliyunDrive（iOS 与桌面版的英文界面、英文版 iOS 隐私政策都这样写；Android 英文界面写作「Aliyun Drive」），
    三家并列时按 Android 与桌面版英文界面的顺序写 OneDrive、Dropbox、AliyunDrive；专讲 iOS 时照 iOS 英文界面的顺序
    Dropbox、OneDrive、AliyunDrive。
  - 示例改成英文读者习惯的写法：快捷输入项的括号与引号、日期格式表的结果（英文的月份、星期与上午下午，补了 MMM 与 MMMM）、
    下划线在词中不生效的例子、页内跳转的标题。中文特有的问题（全角空格缩进、全角标点旁的星号）照写，例子保留中文。

  锚点与结构：
  - 保留下来的问答沿用旧英文页（069a297:wiki_en.html，Typora 生成）的 id，写在标题后面；标题措辞改了，id 也不改。
    旧页「Table of Contents」标题的 id 写在目录前一段的 <p> 上，站外的旧链接仍落在目录处。
  - 旧英文页没有对应条目的问答（简体新增的，或旧英文页本来就缺的）不写 id，由 Hugo 按标题生成；
    目录与页内链接里的这些 id 取自构建产物，改这些标题时要一并改链接。
  - 删掉的条目，id 不再出现：footnote、connection-between-devices-is-not-stable、auto-connect-doesnt-work、
    ghosting-effect-of-text-in-pure-writer-desktop、clicking-outline-links-in-time-machine-only-opens-books-list、
    easter-eggs、easter-eggs-in-pure-writer。
  - 整页一个 h1；各章 h2；每条问答 h3；问答内部再分层用 h4（「About shortcut actions」、WebDAV 一组的各条、
    Markdown 使用指南的各节，与简体相同）。开头的目录是手写的嵌套列表，收各章、各问答与这几类 h4，不收问答内部的小标题。

  几处标记的缘由：
  - hugo.toml 关闭了 typographer，弯引号与撇号直接写在源文件里。
  - 示例本身含三个反引号的代码块，外层用四个反引号围起来。
-->

# Pure Writer User Manual {#pure-writer-user-manual---omit-in-toc---}

This manual introduces the features of Pure Writer for Android, iOS, and desktop (Windows and macOS), and helps you troubleshoot and solve problems you run into in everyday use. Features and steps differ between the apps, so the answers cover each app separately where needed; a question that concerns only one app names it at the end of its title.

The manual has five parts: [Pure Writer Q&A](#pure-writer-qa), [Pure Writer Backup & Sync FAQ](#pure-writer-backup--sync-faq), [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide), [Pure Writer Markdown FAQ](#pure-writer-markdown-faq), and [Pure Writer Desktop FAQ](#pure-writer-desktop-alpha-faq).

<p id="table-of-contents---omit-in-toc---">To find a question, use your browser’s find-in-page feature: press Ctrl+F on a computer (Command+F on a Mac); in a mobile browser, look for an option such as “Find in page” in the menu.</p>

- [Pure Writer Q&A](#pure-writer-qa)
  - [About the word count options](#about-different-modes-of-word-count)
  - [Using Pure Writer in landscape](#about-landscape-mode)
  - [Why is paragraph spacing turned off in very long documents? (Android)](#why-is-paragraph-spacing-turned-off-in-very-long-documents-android)
  - [How to use the shortcut bar](#shortcut-bar)
    - [About shortcut actions](#about-shortcuts)
  - [Where does the cursor land after a shortcut is inserted?](#about-cursors-position-of-text-shortcuts)
  - [How do I insert the current time with a shortcut?](#insert-current-time-through-text-shortcuts)
  - [About status bar focus mode (Android)](#hide-status-bar-and-its-known-issues)
  - [About Formatting options](#about-formatting-tools)
  - [How do I find and replace text?](#find--replace-in-texts)
  - [How do I search for a document?](#search-articles--jump-to-articles-quickly)
  - [Is there a length limit for a single document?](#is-there-a-word-limit-for-one-single-chapter)
  - [How do I see when a document was created or last updated?](#how-can-i-check-the-time-created--modified-of-a-chapter)
  - [How do I open an external file?](#opening-external-documents)
  - [Why can’t I open or import a very large file?](#cannot-open--import-a-document-that-is-too-large)
  - [Why isn’t the default font the system font?](#why-isnt-the-default-font-the-system-font)
  - [How do I change the font and font size?](#custom-font-and-font-size)
  - [What if the cursor at the end of a paragraph sits in the middle of the last character?](#what-if-the-cursor-at-the-end-of-a-paragraph-sits-in-the-middle-of-the-last-character)
  - [Will the built-in font be updated?](#will-the-built-in-font-be-updated)
  - [How do I make the text semi-transparent? (Android)](#change-the-transparency-of-the-text)
  - [How do I adjust the left and right margins?](#adjust-the-left-and-right-margin-of-the-text)
  - [How do I adjust line and paragraph spacing?](#adjust-line--paragraph-spacing)
  - [Why can’t text be justified?](#is-it-possible-to-justify-the-text)
  - [The text is hard to read after I changed the paper background](#legibility-issues-after-changing-themes--wallpapers)
  - [Can I change the color of the text?](#is-it-possible-to-change-the-color-of-the-text)
  - [How do I redo something I undid by mistake?](#redo-content-that-was-mistakenly-undone)
  - [How do I restore an earlier version of a document from History?](#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history)
  - [How long is History kept? Is it included in backups?](#how-long-is-history-kept-is-it-included-in-backups)
  - [Why is only one paragraph or line of my text clear?](#only-one-line--paragraph-of-the-article-can-be-clearly-seen)
  - [Can I export to .docx, .epub, or other formats?](#is-it-possible-to-save-the-article-as-docx-or-epub)
  - [Exported TXT files show garbled text in a reader app](#articles-exported-by-this-app-cannot-be-displayed-correctly-in-other-apps)
  - [Why does the sidebar show only titles or the first line of the text?](#why-does-the-sidebar-show-only-titles-or-the-first-line-of-the-text)
  - [Why can’t I create a folder, or where did my folders go? (Android)](#why-cant-i-create-a-folder-or-where-did-my-folders-go-android)
  - [What is typewriter mode?](#typewriter-mode)
  - [What is advanced read-only mode? (Android)](#read-only-mode)
  - [How do I turn on advanced read-only mode? (Android)](#turn-on-read-only-mode)
  - [How do I turn off advanced read-only mode? (Android)](#turn-off-read-only-mode)
  - [How do I insert a new document somewhere else?](#insert-a-new-article-at-different-positions)
  - [About Fine-tuning and Advanced Options](#options-for-the-few-people)
  - [Why does Fine-tuning require payment?](#why-does-fine-tuning-require-payment)
  - [Colors look wrongly inverted (Android)](#the-interface-gets-abnormally-color-inverted)
  - [Why do I see “This is a Pro feature”? (Android)](#this-is-a-pro-feature-pop-ups)
  - [A Pro prompt keeps appearing when I open the app](#a-pro-prompt-keeps-appearing-when-i-open-the-app)
  - [Can I use Pure Writer without buying Pro?](#is-there-a-huge-feature-loss-without-pure-writer-pro)
  - [Why do my custom paper backgrounds stay in the list? (Android)](#how-does-this-app-keep-my-custom-wallpapers)
  - [Are paper backgrounds restored from a backup?](#are-wallpapers-saved-in-backups)
  - [Can I customize the background of exported images?](#is-it-possible-to-customize-the-background-when-saving-articles-as-images)
  - [Why does the indent look wrong?](#something-is-wrong-with-indent)
  - [Why aren’t my paragraphs indented anymore?](#no-indentation-when-writing)
  - [Why are documents exported as .md files?](#cannot-save-as-txt-file-only-md-is-shown)
  - [Can I use Markdown and LaTeX in Pure Writer?](#use-markdown--latex-in-the-app)
  - [About the Markdown panel](#markdown-panel)
  - [Can Pure Writer render Markdown as I type?](#is-it-possible-to-render-markdown-in-real-time-in-this-app)
  - [The app takes a long time to open](#it-takes-too-much-time-to-open-the-app)
  - [The app lags or freezes when I switch to the Trash or a book](#app-freezes-when-switching-to-trash-or-other-books)
  - [Can I make text bold or insert images?](#is-it-possible-to-insert-bold-text-or-images-in-articles)
  - [Why does “Skip” appear, or a new document get created, when I open Pure Writer? (Android)](#the-app-automatically-creates-an-article--prompts-me-to-skip-on-startup)
  - [Is there a limit to the number of devices signed in to a Pure Writer account?](#is-there-a-limit-to-the-number-of-devices-that-can-log-into-a-pure-writer-account-at-the-same-time)
  - [Can I use a membership bought on one platform on another?](#can-i-use-a-membership-bought-on-one-platform-on-another)
  - [Google Play payment won’t start when I try to buy (Android)](#google-play-payment-wont-start-when-i-try-to-buy-android)
  - [Why does Pro sometimes become inactive after I bought it on Google Play? (Android)](#pure-writer-pro-is-lost-but-i-have-paid-for-it-on-google-play)
  - [How do I cancel a subscription?](#how-do-i-cancel-a-subscription)
  - [Why can’t I start a new line with Enter on ChromeOS, FydeOS, or some Android x86 devices?](#cannot-use-enter-to-insert-line-breaks-on-chromebooks-or-android-x86-devices)
  - [Text has outlines on an E Ink device (Android)](#text-has-outlines-on-an-e-ink-device-android)
  - [Why can’t everything be customized?](#cannot-customize-some-of-the-features-in-the-app)
  - [Is there an iOS version of Pure Writer?](#is-there-an-ios-version-of-pure-writer)
  - [Could my writing be stolen through Pure Writer?](#is-there-a-risk-of-articles-being-leaked-by-using-pure-writer)
  - [How do I delete my Pure Writer account?](#how-do-i-delete-my-pure-writer-account)
- [Pure Writer Backup & Sync FAQ](#pure-writer-backup--sync-faq)
  - [About cloud backup](#about-cloud-backup)
  - [Which cloud services can I back up to?](#which-cloud-services-can-i-back-up-to)
  - [How do I set up cloud backup?](#cloud-backup-configuration)
  - [How do I restore documents from my old device on a new one?](#restore-articles-from-old-device-to-new-device)
  - [Why do I still see the starting documents after restoring a backup on a new device?](#only-initial-articles-are-present-after-restoring-a-backup-on-new-device)
  - [What’s the difference between incremental and full backups in the backup list?](#whats-the-difference-between-incremental-and-full-backups-in-the-backup-list)
  - [Why don’t images in Markdown documents show after I restore a backup?](#why-dont-images-in-markdown-documents-show-after-i-restore-a-backup)
  - [Does Pure Writer sync automatically?](#does-pure-writer-support-automatic-sync)
  - [Does sync happen in real time?](#why-there-isnt-a-fully-automatic-cloud-sync-mode)
  - [Are backups merged automatically when I use several devices?](#is-backup-content-automatically-merged-when-using-multiple-devices)
  - [How do I make sure I’m editing the latest version across devices?](#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices)
  - [Why am I asked to update Pure Writer on my other devices?](#why-am-i-asked-to-update-pure-writer-on-my-other-devices)
  - [I can’t find my backup files in Google Drive (Android)](#cannot-find-backup-files-in-google-drive)
  - [Can I back up to a cloud drive that isn’t listed?](#can-i-use-insert-cloud-drive-provider-name-for-cloud-backup)
  - [Can I back up to two cloud drives at the same time?](#can-i-back-up-to-two-cloud-drives-at-the-same-time)
  - [Why can’t I turn off automatic backups?](#cannot-turn-off-automatic-backup)
  - [About WebDAV (Android)](#about-webdav-android)
    - [Which services can I use with WebDAV?](#which-services-can-i-use-with-webdav)
    - [Error: Your WebDAV configuration is incomplete or incorrect.](#error-your-webdav-configuration-is-incomplete-or-incorrect)
    - [Why doesn’t Pure Writer recommend WebDAV anymore?](#why-doesnt-pure-writer-recommend-webdav-anymore)
- [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide)
  - [What is Markdown?](#whats-markdown)
    - [Note](#note)
  - [Syntax at a glance](#guide)
    - [Headings](#headings)
    - [Bold, italic, and bold italic](#bold--italic)
    - [Strikethrough and underline](#underlines--strikethroughs)
    - [Ordered lists](#ordered-list)
    - [Unordered lists](#unordered-list)
    - [Quotes](#quote)
    - [Superscript and subscript](#superscript--subscript)
    - [Aligning text left, center, or right](#text-alignment)
    - [Insert images](#insert-images)
    - [Insert links](#insert-links)
    - [Insert tables](#insert-tables)
    - [Checkboxes](#checkbox)
    - [In-page links](#in-page-links)
    - [Horizontal rules](#horizontal-rules)
    - [Text color](#text-color)
    - [Escape characters](#escape-characters)
    - [Other HTML tags and syntax](#other-html-tags-and-syntax)
    - [Code blocks](#code-blocks)
    - [Formulas](#formulas)
- [Pure Writer Markdown FAQ](#pure-writer-markdown-faq)
  - [About Markdown standards and compatibility in Pure Writer](#about-markdown-standards-in-this-app)
  - [Why don’t highlighting and some other syntax work?](#some-markdown-syntax-are-not-rendered-in-the-app)
  - [Why can’t I center text with the `<center>` tag?](#why-center-tag-isnt-supported)
  - [Why don’t images show on my other device?](#why-dont-images-show-on-my-other-device)
- [Pure Writer Desktop FAQ](#pure-writer-desktop-alpha-faq)
  - [Where can I download Pure Writer Desktop?](#downloading-pure-writer-desktop)
  - [Is Pure Writer Desktop free?](#is-pure-writer-desktop-free)
  - [How does Pure Writer Desktop sync with my phone?](#connect-to-desktop)
  - [Why won’t Pure Writer Desktop open?](#cannot-open-pure-writer-desktop)
  - [Pure Writer Desktop won’t sync with my phone](#cannot-connect-the-android-device-to-the-desktop-device)
  - [How do I update Pure Writer Desktop?](#how-do-i-update-pure-writer-desktop)
  - [Can I write Markdown in Pure Writer Desktop?](#can-i-write-markdown-in-pure-writer-desktop)
  - [Can I still use “Connect to desktop app” in Pure Writer for Android?](#can-i-still-use-connect-to-desktop-app-in-pure-writer-for-android)

## Pure Writer Q&A {#pure-writer-qa}

### About the word count options {#about-different-modes-of-word-count}

Pure Writer for Android and iOS has a “Word count” section in Settings with two options:

- “Count words individually”: when on, a run of Latin letters, digits, and similar characters counts as one, while each Chinese character or full-width punctuation mark still counts as one; spaces and line breaks aren’t counted. It’s off by default when the app language is Chinese, Japanese, Korean, or Thai, and on by default in other languages.
- “Word count & punctuation” (on iOS, “Word Count Mode & Punctuation”): choose from three modes, “Exclude spaces and line breaks”, “Include all symbols and text”, and “Exclude all punctuation, spaces, and line breaks”. This option has no effect while “Count words individually” is on.

“Exclude all punctuation” works from a list of common punctuation marks, so a few symbols that aren’t on the list are still counted. Some characters, such as emoji, count as 2.

Pure Writer Desktop has no setting for how words are counted.

### Using Pure Writer in landscape {#about-landscape-mode}

- **Android**: Pure Writer follows the system’s auto-rotate setting. If the screen doesn’t rotate, turn off orientation lock (or turn on auto-rotate) in Quick Settings or in your display settings. Where windows can be resized freely, such as desktop mode on a tablet, you can also drag the edges of the window to make it wider. To keep one orientation, turn on “Always use portrait orientation” or “Always use landscape orientation” in “Settings › Fine-tuning” (requires Pure Writer Pro). In landscape, in split screen, or with an external keyboard, “Tablet settings and guide” appears on the right of the top bar as long as the shortcut bar is on. It contains two settings: “Keyboard shortcuts for text shortcuts” and “Edit in vertical center”.
- **iOS**: Both iPhone and iPad support landscape and follow the orientation of the device. If the screen doesn’t rotate with the device, check whether Orientation Lock is on in Control Center.

With an external keyboard, Pure Writer for Android lets you hold Alt or Ctrl and press a number key to insert one of the first 10 shortcuts on the shortcut bar (1–9 for the first nine, 0 for the tenth). Pure Writer Desktop does the same with Command plus a number key on macOS, or Alt plus a number key on Windows.

### Why is paragraph spacing turned off in very long documents? (Android)

When a document has more characters than a set threshold, Pure Writer for Android temporarily turns off paragraph spacing to keep writing smooth. This doesn’t remove any blank lines you typed: paragraph spacing is not the same as blank lines, so there’s nothing to worry about. To change what counts as a very long document, go to “Settings › Fine-tuning › Long document threshold”.

Pure Writer for iOS and Pure Writer Desktop don’t turn off paragraph spacing because of a document’s length.

### How to use the shortcut bar {#shortcut-bar}

The shortcut bar sits above the keyboard. You can put frequently used text on it, such as the date and time, character names, or punctuation marks, and also shortcut actions.

- **Android**: Tap “⊕ New text shortcut” on the shortcut bar to create a shortcut; touch and hold a shortcut to edit or delete it. To reorder shortcuts, use more than one shortcut bar, or turn the shortcut bar off, go to “Settings › Shortcut bar”: drag a shortcut to reorder it or move it to another bar, and turn off all the bars to hide the shortcut bar. Using more than one shortcut bar at a time requires Pure Writer Pro. The leftmost button on the shortcut bar opens “Formatting options” in a plain text document and the Markdown panel in a Markdown document (see [About the Markdown panel](#markdown-panel)).
- **iOS**: Tap “+ Shortcut” on the shortcut bar to create a shortcut; touch and hold a shortcut to “Edit”, “Reorder”, or “Delete” it. Each row can be turned on or off in “Settings › Shortcut Bar”; turn off all the rows to hide the shortcut bar. In a Markdown document, the leftmost button on the shortcut bar opens the Markdown Panel.
- **Desktop**: The “Show/hide shortcut bar” button on the top bar shows or hides the shortcuts below the editor; click a shortcut to insert it. Right-click a shortcut to “Edit title” or “Delete” it. To add shortcuts or change what they insert, do it on your phone, and cloud sync will bring the changes to your computer.

When you create a shortcut, where you leave the cursor in its text decides where the cursor lands after the shortcut is inserted; see [Where does the cursor land after a shortcut is inserted?](#about-cursors-position-of-text-shortcuts)

Note that if you select some text and then tap a shortcut whose cursor lands in the middle (such as `“”`), the shortcut is added around the selected text instead of replacing it. This is a quick way to put quotation marks or brackets around a sentence or a paragraph. A shortcut whose cursor lands at the end replaces the selected text.

#### About shortcut actions {#about-shortcuts}

When you create a shortcut in Pure Writer for Android or iOS, you can choose a shortcut action instead of text. Both apps offer Undo, Redo, Paste, Move current paragraph up, Move current paragraph down, Delete current paragraph, Move cursor left, Move cursor right, Scroll to top, and Scroll to bottom. A few actions have different names on the two apps:

- Indent: “Indent” on Android, “Indent Paragraph” on iOS;
- One-tap formatting: “Format” on Android, “One-Tap Typesetting” on iOS;
- Copy: “Copy selection or all text” on Android, “Copy” on iOS;
- Searching for documents: “Find a document” on Android, “Search Documents” on iOS.

Android also offers “Move cursor”. To add it to the shortcut bar, first choose “In the shortcut bar, drag directly to move” in “Settings › Fine-tuning › Cursor control mode & position” (requires Pure Writer Pro).

Pure Writer Desktop shows and runs the shortcut actions synced from your phone, except “Move cursor”.

### Where does the cursor land after a shortcut is inserted? {#about-cursors-position-of-text-shortcuts}

A text shortcut has two fields: the text it inserts (“Text” on Android, “Content” on iOS), which is required, and an optional short description. Where the cursor lands after the shortcut is inserted depends on where the cursor was in the text field when you saved it.

For example, if the text is `()`: save it with the cursor between the parentheses, and the cursor lands between `()` after inserting; save it with the cursor after `()`, and the cursor lands after `()`.

You can also select part of the text as a placeholder. If text is selected in your document when you insert the shortcut, the selected text replaces the placeholder; if nothing is selected, the placeholder is inserted and left selected, so you can type over it right away.

### How do I insert the current time with a shortcut? {#insert-current-time-through-text-shortcuts}

When you create a text shortcut in Pure Writer for Android or iOS, write `${pattern}` in its text. When you use the shortcut, `${…}` is replaced with the date and time at that moment. Pure Writer Desktop does the same when it inserts such a shortcut synced from your phone. For example:

- `${yyyy-MM-dd HH:mm}` gives `2020-04-01 21:43`
- `${yyyy-M-d hh:mm}` gives `2020-4-1 09:43`

A pattern is built from the letters in the table below, and letters are case-sensitive. Digits, spaces, punctuation, and Chinese characters are kept as they are, but Latin letters are read as pattern letters; to output letters as they are, put them in single quotes.

| Letter | Meaning | Pattern and result |
| --- | --- | --- |
| y | Year | `yyyy` → 2020 |
| M | Month | `M` → 4, `MM` → 04, `MMM` → Apr, `MMMM` → April |
| d | Day | `d` → 1, `dd` → 01 |
| E | Day of the week | `E` → Wed, `EEEE` → Wednesday |
| a | AM or PM | `a` → PM |
| H | Hour (0–23) | `HH` → 21 |
| h | Hour (1–12) | `hh` → 09 |
| m | Minute | `mm` → 43 |
| s | Second | `ss` → 05 |
| S | Millisecond | `SSS` → 123 |
| z | Time zone | `z` → the time zone name, which varies by system |
| Z | Offset from UTC | `Z` → +0800 |

With one letter, the month, day, hour, minute, and second have no leading zero; with two letters, they’re padded to two digits. Names such as the month, the day of the week, and AM or PM follow your language settings; the table shows the results in English.

A few common patterns you can copy and adjust:

- 24-hour clock: `${yyyy-MM-dd E HH:mm:ss}`, for example `2020-04-01 Wed 21:43:05`
- 12-hour clock: `${yyyy-MM-dd E hh:mm:ss a}`, for example `2020-04-01 Wed 09:43:05 PM`
- Spelled out: `${EEEE, MMMM d, yyyy h:mm a}`, for example `Wednesday, April 1, 2020 9:43 PM`

Please note:

- Write only one `${…}` per line, and put everything you need, date and time alike, inside the same pair of braces. On Android and desktop, several `${…}` on the same line give wrong results.
- Pure Writer for iOS supports only the letters in the table above; a `${…}` that contains any other letter (such as `G` for the era) is inserted as is. Android and desktop support all the Java date pattern letters; see [Customizing Formats](https://docs.oracle.com/javase/tutorial/i18n/format/simpleDateFormat.html).

### About status bar focus mode (Android) {#hide-status-bar-and-its-known-issues}

Status bar focus mode simplifies the system status bar, keeping only essential icons such as the battery.

It’s in “Settings › Status bar focus mode” and is available only when “Hide status bar” is off. Because MIUI on Xiaomi and Redmi phones doesn’t work well with this feature, the option isn’t shown on those phones.

How well this feature works differs from device to device, and the result depends on the system; on some devices it may have no effect. Thank you for your understanding.

Pure Writer for iOS doesn’t have this option. For a cleaner writing screen, turn on “Hide the Status Bar” in Settings.

### About Formatting options {#about-formatting-tools}

Formatting options tidy up the formatting of a whole document at once: keep one blank line between paragraphs or remove extra blank lines, insert spaces between East Asian and Latin text, add or remove first-line indents, and more. When the app or system language is Chinese (on iOS, the app language), they also convert between Simplified and Traditional Chinese and turn half-width punctuation into full-width. One-tap formatting runs several common steps at once; on Android and iOS, you can choose which steps it includes.

- **Android**: Tap “More” (⋮) on the top bar and choose “Formatting options”. In a plain text document, you can also tap the leftmost button on the shortcut bar.
- **iOS**: Tap “⋯” on the right of the top bar to open the panel, then choose “Formatting Options & One-Tap Typesetting”.
- **Desktop**: Click the “Formatting options” button on the top bar. Press F5 to run one-click formatting directly.

Formatting rewrites your text. If you’re not happy with the result, you can undo it.

A few of the Chinese conversions need an internet connection: those whose names include “繁化姬” (Fanhuaji) send the text of the current document to Fanhuaji (zhconvert.org), a third-party service, to be converted, and ask for your consent before you use them for the first time, including when one-tap formatting runs them. They appear only when the app language is Chinese (on Android and desktop, Simplified Chinese). The other Simplified and Traditional Chinese conversions on Android and desktop run on your device and don’t need a connection.

### How do I find and replace text? {#find--replace-in-texts}

- **Android**: Tap “More” (⋮) on the top bar and choose “Find & replace”.
- **iOS**: Tap “⋯” on the right of the top bar to open the panel and choose “Find & Replace”. With an external keyboard, you can also press Command+F to find text in the current document.
- **Desktop**: In the editor, press Ctrl+F (Command+F on macOS), or choose “Find / Replace” from the right-click menu. The find bar works on the current document only. You can check “Regex” or “Match case”, and you can “Replace” or “Replace all”.

The panel works the same way on Android and iOS: type what to find in the field at the top, and the replacement in “Replace with” below; leave it empty if you only want to find. You can search the “Current document”, the “Current book”, or “All books”; “All books” includes the documents in the Trash. Case is ignored by default; check “Match case” if you need it. Every match is listed below. Check the matches to replace (“Select all” and “Invert selection” can help), then tap “Replace”. On Android, replacing requires Pure Writer Pro; finding doesn’t.

On both apps, Pure Writer automatically makes a backup before replacing (on iOS, replacing within the current document doesn’t make a separate backup; you can undo it instead, which reverts all of that replacement in one step). To revert a replacement, restore that backup and choose to overwrite: on Android in “Settings › Backup & cloud sync”, on iOS in “Settings › Backup & Cloud Sync”. Overwriting also affects content other than this replacement, so please read the explanation in the confirmation dialog when you restore.

**To find the documents that contain some text, see [How do I search for a document?](#search-articles--jump-to-articles-quickly)**

### How do I search for a document? {#search-articles--jump-to-articles-quickly}

This feature finds the **documents** that contain certain text, instead of going through the matches inside one document, so each document is listed only once. Tap a result to open that document: every matching keyword in it is highlighted, and the highlighting goes away once you edit the text.

- **Android**: Tap “More” (⋮) on the top bar and choose “Find a document”. In the “Find & replace” panel, you can also tap the title on the top bar to switch between the two.
- **iOS**: Tap “⋯” on the right of the top bar to open the panel and choose “Search Documents / Quickly Jump to a Document”.
- **Desktop**: Click the search button on the top bar or press Esc to open “Search documents”. What you type is searched for in the titles and text of all documents, ignoring case. Multi-line keywords and regular expressions aren’t supported.

On Android and iOS it works the same way:

- Type something you remember from the document. Titles and text are both searched, so you can also find a document by typing its chapter name or title. There’s currently no option to search titles only.
- For several keywords, put each on its own line; the results are the documents that contain all of them.
- You can search the “Current book” or “All books” (including the Trash). With “Include folders” on, folders with matching names are listed too.
- Check “Regex” to search with regular expressions. This manual doesn’t cover how to write them; you can look them up online if you’re interested.
- Results can be sorted by relevance, by their order in the book, or by when they were last updated.

### Is there a length limit for a single document? {#is-there-a-word-limit-for-one-single-chapter}

No. None of the three apps limits the length of a single document; how long it can be depends on your device’s performance and available memory.

That said, the longer a document is, the slower it is to open, edit, and sync. When you import from other apps and a document is over 600,000 words or characters, Pure Writer reminds you that such documents make backups larger, which can make cloud backup and sync slow or time out, and that editing may lag. For long works, we recommend splitting them into one document per chapter.

Pure Writer for Android temporarily turns off paragraph spacing in very long documents; see [Why is paragraph spacing turned off in very long documents?](#why-is-paragraph-spacing-turned-off-in-very-long-documents-android)

### How do I see when a document was created or last updated? {#how-can-i-check-the-time-created--modified-of-a-chapter}

The document list in the sidebar has two display modes: a compact list and a detailed list. In the detailed list, the time is shown under each document.

- **Android**: At the top of the sidebar, tap “More” (⋮) and choose “Detailed list mode” (the menu shows the mode you’ll switch to). Then tap the “Sort order” icon at the top of the sidebar, and under “Timestamps to show”, choose “Created”, “Modified”, or “Created & modified”.
- **iOS**: Tap “⋯” at the top of the sidebar, choose “Detailed list”, and choose which time to show under “Show time”. Pure Writer for iOS uses the compact list by default; in that mode, touch and hold a document to see its time in the menu.
- **Desktop**: Click “⋮” at the top of the sidebar and uncheck “Compact document list”. The created and updated times appear under each document.

### How do I open an external file? {#opening-external-documents}

- **Android**: In a file manager or another app, choose to open a TXT or Markdown (.md) file with Pure Writer, then confirm with “New document”. The file’s content is saved as a new document in the current book, and the original file isn’t changed. Some file managers may not offer Pure Writer; try another file manager.
- **iOS**: You can’t open a file directly from another app; use “Import from Other Apps” as described below.

All three apps have “Import from other apps” in their settings, which imports text files (TXT and Markdown), folders, or zip files, as well as files exported from some other writing apps, in one go. On Android and iOS, it’s in “Settings › Import from other apps”; on desktop, it’s in the “Settings” menu. Before importing, you see a preview where you can choose what to import, rename items, and change their order, and the original files aren’t changed. Importing the same file again creates another copy of its content; it doesn’t merge with or overwrite existing documents.

### Why can’t I open or import a very large file? {#cannot-open--import-a-document-that-is-too-large}

**Android**: When you open an external file with Pure Writer and it has more than 600,000 characters, you see “This file is too large to open”. This avoids a long wait when opening a huge file on a phone, which could make the app or the system seem frozen. In that case, use “Settings › Import from other apps” instead, which doesn’t have this limit.

“Import from other apps” doesn’t limit length on any of the three apps; it only reminds you when a document is over 600,000 words or characters, since such documents make backups larger, which can make cloud backup and sync slow or time out, and editing may lag.

### Why isn’t the default font the system font?

- **Android and iOS**: When the app language is Chinese, the default font is LXGW WenKai, an open-source Chinese font built into the app; in other languages, the default is the system font.
  - **Android**: To use the system font, uncheck the built-in LXGW WenKai option in the “Font” section of Settings. This option appears only when the app language is Chinese or Japanese, and it has no effect while “Custom font” is on.
  - **iOS**: In “Settings › Font”, choose “System Default”, “LXGW WenKai”, or “Custom Font”.
- **Desktop**: The default font is MiSans on Windows and PingFang on macOS. You can choose another font in “Settings › Font”.

### How do I change the font and font size? {#custom-font-and-font-size}

- **Android**: In the “Font” section of Settings, turn on “Custom font”, tap “Select font”, and choose a .ttf or .otf font file; it takes effect after you restart Pure Writer as prompted. On systems older than Android 9, there’s no “Select font”: put the font file in the `/Documents/PureWriter/App` folder on your storage (that folder can contain only one font file), then restart Pure Writer. Custom fonts require Pure Writer Pro; without it, you’re asked each time the app starts to purchase Pro or turn off the custom font. Font sizes are set with “Title text size” and “Body text size” in Settings.
- **iOS**: In “Settings › Font”, choose “Custom Font”, then “Import from Files…” (.ttf and .otf font files are supported) or “Choose from System Fonts…”. The font takes effect as soon as you choose it. Font sizes are set in “Settings › Title & Content Font Sizes”.
- **Desktop**: Choose the font and font size in “Settings › Font”. “Settings › Font style” switches between “Light” and “Bold”.

### What if the cursor at the end of a paragraph sits in the middle of the last character?

This is usually caused by the custom font you’re using: some font files shift the position of the cursor. Switch to another font or a newer version of that font, or go back to the built-in LXGW WenKai or the system font.

### Will the built-in font be updated?

The font built into Pure Writer for Android and iOS is LXGW WenKai. The font file is packaged with the app and isn’t downloaded separately; when the built-in font is updated, the update comes with a new version of Pure Writer. When the app language is Chinese, Pure Writer for Android shows the version of the built-in font after the LXGW WenKai option in the “Font” section of Settings.

For the default fonts of Pure Writer Desktop, see [Why isn’t the default font the system font?](#why-isnt-the-default-font-the-system-font)

### How do I make the text semi-transparent? (Android) {#change-the-transparency-of-the-text}

Adjust “Text color opacity” in “Settings › Line spacing and margins”. Pure Writer for iOS and Pure Writer Desktop don’t have this setting.

### How do I adjust the left and right margins? {#adjust-the-left-and-right-margin-of-the-text}

- **Android and iOS**: Adjust “Left margin” and “Right margin” in “Settings › Line spacing and margins” (on iOS, “Settings › Line Spacing & Margins”).
- **Desktop**: There’s no setting for margins. The text has a maximum line width, so when the window is wide, space is left on both sides automatically.

### How do I adjust line and paragraph spacing? {#adjust-line--paragraph-spacing}

- **Android and iOS**: Adjust “Line spacing” and “Paragraph spacing” in “Settings › Line spacing and margins” (on iOS, “Settings › Line Spacing & Margins”). The “Paragraph spacing” switch in Settings turns paragraph spacing off entirely.
- **Desktop**: “Paragraph spacing” in the “Settings” menu turns paragraph spacing on or off. There’s no setting for line spacing.

Paragraph spacing only changes how text is displayed; it doesn’t insert blank lines into your text. Markdown documents don’t use paragraph spacing; paragraphs are separated by blank lines. Pure Writer for Android also temporarily turns off paragraph spacing in very long documents; see [Why is paragraph spacing turned off in very long documents?](#why-is-paragraph-spacing-turned-off-in-very-long-documents-android)

### Why can’t text be justified? {#is-it-possible-to-justify-the-text}

For now, the editors in Pure Writer for Android, iOS, and desktop have no option to justify text; text is aligned to the left.

### The text is hard to read after I changed the paper background {#legibility-issues-after-changing-themes--wallpapers}

- **Android**: In “Settings › Themes & paper backgrounds”, choose “Keep the selected theme”, and then you can choose “Force black text” or “Force white text” below. When “Follow system theme” or the scheduled switch is selected, you can’t force a text color. Note that when you change the paper background, the text color goes back to the default. You can also turn on “Custom text color in editor” (an experimental feature that requires Pure Writer Pro) in “Settings › Fine-tuning” to set separate text colors for the light and dark themes.
- **iOS**: The text color follows the appearance: black in Light Mode, white in Dark Mode. Choose suitable paper backgrounds for Light and Dark Mode under “Paper” in “Settings › Theme”. When you use a photo as the paper background, you can raise “Image Overlay” to make the text clearer.

### Can I change the color of the text? {#is-it-possible-to-change-the-color-of-the-text}

- **Android**: Yes. Turn on “Custom text color in editor” (an experimental feature that requires Pure Writer Pro) in “Settings › Fine-tuning”, and you can set “Text color for light theme” and “Text color for dark theme” separately. When you choose “Keep the selected theme” in “Settings › Themes & paper backgrounds”, you can also force black or white text.
- **iOS**: The text color in the editor follows Light or Dark Mode and can’t be customized.
- **Desktop**: The text color follows the theme you choose and can’t be changed on its own.

To change the color of only part of a document, use the `<font color>` tag in a Markdown document. It works in the Markdown preview on Android and iOS; see [Text color](#text-color) for how to write it.

### How do I redo something I undid by mistake? {#redo-content-that-was-mistakenly-undone}

- **Android**: Tap “More” (⋮) on the top bar; there’s a “Redo” button at the bottom of the panel. After you tap it once, the panel briefly fades away so you can see the text while you tap redo again.
- **iOS**: In the top-right corner of the top bar there’s a button that shows the document’s format (TXT or M↓) or a cloud icon. Tap it to open a menu with “Undo” and “Redo”. When the button shows an undo arrow, tapping it undoes, and touching and holding it lets you choose “Redo”.
- **Desktop**: Choose “Redo” from the editor’s right-click menu, or press Ctrl+Y or Ctrl+Shift+Z (Command+Shift+Z on macOS).

On Android and iOS, you can also add “Redo” to the shortcut bar (see [About shortcut actions](#about-shortcuts)). On iOS, touching and holding “Undo” on the shortcut bar also lets you choose “Redo”.

### How do I restore an earlier version of a document from History? {#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history}

- **Android**: Tap “More” (⋮) on the top bar and choose “History”.
- **iOS**: Tap “⋯” on the right of the top bar to open the panel and choose “History”. You can also tap the button in the top-right corner that shows the document’s format (or a cloud icon) and choose “History” from the menu.
- **Desktop**: Click the “History” button on the top bar.

In History, you can browse and preview the versions of the current document saved recently, and restore the document to one of them. Before restoring, the current version is saved to History first, so you can still get it back afterward. Pure Writer Desktop also highlights the differences between a past version and the current one in color.

### How long is History kept? Is it included in backups?

History is for getting back old drafts and looking over your changes; it doesn’t save every single edit. Each document keeps up to a set number of History entries; beyond that, older entries are cleaned up. On iOS, History also has a size limit, so older entries may be cleaned up sooner. History is therefore no substitute for backups.

History is stored only on your device. By default, it isn’t included in automatic backups or cloud backups, and cloud sync doesn’t bring it to your other devices either, so after you restore an ordinary backup on a new device, you usually won’t see the History from the old one. When you need it, make a backup that includes History by hand on the backup page: on Android, “Back up locally with all history”; on iOS, “Back Up Now (Including History)”.

### Why is only one paragraph or line of my text clear? {#only-one-line--paragraph-of-the-article-can-be-clearly-seen}

Typewriter mode is on: the paragraph with the cursor is shown normally (on Android, this can also be set to the line with the cursor), and the rest of the text is dimmed. On both Android and iOS, you can turn off “Typewriter mode” in Settings.

For more about typewriter mode, see [What is typewriter mode?](#typewriter-mode)

### Can I export to .docx, .epub, or other formats? {#is-it-possible-to-save-the-article-as-docx-or-epub}

- **Android and iOS**: Yes.
  - A single document: on Android, tap “More” (⋮) on the top bar and choose “Preview & export…”; on iOS, tap “⋯” on the right of the top bar to open the panel and choose “Preview & Save as PDF, Long Image, DOCX, EPUB…”. You can save it as a TXT, MD, PDF, DOCX, or EPUB file, or as a long image or a set of short images. On Android, this requires Pure Writer Pro (you can try it once without Pro).
  - A whole book: choose “Export as one book” on Android or “Merge and Export Book” on iOS from the sidebar menu to export it as a TXT, DOCX, or EPUB file. On Android, this requires Pure Writer Pro and manual sorting.
- **Desktop**: Documents can’t be exported for now.

### Exported TXT files show garbled text in a reader app {#articles-exported-by-this-app-cannot-be-displayed-correctly-in-other-apps}

The TXT and MD files that Pure Writer exports use UTF-8 encoding. Some reader apps don’t support UTF-8 or don’t detect it automatically, so the text shows up garbled. Switch the text encoding to UTF-8 in that app, or open the file in another app.

### Why does the sidebar show only titles or the first line of the text?

The sidebar has switched to the compact list: each document shows only its title, or the beginning of its text when the title is empty (with automatic chapter names on, the number and title). To show excerpts and times as well, switch to the detailed list:

- **Android**: At the top of the sidebar, tap “More” (⋮) and choose “Detailed list mode”.
- **iOS**: Tap “⋯” at the top of the sidebar and choose “Detailed list”. Pure Writer for iOS uses the compact list by default.
- **Desktop**: Click “⋮” at the top of the sidebar and uncheck “Compact document list”.

### Why can’t I create a folder, or where did my folders go? (Android)

Folders are shown only with manual sorting. If you’ve switched to sorting by time or title under “Sort order” in the sidebar, folders are no longer shown in the list and you can’t create new ones. Your folders haven’t been deleted; they come back when you return to manual sorting.

To switch back, tap the “Sort order” icon at the top of the sidebar and choose “Manual order”. The sort order applies only to the current book.

The sidebars in Pure Writer for iOS and Pure Writer Desktop only use manual sorting, so folders are always shown.

### What is typewriter mode? {#typewriter-mode}

In typewriter mode, only the paragraph with the cursor is shown normally and the rest of the text is dimmed, so you can focus on what you’re writing. It also makes it harder, to some extent, for people behind you to read what’s on the screen.

- **Android**: Turn “Typewriter mode” on or off in Settings. Under “Typewriter mode” in “Settings › Fine-tuning”, you can choose “Paragraph mode” or “Line mode” (requires Pure Writer Pro).
- **iOS**: Turn “Typewriter Mode” on or off in Settings. It highlights only the current paragraph and works only in plain text documents.
- **Desktop**: There’s no dimming effect. “Keep the last edited line near the center” in Settings is a different feature.

### What is advanced read-only mode? (Android) {#read-only-mode}

This feature requires Pure Writer Pro. Advanced read-only mode works much like a reading mode: when it’s on, you can scroll and browse freely without worrying about deleting or losing text by an accidental touch.

- When the cursor isn’t visible, double-tap the editor to place the cursor and start editing.
- When the cursor is visible, tap once to edit or move the cursor.
- When the cursor is visible but the keyboard is hidden, go back to hide the cursor and return to read-only mode.

### How do I turn on advanced read-only mode? (Android) {#turn-on-read-only-mode}

Tap ⊕ in the bottom-right corner and turn on “Advanced read-only mode” in the menu. If you chose “Tap to create a document; touch and hold to open the menu” in “Settings › Floating button behavior”, touch and hold ⊕ to open the menu.

### How do I turn off advanced read-only mode? (Android) {#turn-off-read-only-mode}

To edit for a moment, double-tap the editor to place the cursor and start editing.

To turn off advanced read-only mode, open the menu of ⊕ in the bottom-right corner again (by tapping or touching and holding, depending on your setting) and turn off “Advanced read-only mode”.

### How do I insert a new document somewhere else? {#insert-a-new-article-at-different-positions}

- **Android**: Touch and hold ⊕ in the bottom-right corner, and the menu shows “New document after this one”, “New document at end of folder”, and “New document at end of list”; these appear only with manual sorting. After you turn on “Always show more creation options in ⊕” in “Settings › Fine-tuning” (requires Pure Writer Pro), tapping ⊕ shows them too. You can also touch and hold a document in the sidebar and choose “Add chapter above” or “Add chapter below”.
- **iOS**: Tap “+” in the bottom-right corner; the menu has “New Document”, “New Document After Current”, “New Document at End of Folder”, and “New Document at Bottom of List”. Touch and hold a document in the sidebar to choose “New Document Above” or “New Document Below”.
- **Desktop**: Right-click a document in the sidebar and choose “New document above” or “New document below”. Right-click a folder to choose “New document at end”.

### About Fine-tuning and Advanced Options {#options-for-the-few-people}

These settings gather options that relatively few people need, or that the developer doesn’t recommend changing. All three apps have them in Settings: “Fine-tuning” on Android, “Advanced Options” on iOS, and “Advanced options” on desktop. The description in the app reads “Extra settings for particular preferences” on Android and “For perfectionists: options that arguably shouldn’t exist.” on iOS. For example:

- **Android**: “Smooth cursor”, “Center title”, “Always use portrait orientation”, “Always use landscape orientation”, “Long document threshold”, the highlight style of “Typewriter mode”, “Custom text color in editor”, and more (changing most of them requires Pure Writer Pro; see the next question);
- **iOS**: “Center Title”, “Blue Input Box”, “Spell Checker”, “Floating Word Count”, “Cursor Position for New Documents”, “Comma to Full Stop on Line Break”, and more;
- **Desktop**: “Day starts at”, “Quote auto-completion”, “Show dot for current document”, and “Change a trailing comma to a period on Enter”.

### Why does Fine-tuning require payment?

Only Fine-tuning on Android requires payment. The features in it were never meant to be offered; they were built with extra time and effort at the strong request of some users, much like features made to order for a small group. That’s why changing Fine-tuning settings on Android requires Pure Writer Pro (apart from a few items such as “Show dot for current document”).

The core features of Pure Writer for Android are free, including basic writing and editing, History, automatic backups and the other protections against losing your writing, and cloud backup and cloud sync. Pure Writer for iOS doesn’t divide its features into free and premium tiers, and Advanced Options aren’t charged separately; Pure Writer Desktop is free for now. For how paying works on each app, see [Can I use Pure Writer without buying Pro?](#is-there-a-huge-feature-loss-without-pure-writer-pro)

### Colors look wrongly inverted (Android) {#the-interface-gets-abnormally-color-inverted}

Some phone systems have a feature that forces dark mode on apps by inverting their colors. Pure Writer for Android declares, in the standard Android way, that it doesn’t need forced dark mode, but some systems still invert it, and the colors come out wrong.

If this happens, turn off forced dark mode for Pure Writer in your phone’s system settings (usually among the dark mode settings; the name varies by brand). Pure Writer has its own dark appearance: choose a dark paper background in “Settings › Themes & paper backgrounds”.

### Why do I see “This is a Pro feature”? (Android) {#this-is-a-pro-feature-pop-ups}

Pure Writer for Android has free features and Pure Writer Pro. If you use a Pro feature without Pro, such as preview and export, custom paper backgrounds, custom fonts, reading the current document aloud, or Fine-tuning, you see “This is a Pro feature”; tap “OK” to see everything Pro includes and how to purchase it. Some of these dialogs have a “Try” button, and how the trial works varies by feature; for example, the preview page no longer offers a trial once you’ve exported something.

If you’ve already paid and still see this message, open the “Pure Writer Pro” page (tap “⋮” in the top-right corner of the top bar, then tap the crown icon at the bottom left of the panel) and check your membership status. If you purchased through Google Play, make sure Google Play works on your device and that you’re signed in with the Google account you purchased with (see [Why does Pro sometimes become inactive after I bought it on Google Play?](#pure-writer-pro-is-lost-but-i-have-paid-for-it-on-google-play)).

Pure Writer for iOS doesn’t divide its features into free and premium tiers, so it doesn’t show this message.

### A Pro prompt keeps appearing when I open the app

**Android**: If “This is a Pro feature” appears at startup, it’s usually because “Custom font” is on but you don’t have Pure Writer Pro. Tap “Cancel” to turn off the custom font (this takes effect the next time the app starts), and the dialog won’t appear again; tap “OK” to go to the Pro page. Also, without Pro, multiple shortcut bars are reset to just the first bar when the app starts, with a one-time notice.

**iOS**: After your trial or subscription ends, “Pro Is Needed to Keep Writing” appears once each time you reopen the app (not when you return to it from the background), and also when you tap the title, the text, or the button for a new document. This has nothing to do with which features you’ve turned on: once you subscribe or buy a lifetime membership, it no longer appears. If you don’t purchase, tap “Not Now” to keep reading, exporting, and backing up your existing documents (see [Can I use Pure Writer without buying Pro?](#is-there-a-huge-feature-loss-without-pure-writer-pro)).

### Can I use Pure Writer without buying Pro? {#is-there-a-huge-feature-loss-without-pure-writer-pro}

It depends on the app:

- **Android**: Yes. Pure Writer for Android has free features and Pure Writer Pro. The editor, History, automatic backups, cloud backup, cloud sync, and more are free to use, with no ads; preview and export, custom paper backgrounds and fonts, and some other features belong to Pro.
- **iOS**: Pure Writer for iOS doesn’t have separate free and premium tiers. After you download it, you can try every feature free for 7 days. After the trial, you need a subscription or a lifetime membership to keep editing and creating documents, but you can still read, export, and back up your existing documents.
- **Desktop**: Free for now, including cloud sync and cloud backup.

### Why do my custom paper backgrounds stay in the list? (Android) {#how-does-this-app-keep-my-custom-wallpapers}

In “Settings › Themes & paper backgrounds” on Android, the paper selection page automatically keeps the last two custom paper backgrounds you used, so you can easily choose them again. When you set a new custom paper background, the older of the two is replaced. To remove one, touch and hold it and delete it from the menu. Setting a custom paper background requires Pure Writer Pro, but choosing one of those two again doesn’t.

Pure Writer for iOS sets one paper background each for Light and Dark Mode in “Settings › Theme”, and doesn’t keep a record of past ones.

### Are paper backgrounds restored from a backup? {#are-wallpapers-saved-in-backups}

**Android**: Backups include your settings, which record the color of a paper background, the link to an online image, or the location of an image on your device. When you restore a backup, choose “Overwrite”, then choose “Yes” for “Replace local settings and account details?”, and your paper background settings are restored along with it. Choosing “Merge”, or “Restore and sync” when cloud sync is on, doesn’t change the settings on your device. Once the settings are restored, paper backgrounds made from a color or an online image appear as before. For one made from an image on your device, the backup contains only the image’s location, not the image itself, so it can’t be shown on another device, and you’ll need to choose the image again.

**iOS**: Paper background settings and photos are stored only on your device. They don’t go to your other devices with Pure Writer’s backups or cloud sync, and they aren’t restored from a backup.

### Can I customize the background of exported images? {#is-it-possible-to-customize-the-background-when-saving-articles-as-images}

You can’t use an image of your own as the background of an exported image, but you can choose a theme for it.

The preview page on Android (which requires Pure Writer Pro) and iOS offers several themes, such as Light · Pure, Dark · Pure, and a Smartisan Notes style. The two themes that follow the editor (“Theme: Light • Follow Editor” and “Theme: Dark • Follow Editor” on Android, “Light · Match Editor” and “Dark · Match Editor” on iOS) use the color of the editor’s solid paper background as their background. When the editor uses an image as its paper background, the exported image doesn’t include that image but uses a solid background.

Image backgrounds aren’t supported because documents vary in length while a background image has a fixed size: stretching it distorts the image, repeating it often looks out of place, and it can also multiply the file size of a long image.

### Why does the indent look wrong? {#something-is-wrong-with-indent}

When indents don’t display correctly, it’s usually because of the font or Pure Writer’s app language.

**Font**: A Chinese first-line indent is two full-width spaces (U+3000). In some fonts, the full-width space has a non-standard width, such as half the width of a Chinese character or even zero, or it’s drawn as a dot, a box, or another symbol, so the indent looks too short, disappears, or turns into symbols. When its width is zero, it looks as if there’s no indent, but with the cursor at the start of the paragraph, moving left once doesn’t take you back to the end of the previous paragraph.

To fix this, switch to a font that displays full-width spaces correctly, for example back to the default font (see [How do I change the font and font size?](#custom-font-and-font-size)). If you have the technical know-how, you can also edit the full-width space in the font yourself.

**App language**: The default style of the first-line indent depends on Pure Writer’s app language: two full-width spaces in Chinese, one full-width space in Japanese and Korean, and four half-width spaces in other languages. To use the Chinese indent, switch Pure Writer’s app language to Chinese. Switching languages doesn’t change the indents already in your documents.

### Why aren’t my paragraphs indented anymore? {#no-indentation-when-writing}

Common reasons:

- **First-line indents are turned off**: Check whether indenting is on in Settings (“Indent” on Android, “Auto Indent” on iOS).
- **The previous paragraph has no indent**: When you start a new line, it follows the indent of the previous paragraph; if that paragraph has no indent, neither does the new line.
- **Markdown documents**: With “Use Markdown for new documents” on, new documents don’t get a first-line indent automatically, and when you switch a new, still empty document to Markdown, its preset indent is removed.
- **The indent is there but invisible**: See [Why does the indent look wrong?](#something-is-wrong-with-indent)

### Why are documents exported as .md files? {#cannot-save-as-txt-file-only-md-is-shown}

When you export to a text file, Markdown documents are exported as .md and plain text documents as .txt. To export a TXT file, switch the document to plain text first:

- **Android**: Tap the `M↓` icon on the right of the top bar (it shows that the document is in Markdown) to switch it to plain text.
- **iOS**: Tap the button that shows `M↓` in the top-right corner of the editor and choose “Switch to Plain Text” from the menu.

Switching to plain text doesn’t remove the Markdown marks from the text.

### Can I use Markdown and LaTeX in Pure Writer? {#use-markdown--latex-in-the-app}

Yes. Each document can be switched between plain text and Markdown (see [What is Markdown?](#whats-markdown) for how). Support differs between the apps:

- **Android**: Supports Markdown, some HTML tags (such as underline, `<u>text</u>`), and LaTeX formulas, both inline and on their own lines (see [Formulas](#formulas) for how to write them). To see the rendered result, tap the small `M↓` button next to ⊕ in the bottom-right corner to switch between editing and preview.
- **iOS**: Markdown syntax is highlighted while you edit; images, LaTeX formulas, tables, and some HTML tags are rendered in preview and export. To see the rendered result, tap “⋯” on the right of the top bar to open the panel and choose “Preview & Save as PDF, Long Image, DOCX, EPUB…”.
- **Desktop**: You can switch a document to Markdown and edit its source, but rendered preview isn’t available for now.

If you’d like to try Markdown, you can read the [Markdown tutorial](/zh-hans/markdown/) written by the developer (in Chinese), or the [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide) in this manual. For more questions about using Markdown, see the [Pure Writer Markdown FAQ](#pure-writer-markdown-faq).

### About the Markdown panel {#markdown-panel}

The Markdown panel gathers common Markdown marks, such as headings, bold, italic, lists, quotes, code, links, and tables, to make them easier to type. Its items are fixed and can’t be added, removed, or changed; for how each mark is written, see the [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide).

- **Android**: In a Markdown document, tap the `M↓` button at the left end of the shortcut bar to open the Markdown panel. In a plain text document, this button shows `⌘`: tap it to open Formatting options, or touch and hold it to open the Markdown panel; when you tap an item there, you’re asked to turn on Markdown mode.
- **iOS**: In a Markdown document, tap the `M↓` button at the left end of the shortcut bar to open the “Markdown Panel”, which takes the place of the keyboard.
- **Desktop**: There’s no Markdown panel.

### Can Pure Writer render Markdown as I type? {#is-it-possible-to-render-markdown-in-real-time-in-this-app}

For now, none of the three apps offers WYSIWYG editing that hides Markdown marks as you write; while editing, you always see the Markdown source:

- **Android**: The editor shows the Markdown source, and you can switch to preview at any time to see the rendered result.
- **iOS**: Markdown syntax is highlighted while you edit, so headings, emphasis, code, quotes, and links stand out, but the marks stay visible. Images, formulas, and tables are rendered on the preview and export page.
- **Desktop**: You edit the Markdown source only, and rendered preview isn’t available for now.

### The app takes a long time to open {#it-takes-too-much-time-to-open-the-app}

When Pure Writer starts, it opens the document you were last editing. If that document is very long, reading and laying it out takes more time, which is more noticeable on less powerful devices.

If startup has become noticeably slow, check whether the last document you opened is a very long one, such as an extra-long file imported from elsewhere. You can split it into several documents, or switch to a shorter document before you leave the app. If the document opened at startup isn’t a long one and startup is still slow, please email [writer@drakeet.com](mailto:writer@drakeet.com) and include your device model and system version.

### The app lags or freezes when I switch to the Trash or a book {#app-freezes-when-switching-to-trash-or-other-books}

When you switch to the Trash or a book, Pure Writer loads its list of documents in the background. When there are many documents, the list may take a moment to appear.

If the app stays unresponsive for a long time after switching, keeps getting stuck, or crashes, please email [writer@drakeet.com](mailto:writer@drakeet.com) and include your device model, system version, the version of Pure Writer, and roughly how many documents are in the Trash or that book.

Please don’t uninstall and reinstall Pure Writer because of this. On iOS, deleting the app also deletes the local backups inside it; on Android, local backups are kept in the backup folder you chose (usually `Documents/PureWriter/Backups`). If you really need to uninstall, first make sure there’s a usable backup in iCloud, your cloud drive, or your backup folder.

### Can I make text bold or insert images? {#is-it-possible-to-insert-bold-text-or-images-in-articles}

Pure Writer saves your text as plain text, and its editor doesn’t support rich text: you can’t make text bold or embed images in it the way you can in a word processor. Rich text would make the editor far more complex, and the more complex it is, the more likely things go wrong, so Pure Writer focuses on plain text writing and has no plans to support rich text editing for now.

When you need bold text, images, or other formatting, you can switch the document to Markdown, which marks formatting with plain text, such as `**bold**`:

- **Android and iOS**: You can insert images into Markdown documents (see [Insert images](#insert-images)). Images you pick from your device are saved in Pure Writer’s “Image Assets”, and once you connect a cloud drive, they go to your cloud drive with backups and cloud sync. The preview page and export (long images, PDF, DOCX, EPUB, and more) show the formatted result; on Android, they require Pure Writer Pro. You can also copy the text as rich text or HTML to paste into other apps.
- **Desktop**: You can edit Markdown source and insert images, but the formatted result isn’t displayed for now, and images aren’t shown in the text.

If you’d like to try Markdown, you can read the [Markdown tutorial](/zh-hans/markdown/) written by the developer (in Chinese), or the [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide) in this manual.

### Why does “Skip” appear, or a new document get created, when I open Pure Writer? (Android) {#the-app-automatically-creates-an-article--prompts-me-to-skip-on-startup}

This is usually caused by a tool on your phone that uses accessibility permissions to tap “Skip” automatically (often used to skip splash screen ads) and taps Pure Writer’s new document button by mistake. Pure Writer’s new document button now ignores such automatic taps (screen readers aren’t affected). If it still happens, add Pure Writer to that tool’s allowlist, or turn the tool off.

### Is there a limit to the number of devices signed in to a Pure Writer account? {#is-there-a-limit-to-the-number-of-devices-that-can-log-into-a-pure-writer-account-at-the-same-time}

Yes. A Pure Writer account can be signed in on up to 5 devices at the same time, counting Android and iOS together. When it’s signed in on a sixth device, the device that signed in earliest is signed out.

Pure Writer Desktop doesn’t need a Pure Writer account and doesn’t count toward the limit. Purchases made through Google Play or the App Store don’t go through a Pure Writer account and don’t count either.

### Can I use a membership bought on one platform on another?

Purchases on each platform are separate:

- **Google Play**: Managed by your Google account. On another Android device, sign in with the same Google account and install Pure Writer from Google Play to keep using it. It can’t be transferred to iOS.
- **App Store**: Managed by your Apple Account. On an iPhone or iPad signed in with the same Apple Account, tap “Restore Purchases” on the Pro page to use it. It can’t be transferred to other platforms.
- **Desktop**: Free for now; no membership is needed.

### Google Play payment won’t start when I try to buy (Android)

First make sure Google Play is installed on your device, you’re signed in with your Google account, and Google Play itself opens and makes purchases normally.

If the Google Play payment screen doesn’t appear after you tap to buy, Pure Writer shows “Unable to start Google Play payments”. Open Google Play by hand once, then return to Pure Writer and try again. If you get the error DF-DFERH-01 while paying, restart your device and try again. Other errors are mostly related to the Google Play services on your device; please follow the instructions Google Play gives.

### Why does Pro sometimes become inactive after I bought it on Google Play? (Android) {#pure-writer-pro-is-lost-but-i-have-paid-for-it-on-google-play}

Pro bought through Google Play has to be confirmed by Google Play on your device. Pure Writer remembers the confirmation on your device, but that record is valid only for a period after the most recent confirmation (currently 30 days). If the purchase can’t be confirmed with Google Play for longer than that, for example because the device can’t reach Google Play for a long time, Pro shows as inactive; it comes back once Google Play works again and confirms the purchase.

If the Pro page doesn’t show a valid purchase, try the following in order:

1. Make sure Google Play opens normally on your device and that you’re using the Google account you purchased with (pay particular attention if your device has more than one Google account);
2. Clear Google Play’s data in its app info page in your system settings, then open Google Play again;
3. Restart Pure Writer a few times.

### How do I cancel a subscription?

- **iOS**: Subscriptions are managed by Apple. Open the Settings app, tap your name, then tap Subscriptions to manage or cancel. To avoid renewal, cancel at least 24 hours before the current period ends; the period you’ve already paid for stays active until it ends.
- **Android**: Cancel a subscription bought through Google Play in Google Play. You can also tap “Cancel subscription?” on the “Pure Writer Pro” page to go straight to Google Play’s subscription management. After you cancel, the status on the Pro page may take a while to update.

Deleting the Pure Writer app or deleting your Pure Writer account doesn’t cancel a subscription. If you have a subscription and want to buy a lifetime membership instead, cancel the subscription first: buying a lifetime membership doesn’t cancel the subscription automatically. On iOS, if your subscription will still renew when you tap Lifetime, you’re reminded to cancel it first.

### Why can’t I start a new line with Enter on ChromeOS, FydeOS, or some Android x86 devices? {#cannot-use-enter-to-insert-line-breaks-on-chromebooks-or-android-x86-devices}

These devices run Pure Writer for Android, and the system or the input method may change what the Enter key does. Try Ctrl+Enter, which Pure Writer treats as Enter. If you still can’t start a new line, look up how your system inserts line breaks.

Also, when the cursor is inside a blue input box (for example, between a pair of quotation marks or brackets you just typed), pressing Enter first jumps past the closing symbol, and pressing it again starts a new line. This is a writing aid on all three apps, not a bug.

### Text has outlines on an E Ink device (Android)

Outlines around text usually come from the device’s system display settings; for example, features like high contrast text add outlines to text. Look for such a feature in your system settings and turn it off (the name varies by device); if you can’t find it, please ask the device maker.

### Why can’t everything be customized? {#cannot-customize-some-of-the-features-in-the-app}

More settings aren’t always better. With too many options, the settings page gets crowded, and the settings that really matter become hard to find. Pure Writer would rather work out suitable styles and behaviors for you, so you can open it and focus on writing.

Options that only a few people need are gathered in Fine-tuning (Advanced Options on iOS and desktop) on all three apps, where they don’t get in the way of most people.

### Is there an iOS version of Pure Writer? {#is-there-an-ios-version-of-pure-writer}

**Yes.**

Pure Writer for iOS is available on the App Store for iPhone and iPad with iOS 26 or iPadOS 26 or later. It’s rebuilt around native iOS design and interactions. Connect the same cloud drive account as on Android and desktop (Pure Writer for iOS supports Dropbox, OneDrive, and AliyunDrive) to sync across your devices.

After you download it, you can try every feature free for 7 days. The trial doesn’t require a subscription, and you won’t be charged automatically. After the trial, you can choose a monthly subscription, a yearly subscription, or a lifetime membership. Pure Writer for iOS doesn’t have separate free and premium tiers.

Memberships purchased through Google Play are managed by your Google account and can’t be transferred to iOS.

Learn more in [the iOS section of our homepage](/en/#ios-en), or download it from the [App Store](https://apps.apple.com/app/id6803257195).

### Could my writing be stolen through Pure Writer? {#is-there-a-risk-of-articles-being-leaked-by-using-pure-writer}

**Pure Writer doesn’t steal your writing.** Apart from the online features listed below, which you choose to use, your documents are kept only on your devices and in your own cloud storage, and aren’t sent to Pure Writer’s servers.

#### Where documents and backups are stored

- **On your devices**: Your documents are stored in Pure Writer. As for local backups, Pure Writer for Android keeps them in the backup folder you chose (usually `Documents/PureWriter/Backups`); Pure Writer for iOS keeps them inside the app, and they’re deleted along with the app; Pure Writer Desktop keeps them in its data folder on your computer.
- **Your own cloud drive**: Backups are uploaded to your cloud drive account only after you connect it; with cloud sync on, the sync data is kept there too. See [About cloud backup](#about-cloud-backup).
- **Your own iCloud (iOS)**: When iCloud is available on the system, Pure Writer for iOS saves automatic backups to your own iCloud by default, without going through Pure Writer’s servers. You can turn this off in “Settings › Backup & Cloud Sync › Back Up to iCloud”.

Pure Writer’s backup files are ordinary compressed archives without extra encryption, so anyone who gets hold of a backup file can read the documents in it. Please keep your devices and cloud drive accounts safe, and don’t share backup files casually.

#### When your text is sent over the internet

- **Fanhuaji conversions**: In Formatting options on all three apps, the conversions whose names include “繁化姬” (Fanhuaji), which appear when the app language is Chinese, send the text of the current document to Fanhuaji (zhconvert.org), a third-party service, to be converted. They explain this and ask for your consent before the first use; see [About Formatting options](#about-formatting-tools).
- **AI features on Android**: Off by default; you need to turn them on in “AI settings”. When you use them, the text used to generate results is sent to an AI service. With “Pure Writer hosted AI” (requires Pure Writer Pro), the text is relayed through Pure Writer’s server to a large language model service; the server doesn’t store it in a database, but for troubleshooting, the server logs record part of the text in each request. With “OpenAI”, the text goes directly to the service address you set up (api.openai.com if you leave it blank), without passing through Pure Writer’s server.

Please use the genuine Pure Writer. We can’t guarantee the safety of your documents in cracked versions.

### How do I delete my Pure Writer account?

You can delete it yourself in the app:

- **Android**: Go to “Settings › Fine-tuning” and tap “注销纯纯写作账号” (Delete Pure Writer account) at the bottom of the page. This item appears when you’re signed in, and it and its dialogs are in Chinese. Wait for the countdown on the confirm button to finish, then confirm; after the account is deleted, restart Pure Writer as prompted. If you don’t have Pure Writer Pro, “This is a Pro feature” appears when you open Fine-tuning; tap “Try” to continue. Deleting your account doesn’t require Pro.
- **iOS**: While signed in, tap “Delete Account” at the bottom of the Pro page, read the warning and wait 30 seconds, then confirm in the system dialog.

Once deleted, the account and its membership are permanently removed from the server. The account can no longer be used on any device and can’t be recovered; signing up again with the same email gives you a brand-new account. Deleting the account doesn’t automatically refund payments already made.

Deleting your account doesn’t delete your writing: the documents and settings on your devices, and the backups and sync data in your cloud drive and iCloud, aren’t affected. Memberships bought through Google Play or the App Store don’t belong to a Pure Writer account and aren’t affected either. Deleting your account also doesn’t cancel a Google Play or App Store subscription; to stop it from renewing, cancel it separately (see [How do I cancel a subscription?](#how-do-i-cancel-a-subscription)).

## Pure Writer Backup & Sync FAQ {#pure-writer-backup--sync-faq}

This part covers backup and sync on Android, iOS, and desktop. The backup settings are in:

- **Android**: “Settings › Backup & cloud sync”; the menu of the cloud icon in the top-right corner of the main screen also has this item;
- **iOS**: “Settings › Backup & Cloud Sync”; you can also find it in the menu of the button in the top-right corner of the editor;
- **Desktop**: Click the cloud icon in the top-right corner of the window to open the “Backup and sync” window.

### About cloud backup {#about-cloud-backup}

Pure Writer automatically keeps backups on your device, so you can restore your documents if something is deleted by mistake or goes wrong. But local backups are on the same device as your documents: if the device is lost, damaged, or reset to factory settings, they’re lost together, and on iOS, local backups are also deleted when you delete the app.

Cloud backup saves backups to your own cloud drive (on iOS, also to your own iCloud), so you can restore from it when you switch devices or your device is lost or damaged. Please set up at least one kind of cloud backup. Once it’s set up, Pure Writer backs up automatically, and there’s nothing you need to do day to day; when something needs your attention, such as an expired cloud drive sign-in, Pure Writer lets you know.

- Backup files travel directly between your devices and your cloud drive (or iCloud), without going through Pure Writer’s servers. When you use AliyunDrive, its authorization is passed on through Pure Writer’s server, and with cloud sync on, the server also keeps AliyunDrive sync records (backup file names, device models, sync times, and the like), which don’t include the content of your documents.
- Your cloud drive account and your Pure Writer account are unrelated. Signing in to a Pure Writer account doesn’t restore documents; to restore them, connect the cloud drive or iCloud that has your backups, or use a backup file.
- Cloud sync is no substitute for backups: it keeps your devices consistent, so something deleted on one device is deleted on your other devices too.

If you don’t set up cloud backup for now, please regularly save copies of your local backup files to a place you trust; see [How do I restore documents from my old device on a new one?](#restore-articles-from-old-device-to-new-device) for how.

### Which cloud services can I back up to?

- **Android**: OneDrive, Dropbox, AliyunDrive, and also WebDAV and Google Drive. WebDAV and Google Drive are marked “Not supported in new versions” in the list: new versions released after October 31, 2027 won’t support them. Versions already installed aren’t affected and won’t stop working.
- **iOS**: Dropbox, OneDrive, and AliyunDrive. There’s also “Back Up to iCloud”: when iCloud is available on the system, it’s on by default and automatically saves a copy of your backups to your own iCloud, for restoring after you switch devices or reinstall the app. It can be used together with a cloud drive, but it can be restored only in Pure Writer for iOS, and it doesn’t sync what you’re editing.
- **Desktop**: OneDrive, Dropbox, and AliyunDrive.

OneDrive, Dropbox, and AliyunDrive are supported on all three apps, and they’re also the only services that support cloud backup and cloud sync of images in Markdown documents. To sync between devices, every device must use the same cloud drive and sign in to the same account.

Apart from the services above, Pure Writer doesn’t support other cloud drives.

### How do I set up cloud backup? {#cloud-backup-configuration}

- **Android**: On the “Backup & cloud sync” page, tap “Cloud connection type”, choose a cloud drive, and tap “Sign in” (for WebDAV, fill in the “WebDAV URL”, “WebDAV account”, and “WebDAV password”). Then tap “Back up to cloud” to back up right away. For a tutorial with pictures, see the [Cloud Backup Tutorial](/en/backups/).
- **iOS**: In “Settings › Backup & Cloud Sync › Cloud Drive”, tap “Connect Dropbox”, “Connect OneDrive”, or “Connect AliyunDrive” and sign in. Once connected, backups are uploaded to your cloud drive automatically; tap “Back Up to Cloud Now” to upload one right away. “Back Up to iCloud” is turned on or off separately in “Settings › Backup & Cloud Sync › Back Up to iCloud”.
- **Desktop**: In the “Backup and sync” window, click “Sign in to OneDrive”, “Sign in to Dropbox”, or “Sign in to AliyunDrive”. After you sign in and allow access in your browser, return to Pure Writer and click “Continue”.

### How do I restore documents from my old device on a new one? {#restore-articles-from-old-device-to-new-device}

You can restore from a cloud drive, from iCloud (iOS only), or from a backup file. Full backups (`.pwb` files) from any of the three apps can be restored on the others; if a backup comes from a newer version, update Pure Writer to the latest version first.

#### Restoring from a cloud drive

On the new device, connect the same cloud drive account as on the old one (see [How do I set up cloud backup?](#cloud-backup-configuration)). If the new device has no content yet, Pure Writer asks whether to restore from a backup it finds in the cloud drive; just follow the prompts. You can also choose a backup to restore from the backup list at any time:

- **Android**: “Restore backup” on the “Backup & cloud sync” page, also found in the menu of the cloud icon in the top-right corner of the main screen;
- **iOS**: “Settings › Backup & Cloud Sync › Cloud Drive › Cloud Backups”, or “Settings › Backup & Cloud Sync › Recent Backups”;
- **Desktop**: the backup list in the “Backup and sync” window.

Backups in the list usually show when they were made, how many books and documents they contain, and which device made them; usually, you can choose the latest one from your old device. If you can’t find a recent backup from the old device, back up on the old device first: on Android, tap “Back up to cloud”; on iOS, tap “Back Up to Cloud Now”.

If the old device had cloud sync turned on, you can also connect the same cloud drive account on the new device and turn on cloud sync right away, and the content in the cloud will sync over.

#### Restoring from iCloud (iOS)

If your old iPhone or iPad had “Back Up to iCloud” turned on, sign in to the same Apple Account on the new device and install Pure Writer, and it asks whether to restore from the backup in iCloud. You can also choose “Restore from iCloud Backup” in “Settings › Backup & Cloud Sync › Back Up to iCloud”.

#### Restoring from a backup file

First, make a backup file on the old device:

- **Android**: On the “Backup & cloud sync” page, tap “Back up locally”. The backup is saved in `Documents/PureWriter/Backups` by default;
- **iOS**: In “Settings › Backup & Cloud Sync”, tap “Back Up Now”, then under “Local Backups › Manual Backups”, tap “⋯” next to that backup and choose “Save to Files”;
- **Desktop**: In the “Backup and sync” window, right-click an incremental backup and choose “Save as full backup”. Saved backups go to the Backups folder inside the data folder: on Windows, the data folder is PureWriter in your Documents folder; on macOS, it’s PureWriter in your home folder.

After moving the backup file to the new device:

- **Android**: Open it with Pure Writer and choose “Pure Writer: Restore from this backup”; or put it in `Documents/PureWriter/Backups` and choose it from “Restore backup”;
- **iOS**: In “Settings › Backup & Cloud Sync”, choose “Merge Backup from Files” or “Overwrite from Backup in Files”, then select the file;
- **Desktop**: Put it in the Backups folder inside the data folder, then click it under “Full backups” in the “Backup and sync” window.

By default, backups don’t include History, and cloud sync doesn’t sync History either. To bring History along, use “Back up locally with all history” on Android or “Back Up Now (Including History)” on iOS; see [How long is History kept? Is it included in backups?](#how-long-is-history-kept-is-it-included-in-backups)

If your old device no longer works, and there are no backups in your cloud drive or iCloud and no backup files you saved yourself, **your documents can’t be restored**. If your new iPhone or iPad was set up from a full backup of the old device (the system’s iCloud Backup or a backup on a computer), Pure Writer’s documents come back with it, but History doesn’t.

#### Merge or overwrite?

When restoring, you can choose:

- Merge (on iOS, “Merge and Restore”): keeps the content on this device and merges in the content of the backup. Choose this if you’ve already written something on the new device.
- Overwrite (on iOS, “Overwrite and Restore”): first makes a backup of the content on this device, then replaces it with the content of the backup.
- Restore and sync (on iOS, “Overwrite and Sync”): when cloud sync is on, this takes the place of “Overwrite”. The content of the backup replaces the corresponding content on this device and is synced to your other devices; content on this device that isn’t in the backup is kept, and a backup is made before it starts, too.

### Why do I still see the starting documents after restoring a backup on a new device? {#only-initial-articles-are-present-after-restoring-a-backup-on-new-device}

There are two common reasons:

1. The restore has finished, but the main screen still shows the document you had open. Tap the book name to open the book list (at the top on Android, at the bottom on iOS, and in the top-left corner on desktop), then switch to the right book to see the documents from the backup.
2. You chose the wrong backup. Choose the one from your old device whose time and numbers of books and documents match. While the new device has no content yet, Pure Writer doesn’t make or upload backups automatically; but if you’ve already written on the new device, or chose to start with samples, backups from the new device appear in the list as well, so be careful to tell them apart.

### What’s the difference between incremental and full backups in the backup list?

The backup list has two groups, “Incremental backups” and “Full backups”:

- An incremental backup saves only what changed each time; when restored, it’s combined with the full backup it depends on to give you the complete library as it was at that moment. Incremental backups are cleaned up automatically according to retention rules. The one marked “Current” is the content cloud sync is using.
- A full backup is a self-contained `.pwb` file that can be copied and moved on its own.

Incremental backup files can’t be used on their own to restore. To keep a moment for the long term, or to take it to another device, save it as a full backup: on Android, touch and hold the row and tap “Save as full backup” in “Details”; on iOS, tap “⋯” next to the row in “Cloud Drive › Cloud Backups”; on desktop, right-click the row. Saved full backups aren’t cleaned up automatically; they’re kept until you delete them.

### Why don’t images in Markdown documents show after I restore a backup?

Images inserted into Markdown documents aren’t in the backup file: a backup only records which images there are, and the images themselves are uploaded separately to your connected cloud drive (OneDrive, Dropbox, or AliyunDrive). After you connect the same cloud drive account on the new device, images are downloaded automatically when they need to be shown, or you can tap “Download All” in “Image Assets”. If images are still missing, make sure the images on the old device were uploaded to the cloud drive: on phones, images are uploaded automatically only over Wi-Fi by default.

WebDAV and Google Drive on Android, and “Back Up to iCloud” on iOS, don’t save images, so if you back up only in these ways, images don’t come back with the backup. For other problems with images syncing between devices, see [Why don’t images show on my other device?](#why-dont-images-show-on-my-other-device)

### Does Pure Writer sync automatically? {#does-pure-writer-support-automatic-sync}

Yes. With cloud sync on, Pure Writer syncs documents through your connected cloud drive between the devices signed in to the same cloud drive account, including new documents, edits, and deletions.

- **Android**: Check “Cloud sync” on the “Backup & cloud sync” page. “Cloud sync mode” has two options: semi-automatic (the default) syncs automatically after you change the text; manual syncs only when you tap the sync button at the bottom of the editor, which suits cloud drives with traffic and request limits.
- **iOS**: Turn it on in “Settings › Backup & Cloud Sync › Cloud Sync”. Once on, it syncs automatically, over cellular data too; you can also tap “Sync Now” on the same page when needed.
- **Desktop**: Check “Cloud sync” in the “Backup and sync” window. Once on, it syncs automatically; you can also click “Cloud sync” at the bottom of the window to sync right away when needed.

Before turning it on, please read the explanation in the app carefully. On Android, once a cloud drive is connected, you can read “About cloud sync” at any time from the menu of the cloud icon in the top-right corner of the main screen.

### Does sync happen in real time? {#why-there-isnt-a-fully-automatic-cloud-sync-mode}

Not keystroke by keystroke. With cloud sync on:

- While you keep writing, Pure Writer syncs at intervals; when you stop typing, hide the keyboard, or leave Pure Writer, it starts syncing shortly after. Pure Writer Desktop starts syncing after you stop typing or its window loses focus.
- Other devices with Pure Writer open check for new content and receive it automatically.
- When Pure Writer isn’t in the foreground, whether it can sync in the background is up to the system. On iOS, if Background App Refresh is off or Low Power Mode is on, syncing waits until you open Pure Writer.
- When there’s no network or the cloud drive temporarily refuses requests, Pure Writer tries again later; when your cloud drive sign-in has expired, you need to sign in again before syncing can continue.
- In manual mode on Android, there’s no automatic sync: when there’s something to sync, a sync button appears at the bottom of the editor, and syncing starts only after you tap it.

So before you continue writing on another device, please make sure both sides have synced; see [How do I make sure I’m editing the latest version across devices?](#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices)

### Are backups merged automatically when I use several devices? {#is-backup-content-automatically-merged-when-using-multiple-devices}

No. Backups (including those in your cloud drive and “Back Up to iCloud” on iOS) are only for restoring; they don’t merge changes made on other devices into this one automatically. To keep your devices consistent automatically, turn on cloud sync on each of them; see [Does Pure Writer sync automatically?](#does-pure-writer-support-automatic-sync)

Without cloud sync, you can also merge by hand: when restoring a backup, choose “Merge” (on iOS, “Merge and Restore”), and the content of the backup is merged into this device while its existing content is kept.

Whether through cloud sync or merging, when the same document was changed on both sides, Pure Writer doesn’t splice the text from both together; it usually keeps the later change. The version that was replaced can usually be found in that document’s History.

### How do I make sure I’m editing the latest version across devices? {#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices}

Turn on cloud sync, and keep the following in mind:

1. Connect all your devices to the same account of the same cloud drive, turn on cloud sync on all of them, and update them to the latest version.
2. Before switching to another device, let the device you were writing on finish syncing; on the other device, wait until it has received the latest content before you start writing. When needed, you can sync once by hand:
   - **Android**: tap the sync button at the bottom of the editor (if it isn’t there, tap ⊕ in the bottom-right corner first);
   - **iOS**: “Sync Now” in “Settings › Backup & Cloud Sync › Cloud Sync”; when there are changes not yet synced, the menu of the button in the top-right corner of the editor also has “Sync to Cloud Now”;
   - **Desktop**: click “Cloud sync” at the bottom of the window.
3. Try not to edit the same document on two devices at the same time. When the same document was changed on two devices, the later change is usually kept; the version that was replaced can usually be found in that document’s History.
4. When one device finishes syncing, it only means that device has exchanged content with the cloud drive, not that your other devices have received it. A device that’s offline or doesn’t have Pure Writer open updates only after it goes online and syncs.

Without cloud sync, you can only restore the latest backup by hand each time you switch devices (choose “Merge”), which is tedious and error-prone.

### Why am I asked to update Pure Writer on my other devices?

When you sync with OneDrive, Dropbox, or AliyunDrive, starting with Pure Writer for iOS 1.0.6, Pure Writer for Android 31.0.0, and Pure Writer Desktop 5.0.0, cloud sync became incremental: usually only the changes are uploaded. Earlier versions can’t read the new sync data, so:

- when a new version starts syncing the new way while other devices are also syncing, it tells you once that cloud sync has been upgraded and that Pure Writer on your other devices also needs to be updated to the latest version to keep syncing;
- devices not yet updated may ask you to update, or fail to sync.

Please update Pure Writer on every device to the latest version. Until you do, changes made on a device with an old version stay on that device and aren’t lost; they sync after you update. If you later see “Another device is using a newer version of Pure Writer. Update Pure Writer on this device to keep syncing”, it’s for the same reason: syncing pauses until you update, and the content on this device isn’t affected.

### I can’t find my backup files in Google Drive (Android) {#cannot-find-backup-files-in-google-drive}

Pure Writer for Android only asks for access to an app-specific space in Google Drive, and that’s where backups are kept: you can’t see or download them on the Google Drive website or app, and they can be restored only in Pure Writer for Android, signed in to the same Google account.

Google Drive is marked “Not supported in new versions” under “Cloud connection type”: new versions released after October 31, 2027 won’t connect to Google Drive and won’t be able to restore from it; versions already installed aren’t affected. Pure Writer for iOS and Pure Writer Desktop don’t support Google Drive. If you want to keep updating Pure Writer, or to use this content on other devices, change “Cloud connection type” to OneDrive, Dropbox, or AliyunDrive in Pure Writer for Android, sign in, then tap “Back up to cloud”.

### Can I back up to a cloud drive that isn’t listed? {#can-i-use-insert-cloud-drive-provider-name-for-cloud-backup}

**No.**

Pure Writer for Android, iOS, and desktop support only the services listed in [Which cloud services can I back up to?](#which-cloud-services-can-i-back-up-to)

### Can I back up to two cloud drives at the same time?

**No.**

On all three apps, only one cloud drive is used at a time for backup and sync. “Back Up to iCloud” on iOS isn’t subject to this and can be used together with a cloud drive.

You can switch to another cloud drive at any time: on Android, choose it under “Cloud connection type”; on iOS, tap the current cloud drive in “Settings › Backup & Cloud Sync › Cloud Drive” and choose another one (you don’t need to sign in again when you switch back to one you’ve signed in to before); on desktop, click “Sign out” first, then sign in to the other one. If you use cloud sync on several devices, switch first on the device with the latest content, then switch your other devices to the same cloud drive.

### Why can’t I turn off automatic backups? {#cannot-turn-off-automatic-backup}

Automatic local backups are the last line of defense for your writing, so none of the three apps has a switch to turn them off (“Automatic backup” on the “Backup & cloud sync” page on Android can’t be unchecked).

Automatic backups don’t take up storage without limit: they’re kept in tiers by time, with more kept from recent times and fewer from earlier periods, and older ones are cleaned up automatically. Pure Writer for iOS shows under “Local Backups” how far back automatic backups go. Automatic and incremental backups in your cloud drive are also cleaned up automatically according to retention rules.

Backups you make by hand on your device aren’t cleaned up automatically; they’re kept until you delete them yourself. These include:

- backups made with “Back up locally” on Android, in `Documents/PureWriter/Backups`;
- backups made with “Back Up Now” on iOS, under “Local Backups › Manual Backups”;
- backups saved with “Save as full backup” on any of the three apps.

Backups outside your device can be stopped: “Back Up to iCloud” on iOS can be turned off, which doesn’t delete the backups already in iCloud, and once you disconnect your cloud drive, Pure Writer stops uploading backups to it.

### About WebDAV (Android)

The following questions concern Pure Writer for Android only; Pure Writer for iOS and Pure Writer Desktop don’t support WebDAV.

Under “Cloud connection type” on Android, WebDAV is marked “Not supported in new versions”: new versions released after October 31, 2027 won’t connect to WebDAV; versions already installed aren’t affected and won’t stop working. With WebDAV, images aren’t saved with cloud backup and cloud sync, every cloud backup and sync transfers the complete backup package, and you can’t sync with Pure Writer for iOS or Pure Writer Desktop. We recommend switching to OneDrive, Dropbox, or AliyunDrive; see [Why doesn’t Pure Writer recommend WebDAV anymore?](#why-doesnt-pure-writer-recommend-webdav-anymore) for how.

Existing backups on your WebDAV server are in the “PureWriter › Backups” folder and aren’t deleted because of this. When you need one, download it and open it with Pure Writer on Android, or choose “Merge Backup from Files” on iOS.

#### Which services can I use with WebDAV?

You can use a cloud service that offers WebDAV or a WebDAV server you set up yourself, but servers don’t all behave the same way, and a server you run at home often can’t be reached once you’re away from your home network. Since WebDAV support will end in new versions, we don’t recommend signing up for a new WebDAV service just for Pure Writer.

#### Error: Your WebDAV configuration is incomplete or incorrect. {#error-your-webdav-configuration-is-incomplete-or-incorrect}

Check that the “WebDAV URL”, “WebDAV account”, and “WebDAV password” are all filled in and correct. Common mistakes are mistyped letters or digits, or extra spaces or line breaks picked up when copying.

This message also appears when the connection fails or the server refuses the request, so look out for any other messages shown along with it.

#### Why doesn’t Pure Writer recommend WebDAV anymore?

- Images aren’t backed up or synced to the cloud, and every transfer is the complete backup package.
- Setup is tedious: you have to enter the server address, account, and password by hand, which is error-prone.
- Pure Writer for iOS and Pure Writer Desktop don’t support WebDAV, so if you keep using it, you can’t sync with those devices.
- New versions released after October 31, 2027 won’t connect to WebDAV (versions already installed aren’t affected).

We recommend switching to OneDrive, Dropbox, or AliyunDrive, which also work on Pure Writer for iOS and Pure Writer Desktop. Switching takes two steps:

1. In “Backup & cloud sync”, tap “Cloud connection type”, choose one of them, and sign in;
2. Tap “Back up to cloud”.

If you use cloud sync on several devices, switch first on the device with the latest content, then switch your other devices to the same cloud drive. The backups already on your WebDAV server aren’t deleted.

## Pure Writer Markdown User Guide {#pure-writer-markdown-user-guide}

### What is Markdown? {#whats-markdown}

Markdown is a way of marking formatting in plain text: you still write plain text, using symbols such as `#` and `*` to mark headings, bold text, and other formatting, and the text is shown neatly formatted when you preview or export it. In Pure Writer, you can choose plain text or Markdown for each document separately.

- **Android**: Tap the `TXT` icon on the right of the top bar. When the icon changes to `M↓`, the document has switched to Markdown. In a Markdown document, tap the `M↓` icon at the left end of the shortcut bar to open the Markdown panel, and tap the small `M↓` button next to ⊕ in the bottom-right corner to switch between editing and preview. “Preview & export…” also shows the formatted result.
- **iOS**: Tap the button in the top-right corner of the editor (it normally shows the format of the current document) and choose “Switch to Markdown”. In a Markdown document, tap the leftmost button on the shortcut bar to open the “Markdown Panel”. While you edit, headings, emphasis, code, quotes, and links are colored, and the marks stay visible; if you don’t want this, turn off “Highlight Markdown Syntax While Editing” in “Settings › Markdown Options”. To see the formatted result, use “Preview & Save as PDF, Long Image, DOCX, EPUB…”.
- **Desktop**: Click the button that shows “Plain text” in the status bar at the bottom of the window and choose “Markdown”; you can also right-click a document in the sidebar, or the editor’s tab, and choose “Switch to Markdown”. Pure Writer Desktop doesn’t render Markdown for now; the text is shown as is.

The results described below refer to preview and export on Android and iOS; where the two differ, it’s noted.

#### Note {#note}

1. Many marks need a half-width space after them to take effect, such as `# Heading`, `- List item`, and `> Quote`. Don’t leave this space out.

2. Markdown marks are all half-width characters; don’t use full-width ones (such as “＃” or “＊”) instead.

3. Markdown documents don’t use paragraph spacing; paragraphs are separated by blank lines. Documents created as Markdown don’t get a first-line indent automatically either; you can type full-width spaces by hand if you need one. Half-width spaces at the start of a line affect formatting: for example, when a paragraph starts with four or more half-width spaces, it may be treated as a code block. On iOS, typewriter mode doesn’t work in Markdown documents.

4. Pure Writer’s Markdown is based on the CommonMark spec, with added support for tables, task lists, strikethrough, LaTeX formulas, and a few HTML tags. Syntax that some other apps have added on their own, such as `==highlighted text==` and footnotes, isn’t supported.

5. Headings, lists, quotes, tables, checkboxes, horizontal rules, and the like must start at the beginning of a line, not in the middle of a line of text.

6. If you select text and then tap bold, italic, link, or a similar item in the Markdown panel, the marks are added around the selected text instead of replacing it; items such as headings, lists, and quotes apply to the whole line the selected text is on. On iOS, you can also select text and type a symbol such as `*` or `~` to wrap the selection.

7. Under the CommonMark spec, a single line break inside a paragraph isn’t rendered as a line break: to start a new paragraph, leave a blank line; to break a line within a paragraph, end it with two half-width spaces or a backslash `\`.

   ```md
   First paragraph

   Second paragraph
   ```

   In Pure Writer, treating a single line break as a line break is on by default, so pressing Enter once breaks the line when rendered, and this guide is written with this setting on. When it’s off, two lines separated by just one line break are joined into one line. On iOS, this setting is “Treat Single Newlines as Line Breaks” in “Settings › Markdown Options”; on Android, it’s called “GFM line breaks / Soft break adds new line” in Fine-tuning.

### Syntax at a glance {#guide}

#### Headings {#headings}

Start a line with a hash sign `#`, add a space, then write the heading. The number of hash signs sets the level of the heading, up to six levels:

```md
# Heading level 1

## Heading level 2

### Heading level 3

#### Heading level 4

##### Heading level 5

###### Heading level 6
```

You don’t need to add hash signs at the end of a heading.

Level 1 and level 2 headings can also be written another way: on the line below the heading, write a line of equals signs (such as `===`) for a level 1 heading, or a line of hyphens (such as `---`) for a level 2 heading. Note that there must be no blank line between the heading and the hyphens; otherwise, the hyphens are treated as a horizontal rule.

#### Bold, italic, and bold italic {#bold--italic}

All three wrap text in asterisks `*` or underscores `_`; only the number of symbols differs:

- Italic: one on each side, `*italic text*` or `_italic text_`
- Bold: two on each side, `**bold text**` or `__bold text__`
- Bold italic: three on each side, `***bold italic text***` or `___bold italic text___`

We recommend asterisks: the Markdown panel uses them, and underscores often don’t work in the middle of a word, as in `un_believ_able`.

In languages written without spaces, such as Chinese, formatting may also fail when an asterisk touches a character on one side and a punctuation mark (such as a quotation mark or bracket) on the other, as in `文字**“加粗”**文字`. In that case, move the punctuation outside the asterisks: `文字“**加粗**”文字`.

#### Strikethrough and underline {#underlines--strikethroughs}

For strikethrough, wrap text in two tildes: `~~struck-through text~~`. A single tilde doesn’t produce strikethrough, so you can safely use it for ranges, such as “3~5 days”.

Markdown itself has no syntax for underlining; use the HTML tag instead: `<u>underlined text</u>`.

The Markdown panel has items for both.

#### Ordered lists {#ordered-list}

Write a number, a period, and a space: `1. First point`. Pressing Enter continues with the next number automatically.

#### Unordered lists {#unordered-list}

Start a line with a hyphen `-`, an asterisk `*`, or a plus sign `+`, followed by a space:

- `- List item`
- `* List item`
- `+ List item`

All three look the same. For items that start with `-` or `*`, pressing Enter continues the list automatically; `+` displays fine but doesn’t continue automatically. The Markdown panel on Android offers both `-` and `*`, and the panel on iOS offers `-`.

Switching to another symbol in the middle of a list starts a new list.

Ordered and unordered lists can be nested in each other: indent a sub-item to where the text of the item above it starts. For example, under an item that starts with `- `, indent sub-items by two spaces; under an item that starts with `1. `, indent them by three spaces.

#### Quotes {#quote}

Start a line with a greater-than sign `>` and a space: `> Quoted text`.

#### Superscript and subscript {#superscript--subscript}

Markdown itself has no syntax for superscript or subscript; use HTML tags instead: `<sup>…</sup>` for superscript and `<sub>…</sub>` for subscript, as in `a quotation<sup>[1]</sup>` and `C<sub>2</sub>H<sub>5</sub>OH`.

Only the preview on Android supports these two tags; when exporting to EPUB or DOCX, they’re written out as is. Pure Writer for iOS shows them as is.

#### Aligning text left, center, or right {#text-alignment}

Markdown itself can’t set alignment; use an HTML tag instead:

```md
<p align="center">Text to center</p>
```

Change `center` to `left` or `right` to align left or right; you can also write `<div align="center">…</div>`. The center item in the Markdown panel on both Android and iOS inserts `<p align="center">`.

Pure Writer doesn’t support the `<center>` tag.

On Android, a paragraph that starts with such a tag is displayed as HTML: Markdown marks in it (such as `**`) are shown as is, and line breaks are shown as spaces. Pure Writer for iOS parses the Markdown in it as usual.

#### Insert images {#insert-images}

The format is `![image description](image address)`: write a description of the image in the brackets, which can be left empty, and the address of the image in the parentheses, which can be a link to an online image or an image in Pure Writer’s “Image Assets”. To set the display width, use an HTML tag, such as `<img src="image address" width="300">`.

- **Android**: Tap the image item in the Markdown panel to enter a link to an online image, or choose one from Image Assets or your local images.
- **iOS**: Tap “Image” in the Markdown panel to choose from Photos, Files, or Image Assets, or enter a link to an image. Pure Writer for iOS shows only online images whose addresses start with `https`.
- **Desktop**: Right-click in the text of a Markdown document and choose “Insert image…”; you can also drag an image into the text or paste it. Pure Writer Desktop doesn’t show images in the text.

An image you choose from your device is copied into “Image Assets” and written as `Assets/file name` in the text, so moving or deleting the original image file afterward doesn’t affect it. Once you connect a cloud drive, Image Assets go to your cloud drive with backups and cloud sync, so you can get them back on other devices too. Pure Writer for Android doesn’t sync images when using Google Drive or WebDAV, and “Back Up to iCloud” on iOS doesn’t include images.

Images inserted with a local path on the phone in early versions of Pure Writer for Android aren’t synced to your cloud drive. When this happens, the Image Assets page tells you, and you can use “Move Markdown images into Image Assets” to bring them into Image Assets.

Saving as an .md file includes only the text, not the images. To take the images to another app as well, export your Image Assets in “Settings › Image Assets” on Android or iOS.

When you use online images, preview and export download them from their addresses. Please choose an image host you can trust, and take care to protect your privacy.

#### Insert links {#insert-links}

The format is `[link text](link address)`, as in `[Pure Writer website](https://writer.drakeet.com)`.

Tap the link item in the Markdown panel to fill in the text and the address in turn. If you tap it with text selected, the selected text becomes the link text; if the selection is a web address, it becomes the link address.

Web addresses written out in the text also become links automatically in preview. This is called “Detect URLs and Emails” in “Settings › Markdown Options” on iOS, and “Turn web addresses into links automatically” in Fine-tuning on Android; both are on by default.

#### Insert tables {#insert-tables}

The Markdown panel has an item for inserting a table: it inserts a table with three columns, a header row, and three rows of content.

A table is made of vertical bars `|`, hyphens `-`, and colons `:`. The vertical bars separate the columns, the hyphens in the second row separate the header from the content, and the colons set the alignment of each column. For example:

```md
| Left   | Center | Right |
| :----- | :----: | ----: |
| left   | center | right |
| left   | center | right |
| left   | center | right |
```

This displays as:

| Left | Center | Right |
| :----- | :----: | -----: |
| left | center | right |
| left | center | right |
| left | center | right |

Notes:

1. It’s best to leave a blank line above and below a table. On Android, a header row directly below a line of ordinary text isn’t recognized as a table, and text directly below a table may be treated as one of its rows.

2. `:---` aligns left, `:---:` centers, and `---:` aligns right; without colons, the column aligns left.

3. Extra spaces between the vertical bars, hyphens, and text don’t affect the result, so you can use spaces to line up the rows for easier reading. Each cell of the separator row needs at least one hyphen.

4. The vertical bars at the start and end of each row can be left out.

5. On iOS, very large tables, with many rows and columns or long content, are shown as is.

#### Checkboxes {#checkbox}

Checkboxes, also called task lists, consist of a hyphen, a space, square brackets (with a space or the letter `x` inside), a space, and the text, in that order and with nothing left out:

- `- [ ] An unfinished task`
- `- [x] A finished task`

The Markdown panel on Android offers both unchecked and checked items. The panel on iOS offers “Task”, and when the cursor is on a task’s line, you can also mark it “Done” or “Not Done” from the edit menu.

#### In-page links {#in-page-links}

On the “Preview & export…” page on Android, tapping a link that points to a heading takes you to that heading in the text. Write the link address as `#` followed by the heading text, with its spaces and punctuation removed and its letters in lowercase:

```md
# Title 1

…

[Back to Title 1](#title1)
```

Longer headings work the same way: for example, the heading `## Chapter One: The Beginning` has the link address `#chapteronethebeginning`. If no matching heading is found, the link doesn’t go anywhere.

Pure Writer for iOS and Pure Writer Desktop don’t support in-page links.

#### Horizontal rules {#horizontal-rules}

Three or more hyphens `---` on a line of their own make a horizontal rule; three asterisks `***` or underscores `___` work too.

When you use hyphens, leave a blank line between the rule and the text above it; otherwise, the text above becomes a level 2 heading.

#### Text color {#text-color}

Use the HTML tag `<font color="color">text to color</font>`. The color can be the English name of a common color or a hex code in the form `#RRGGBB`, as in `<font color="red">red text</font>` or `<font color="#FF0000">red text</font>`. The Markdown panel has an item for it.

On Android, HTML tags (color included) inside tables don’t display correctly, so please avoid using them in tables.

#### Escape characters {#escape-characters}

To show a mark itself, put a backslash `\` before it. For example, `\*italic\*` shows as `*italic*` instead of italic text. A backslash works only before half-width punctuation.

#### Other HTML tags and syntax {#other-html-tags-and-syntax}

You can mix HTML tags into Markdown, but Pure Writer’s Markdown editor isn’t an HTML editor and supports only some of them:

- Supported on both Android and iOS (in preview and export): `<p align>` and `<div align>` (alignment), `<font color>` (text color), `<u>` (underline), and `<img>` (images).
- The preview on Android also supports `<sup>` and `<sub>` (superscript and subscript), `<ins>` (underline), `<b>` and `<strong>` (bold), `<i>` and `<em>` (italic), `<s>` and `<del>` (strikethrough), and other tags; when exporting to EPUB or DOCX, these tags are written out as is. HTML tags inside tables don’t display correctly on Android.
- Pure Writer for iOS shows unsupported tags as is.
- Pure Writer Desktop doesn’t render HTML.

#### Code blocks {#code-blocks}

Put multiple lines of code between two lines of three backticks `` ``` ``. For inline code, wrap it in one backtick `` ` ``, as in `` `print()` ``. Content inside code is shown as is, and Markdown marks in it aren’t parsed.

Write a language name after the opening three backticks, and the preview on Android colors the code for that language; languages it doesn’t recognize are shown as is. On iOS, code blocks are shown in a monospaced font on a shaded background, without coloring by language.

````md
```js
window.addEventListener('load', function () {
  console.log('window loaded');
});
```

```python
def square(x):
    return x ** 2
```
````

#### Formulas

Pure Writer for Android and iOS support LaTeX formulas, and the Markdown panel has items for them:

- For a formula on its own line, wrap it in two dollar signs `$$`, for example:

  ```md
  $$
  E = mc^2
  $$
  ```

- For an inline formula, wrap it in one dollar sign `$`, as in `$E = mc^2$`. Each `$` must be right next to the formula on the inside; on Android, the outside of each `$` must also be a space, a punctuation mark, or the start or end of a line, so a `$` right next to a letter or Chinese character on the outside isn’t recognized as a formula.

Pure Writer Desktop doesn’t render formulas.

## Pure Writer Markdown FAQ {#pure-writer-markdown-faq}

### About Markdown standards and compatibility in Pure Writer {#about-markdown-standards-in-this-app}

Pure Writer’s Markdown is based on the [CommonMark spec](https://spec.commonmark.org/0.29/) (version 0.29), with added support for tables, task lists, strikethrough, LaTeX formulas, and a few HTML tags (see [Other HTML tags and syntax](#other-html-tags-and-syntax)).

You can try out the basic syntax in CommonMark’s official [online dingus](https://spec.commonmark.org/dingus/), but it doesn’t support the extensions above, and it follows the spec in not breaking a line at a single line break, unlike Pure Writer, which treats a single line break as a line break by default. Pure Writer for Android and iOS use different parsers, so a few kinds of syntax may display slightly differently; Pure Writer Desktop doesn’t render Markdown.

### Why don’t highlighting and some other syntax work? {#some-markdown-syntax-are-not-rendered-in-the-app}

`==highlighted text==` isn’t part of the CommonMark spec; it’s syntax that some apps have added on their own, and Pure Writer doesn’t support it. Extensions such as footnotes (`[^1]`) aren’t supported either. To make some text stand out, use bold instead, or change its color with `<font color>`.

“Highlight Markdown Syntax While Editing” in the settings of Pure Writer for iOS colors the syntax marks while you edit; it has nothing to do with the text highlighting discussed here.

### Why can’t I center text with the `<center>` tag? {#why-center-tag-isnt-supported}

Pure Writer doesn’t support the `<center>` tag (it has long been obsolete in HTML, too). To center text, use `<p align="center">…</p>` or `<div align="center">…</div>`; to align left or right, change `center` to `left` or `right`. See [Aligning text left, center, or right](#text-alignment).

### Why don’t images show on my other device?

Check the following:

- Images and text are transferred separately: after the text has synced, the images may still be uploading or downloading. On Android and iOS, images are transferred automatically only over Wi-Fi by default; to transfer them over cellular data, turn on “Use Cellular Data for Images” (on Android in “Settings › Backup & cloud sync”, on iOS in “Settings › Backup & Cloud Sync”). You can check the progress under “Transfer Status” in “Image Assets”.
- Pure Writer for Android doesn’t sync images when using Google Drive or WebDAV.
- Images inserted with a local path on the phone in early versions of Pure Writer for Android aren’t synced; first bring them into Image Assets with “Move Markdown images into Image Assets”.
- Pure Writer for iOS shows only online images whose addresses start with `https`.
- Pure Writer Desktop doesn’t show images in the text; this doesn’t mean they haven’t synced.

If images don’t show after you restore a backup on a new device, see also [Why don’t images in Markdown documents show after I restore a backup?](#why-dont-images-in-markdown-documents-show-after-i-restore-a-backup)

## Pure Writer Desktop FAQ {#pure-writer-desktop-alpha-faq}

Pure Writer Desktop is available for Windows and macOS and syncs with Pure Writer on your phone through a cloud drive. For downloads and the latest changes, see the [Pure Writer Desktop](/en/desktop/) page.

### Where can I download Pure Writer Desktop? {#downloading-pure-writer-desktop}

Download it from the [Pure Writer Desktop](/en/desktop/) page on our website. There are three installers: Windows (x64), macOS (Apple silicon), and macOS (Intel). If you’re not sure which chip your Mac has, choose Apple menu › About This Mac.

Please download and update Pure Writer Desktop only from our website, so you don’t end up with an installer that someone else has repackaged with risky code.

### Is Pure Writer Desktop free?

Pure Writer Desktop is free for now, including cloud sync and cloud backup, and it doesn’t need a Pure Writer account.

### How does Pure Writer Desktop sync with my phone? {#connect-to-desktop}

Pure Writer Desktop syncs with your phone through a cloud drive: connect your computer and your phone to the same account of the same cloud drive and turn on cloud sync on both, and they sync with each other. You don’t need a Pure Writer account, and your phone and computer don’t need to be online at the same time or on the same Wi-Fi network. Pure Writer Desktop supports OneDrive, Dropbox, and AliyunDrive.

- **On your computer**: Click the cloud icon in the top-right corner of the window to open the “Backup and sync” window, click “Sign in to OneDrive”, “Sign in to Dropbox”, or “Sign in to AliyunDrive”, and sign in and allow access in your browser as prompted. Then check “Cloud sync”, read the explanation, and confirm. The first time you turn it on, keep Pure Writer open until it shows “First sync complete”.
- **Android**: In “Settings › Backup & cloud sync”, set “Cloud connection type” to the same cloud drive, sign in to the same account, then turn on “Cloud sync”.
- **iOS**: In “Settings › Backup & Cloud Sync”, first connect the same account of the same cloud drive under “Cloud Drive”, then turn on “Cloud Sync”.

If you don’t see the documents from your phone after the first sync, click the book name in the top-left corner of the window and switch to the right book in the book list.

Please update Pure Writer on every device to the latest version. When the same document was changed on two devices, the later change is usually kept, and the changes from both sides aren’t combined, so before you continue writing on another device, it’s best to wait until the changes on this one have finished syncing. When the bottom of the Pure Writer Desktop window shows “Cloud sync(\*)”, there are changes not yet synced; click it to sync right away. For more, see [How do I make sure I’m editing the latest version across devices?](#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices)

### Why won’t Pure Writer Desktop open? {#cannot-open-pure-writer-desktop}

- Make sure the installer matches your computer: the Windows installer is x64 only, and macOS has separate installers for Apple silicon and Intel.
- On Windows, some antivirus software mistakenly flags installers that don’t have a digital signature. Pure Writer comes from a developer and a company registered under their real names, so you can safely add the installer and the install folder `C:\Users\<username>\AppData\Local\Pure Writer 2` to your allowlist.
- If Pure Writer doesn’t open after installing, allow it to access folders under “Ransomware protection” (Controlled folder access) in Windows Security.
- If Pure Writer for Windows v2.1.9 is still on your computer, uninstall it first in Settings › Apps › Installed apps, then install the new version.
- If you see “Pure Writer 2 has not finished quitting from last time”, wait a moment and open it again. If it still won’t open, end the Pure Writer 2 process that’s still running in Task Manager (Windows) or Activity Monitor (macOS), then open it again; content already saved on your computer isn’t affected.

If that doesn’t solve the problem, please email [writer@drakeet.com](mailto:writer@drakeet.com) and include your system version and the name of the installer.

### Pure Writer Desktop won’t sync with my phone {#cannot-connect-the-android-device-to-the-desktop-device}

Please check the following in order:

- Both sides use the same cloud drive and are signed in to the same cloud drive account. Pure Writer for Android can’t sync with Pure Writer Desktop when it uses Google Drive or WebDAV; switch to OneDrive, Dropbox, or AliyunDrive. “Back Up to iCloud” on iOS is for backups only and can’t be used to sync.
- Both sides have “Cloud sync” turned on. When “Cloud sync mode” on Android is set to manual, you need to tap the sync button at the bottom of the editor to sync.
- Pure Writer is updated to the latest version on every device. When another device has a newer version, Pure Writer Desktop shows “Update Pure Writer to Continue”; syncing pauses until you update, and the content on this computer isn’t affected.
- Your network connection works and your cloud drive sign-in hasn’t expired. When you’re asked to reconnect or sign in to your cloud drive again, click “Sign out” in the “Backup and sync” window, then sign in to the same account again.
- Your device’s time is correct. If you see “Device time is incorrect”, turn on automatic date and time in your system settings.

If a sync makes no progress for a long time, the bottom of the Pure Writer Desktop window shows how long it has been running; click it to export diagnostics. You can also click the gear icon in the top-right corner of the window and choose “Export Diagnostics…”. Please send the exported file to [writer@drakeet.com](mailto:writer@drakeet.com). The diagnostics contain diagnostic logs and error records; they may include local file paths and device names, but not the content of your documents.

### How do I update Pure Writer Desktop?

Pure Writer Desktop downloads updates automatically in the background. When the download finishes, “New version” appears in the top-right corner of the window; click it and confirm the restart. When a fresh installation is needed, Pure Writer Desktop shows “New version found” and, after you confirm, opens the download page. Quit Pure Writer Desktop first, then run the newly downloaded installer, so you won’t be asked to restart after installing.

### Can I write Markdown in Pure Writer Desktop?

You can switch a document to Markdown (see [What is Markdown?](#whats-markdown)), but Pure Writer Desktop doesn’t render Markdown for now: the text is shown as is, there’s no preview, and images aren’t shown in the text. After a Markdown document written on desktop syncs to your phone, you can preview it there.

### Can I still use “Connect to desktop app” in Pure Writer for Android?

“Connect to desktop app” in the menu that the cloud icon on the top bar of Pure Writer for Android opens, and “Automatically connect to desktop app” in Fine-tuning, are only for the old desktop app, an early test version. It needed your phone and computer on the same Wi-Fi network, and you entered the IP address shown on your phone into the computer to edit the current document in real time. That version is no longer maintained.

Today’s Pure Writer Desktop syncs through a cloud drive, doesn’t need an IP address, and doesn’t use these two options; see [How does Pure Writer Desktop sync with my phone?](#connect-to-desktop) to set it up.
