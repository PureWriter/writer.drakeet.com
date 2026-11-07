---
title: Pure Writer User Manual
description: This is a manual for Pure Writer, which is about the features of the app and basic troubleshooting.
lastmod: 2026-11-07
---

<!--
  英文使用手册（旧地址 /wiki_en，Android 的帮助入口按地区打开它，服务器 301 到这里），由旧站 wiki_en.html（Typora 导出）逐字迁来。
  标题的 id 沿用旧页（Typora 生成的写法），逐个写在标题属性里，站外指向旧锚点的链接仍然有效；增删标题时不要改动已有的 id。
  对照表图片与简体、繁体手册共用同一张原图：旧页引用的 GitHub 页面地址显示为破图，图上的表格与这张相同。
  图片的 shortcode 外面包一层 <p>，并且分三行写，与旧页一样让图片留在段落里：Hugo 会去掉紧贴在 shortcode 两侧的 <p> 与 </p>，
  图片就不在段落里，少了段落的下边距，与下一段贴在一起。
  Markdown 教程只有简体中文版，所以「Simple Markdown Guide」链接到 /zh-hans/markdown/。
-->

# Pure Writer User Manual {#pure-writer-user-manual---omit-in-toc---}

This is a manual for **Pure Writer**, which is about the features of the app and basic troubleshooting.

The manual contains several parts, including [Pure Writer Q&A](#pure-writer-qa), [Pure Writer Backup & Sync FAQ](#pure-writer-backup--sync-faq), [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide), [Pure Writer Markdown FAQ](#pure-writer-markdown-faq), [Pure Writer Desktop Alpha FAQ](#pure-writer-desktop-alpha-faq).

Please be sure to make use of in-page search. For desktop devices use Ctrl+F, and for mobile devices, you can find a corresponding feature somewhere in your browser's menu.

## Table of Contents {#table-of-contents---omit-in-toc---}

- [Pure Writer Q&A](#pure-writer-qa)

  - [About different modes of Word Count](#about-different-modes-of-word-count)

  - [About landscape mode](#about-landscape-mode)

  - [Shortcut bar](#shortcut-bar)

    - [About shortcuts](#about-shortcuts)

  - [About cursor's position of text shortcuts](#about-cursors-position-of-text-shortcuts)

  - [Insert current time through text shortcuts](#insert-current-time-through-text-shortcuts)

  - [Hide status bar and its known issues](#hide-status-bar-and-its-known-issues)

  - [About formatting tools](#about-formatting-tools)

  - [Find & replace in texts](#find--replace-in-texts)

  - [Search Articles / Jump to Articles quickly](#search-articles--jump-to-articles-quickly)

  - [Is there a word limit for one single chapter?](#is-there-a-word-limit-for-one-single-chapter)

  - [How can I check the time created / modified of a chapter?](#how-can-i-check-the-time-created--modified-of-a-chapter)

  - [Opening external documents](#opening-external-documents)

  - [Cannot open / import a document that is too large](#cannot-open--import-a-document-that-is-too-large)

  - [Custom font and font size](#custom-font-and-font-size)

  - [Change the transparency of the text](#change-the-transparency-of-the-text)

  - [Adjust the left and right margin of the text](#adjust-the-left-and-right-margin-of-the-text)

  - [Adjust line / paragraph spacing](#adjust-line--paragraph-spacing)

  - [Is it possible to justify the text?](#is-it-possible-to-justify-the-text)

  - [Legibility issues after changing themes / wallpapers](#legibility-issues-after-changing-themes--wallpapers)

  - [Is it possible to change the color of the text?](#is-it-possible-to-change-the-color-of-the-text)

  - [Redo content that was mistakenly undone](#redo-content-that-was-mistakenly-undone)

  - [Restore the content of an article back to an earlier version through History](#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history)

  - [Only one line / paragraph of the article can be clearly seen](#only-one-line--paragraph-of-the-article-can-be-clearly-seen)

  - [Is it possible to save the article as .docx or .epub?](#is-it-possible-to-save-the-article-as-docx-or-epub)

  - [Articles exported by this app cannot be displayed correctly in other softwares](#articles-exported-by-this-app-cannot-be-displayed-correctly-in-other-apps)

  - [Clicking outline links in Time Machine only opens Books list](#clicking-outline-links-in-time-machine-only-opens-books-list)

  - [Typewriter Mode](#typewriter-mode)

  - [Read-only Mode](#read-only-mode)

  - [Turn on Read-only Mode](#turn-on-read-only-mode)

  - [Turn off Read-only Mode](#turn-off-read-only-mode)

  - [Insert a new article at different positions](#insert-a-new-article-at-different-positions)

  - [Options for the few people](#options-for-the-few-people)

  - [The interface gets abnormally color inverted](#the-interface-gets-abnormally-color-inverted)

  - ["This is a Pro feature" pop-ups](#this-is-a-pro-feature-pop-ups)

  - [Is there a huge feature loss without Pure Writer Pro?](#is-there-a-huge-feature-loss-without-pure-writer-pro)

  - [How does this app keep my custom wallpapers?](#how-does-this-app-keep-my-custom-wallpapers)

  - [Are wallpapers saved in backups?](#are-wallpapers-saved-in-backups)

  - [Is it possible to customize the background when saving articles as images?](#is-it-possible-to-customize-the-background-when-saving-articles-as-images)

  - [Something is wrong with Indent](#something-is-wrong-with-indent)

  - [No indentation when writing](#no-indentation-when-writing)

  - [Cannot save as .txt file, only .md is shown](#cannot-save-as-txt-file-only-md-is-shown)

  - [Use Markdown / LaTeX in the app](#use-markdown--latex-in-the-app)

  - [Markdown Panel](#markdown-panel)

  - [Is it possible to render Markdown in real time in this app?](#is-it-possible-to-render-markdown-in-real-time-in-this-app)

  - [It takes too much time to open the app](#it-takes-too-much-time-to-open-the-app)

  - [App freezes when switching to Trash or other books](#app-freezes-when-switching-to-trash-or-other-books)

  - [Is it possible to insert bold text or images in articles?](#is-it-possible-to-insert-bold-text-or-images-in-articles)

  - [The app automatically creates an article / prompts me to "Skip" on startup](#the-app-automatically-creates-an-article--prompts-me-to-skip-on-startup)

  - [Is there a limit to the number of devices that can log into a Pure Writer account at the same time?](#is-there-a-limit-to-the-number-of-devices-that-can-log-into-a-pure-writer-account-at-the-same-time)

  - [Pure Writer Pro is lost but I have paid for it on Google Play](#pure-writer-pro-is-lost-but-i-have-paid-for-it-on-google-play)

  - [Cannot use Enter to insert line breaks on Chromebooks or Android x86 devices](#cannot-use-enter-to-insert-line-breaks-on-chromebooks-or-android-x86-devices)

  - [Cannot customize some of the features in the app](#cannot-customize-some-of-the-features-in-the-app)

  - [Is there an iOS version of Pure Writer?](#is-there-an-ios-version-of-pure-writer)

  - [Is there a risk of articles being leaked by using Pure Writer?](#is-there-a-risk-of-articles-being-leaked-by-using-pure-writer)

- [Pure Writer Backup & Sync FAQ](#pure-writer-backup--sync-faq)

  - [About Cloud Backup](#about-cloud-backup)
  - [Cloud Backup Configuration](#cloud-backup-configuration)
  - [Restore articles from old device to new device](#restore-articles-from-old-device-to-new-device)
  - [Error: Your WebDAV configuration is incomplete or incorrect.](#error-your-webdav-configuration-is-incomplete-or-incorrect)
  - [Only initial articles are present after restoring a backup on new device](#only-initial-articles-are-present-after-restoring-a-backup-on-new-device)
  - [Does Pure Writer support automatic sync?](#does-pure-writer-support-automatic-sync)
  - [Why there isn't a "fully automatic" Cloud sync mode?](#why-there-isnt-a-fully-automatic-cloud-sync-mode)
  - [Is backup content automatically merged when using multiple devices?](#is-backup-content-automatically-merged-when-using-multiple-devices)
  - [How can I ensure that the article being edited is up-to-date when using Cloud sync across multiple devices?](#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices)
  - [Cannot find backup files in Google Drive](#cannot-find-backup-files-in-google-drive)
  - [Can I use [insert cloud drive provider name] for Cloud Backup?](#can-i-use-insert-cloud-drive-provider-name-for-cloud-backup)
  - [Cannot turn off automatic backup](#cannot-turn-off-automatic-backup)

- [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide)

  - [What's Markdown?](#whats-markdown)

    - [Note](#note)

  - [Guide](#guide)

    - [Headings](#headings)
    - [Bold & Italic](#bold--italic)
    - [Underlines & Strikethroughs](#underlines--strikethroughs)
    - [Ordered List](#ordered-list)
    - [Unordered List](#unordered-list)
    - [Quote](#quote)
    - [Footnote](#footnote)
    - [Superscript & Subscript](#superscript--subscript)
    - [Text alignment](#text-alignment)
    - [Insert images](#insert-images)
    - [Insert links](#insert-links)
    - [Insert Tables](#insert-tables)
    - [Checkbox](#checkbox)
    - [In-page links](#in-page-links)
    - [Horizontal rules](#horizontal-rules)
    - [Text color](#text-color)
    - [Escape characters](#escape-characters)
    - [Other HTML tags and syntax](#other-html-tags-and-syntax)
    - [Code blocks](#code-blocks)

- [Pure Writer Markdown FAQ](#pure-writer-markdown-faq)

  - [About Markdown standards in this app](#about-markdown-standards-in-this-app)
  - [Some Markdown syntax are not rendered in the app](#some-markdown-syntax-are-not-rendered-in-the-app)
  - [Why &lt;center&gt; tag isn't supported?](#why-center-tag-isnt-supported)

- [Pure Writer Desktop Alpha FAQ](#pure-writer-desktop-alpha-faq)

  - [Downloading Pure Writer Desktop](#downloading-pure-writer-desktop)
  - [Connect to Desktop](#connect-to-desktop)
  - [Cannot open Pure Writer Desktop](#cannot-open-pure-writer-desktop)
  - [Cannot connect the Android device to the desktop device](#cannot-connect-the-android-device-to-the-desktop-device)
  - [Connection between devices is not stable](#connection-between-devices-is-not-stable)
  - [Auto-connect doesn't work](#auto-connect-doesnt-work)
  - [Ghosting effect of text in Pure Writer Desktop](#ghosting-effect-of-text-in-pure-writer-desktop)

- [Easter eggs](#easter-eggs)

  - [Easter eggs in Pure Writer](#easter-eggs-in-pure-writer)

# Pure Writer Q&A {#pure-writer-qa}

## About different modes of Word Count {#about-different-modes-of-word-count}

Word Count is originally designed for Chinese, and has 3 modes: Exclude spaces and line breaks; Include all symbols and text; Exclude all punctuations, spaces, and line breaks. These modes basically tells what they do, so nothing more on them.

However when writing English texts, if the counter counts letters instead of words, you can turn on "Count words individually" in the settings to go back to normal. In this case, you can only use Exclude spaces and line breaks for Chinese content if exists.

## About landscape mode {#about-landscape-mode}

Pure Writer isn't really doing a good job in landscape mode when using phones, for their screens are too small. It's recommended to use Android tablets or Android desktops when using Pure Writer in landscape mode.

When using devices with a larger screen, you can open "Landscape settings & guidelines" on the right of the top bar. There are some optimization options for large screen devices in it.

Shortcut keys for shortcut entries: Press and hold the Ctrl or Alt key on the physical keyboard to use the first 10 shortcut entries.

**Turn on landscape mode**: Enable "Auto-rotate screen" (or disable "Orientation Lock"), then rotate your device to enable landscape mode.

Cannot find those two settings? Open the settings app on your phone, and find "Display" or "Display and Brightness", or something alike, and then you'll see "Auto-rotate screen" or "Orientation Lock". You can search the keyword if applicable.

When using Android tablets or Android desktops, resizing the window of the app may also enable landscape mode.

## Shortcut bar {#shortcut-bar}

Shortcut bar is a mini-bar just above your on-screen keyboard. You can customize the entries there, and even add your own text shortcuts, like inserting time and date, inserting names or inserting punctuations.

Click `⊕` or `⊕ Text Shortcut` to create your own text shortcuts, or just add an entry that we've already provided for you. Hold existing shortcuts to sort, modify or delete them. The position where your cursor is in the "Shortcut content" field will be the cursor's position when inserting the text shortcut.

Click `⌘` (when using Markdown, `M↓`) to open Formatters menu (or Markdown Panel when using Markdown).

Note that when you've selected some texts, and that the shortcut you are going to use has a cursor position inside the shortcut content, the content will be added before and after the selected texts, instead of replacing them, which might be different from other softwares. This is a feature for situations like when you want to add quotes or parentheses before and after certain sentences or paragraphs.

To disable shortcut bar, open settings and disable it in Options for the few people.

### About shortcuts {#about-shortcuts}

`⊕ Text Shortcut` currently provides some of the options that we've already provided for you, like Undo and Redo, Indent, Format, Scroll to bottom, Scroll to top, Copy selected or current full text, Search Articles / Jump to articles quickly, Cursor Joy-Con (when enabled in Options for the few people). You can choose Text Shortcut or other provided options for each entry when creating or editing.

We still want to improve the shortcut bar, so if there's anything you want to suggest, be sure to tell us.

## About cursor's position of text shortcuts {#about-cursors-position-of-text-shortcuts}

Again, each shortcut entries consists of two parts: Shortcut content (required) and Shortcut description. The final position of the cursor is determined by the cursor's position in the Shortcut content field when setting.

For example, if the Shortcut content field is `【｜】`, where `|` represents your cursor and `【` `】` being full-width brackets, then clicking on the entry will insert the `【】`, with cursor in the middle; if the Shortcut content field is `【】｜`, where `|` represents your cursor (again), then clicking on the entry will insert the `【】`, with the cursor after them.

## Insert current time through text shortcuts {#insert-current-time-through-text-shortcuts}

In this case, Shortcut content field must follow the format of `${<format>}`.

There is a cheatsheet for the actual time format, but don't worry if you cannot understand, as there are some **examples** after the sheet.

<p>
{{< img src="img/86e2ff85gy1gsvqom2btsj20or0vj455.jpg" alt="Cheatsheet" width="680" >}}
</p>

Here are some examples:

**Insert time in 12-hour format**: `${GG yyyy-MM-dd E aa hh:mm:ss.SSS(z)}`

**Example output**: AD 2022-08-22 Mon PM 06:59:50.093(GMT+08:00)

**Insert time in 24-hour format**: `${GG yyyy-MM-dd E HH:mm:ss.SSS(z)}`

**Example output**: AD 2022-08-22 Mon 19:01:49.443(GMT+08:00)

For more, check this link: [Customizing Formats](https://docs.oracle.com/javase/tutorial/i18n/format/simpleDateFormat.html).

## Hide status bar and its known issues {#hide-status-bar-and-its-known-issues}

Hide status bar, or Status bar focus mode, can hide most of the icons from the status bar, preventing them from disturbing you.

You can turn it on or off under "Spacings & Margins" menu, which is on the right of "Paragraph Spacing" option. Some devices (e.g. Xiaomi and Redmi devices) don't support it due to their system limitations, so on these devices the option will be hidden.

The experience may vary due to different system implementations on different devices, so if your exact device runs into problem with this on, you can only turn it off as we can't do anything about it.

## About formatting tools {#about-formatting-tools}

Formatting tools, or formatters, helps to make your article consistent in a certain format.

Currently we provide these options: Leave a blank line between paragraphs; Remove all blank lines between the paragraphs; Insert a space between East Asian and Latin text; Insert indentation at the start of all paragraphs; Remove indentation; some Chinese options that provide a machine transliteration between Simplified Chinese and Traditional Chinese.

These are helpful when you are editing a long article; don't hesitate just because the name "Format" looks like the option to erase all your content on a disk.

## Find & replace in texts {#find--replace-in-texts}

Click "more" icon on the top bar of the editor, then click "Find & Replace" in the menu.

The "Find" field is the content you would like to search, and the "Replace" field is the content you want to use to replace the search result. Leave the "Replace" field blank if only searching for content. Select the results below the two fields you would like to replace when using "Replace" field.

Currently we provide some options like "Current Chapter", "Current Book", "All Books" and "Ignore Case" for filtering the search result. Buttons below these options basically do what they say, currently "Replace", "Select All", "Inverse All", "Hide Keyboard" and "Search Articles / Jump to Articles quickly".

**For searching for an article, use "Search Articles / Jump to Articles quickly" instead.**

## Search Articles / Jump to Articles quickly {#search-articles--jump-to-articles-quickly}

This helps you to search for **articles with certain content** in the book when you happens to forget the exact article name, not search keywords in articles, thus this only displays the first occurence of the searched content in one article.

**Usage**: Enter the keywords or relevant content in the article that you would like to jump to. Multiple keywords or relevent content are seperated by **line breaks**. Only the first occurence of the keyword in one article is shown.

This can also be used as title name search or chapter name search, as it would also search the title anyway. Though there isn't a direct way to "search title name", by writing titles in a certain format (e.g. "Chapter X ..."), you can search for keyword in titles (e.g. "Chapter") at the same time to achieve a similar goal.

**Regular Expressions (Regex)**: You can search in regular expressions. Search the Web for a tutorial on Regex if you're interested.

## Is there a word limit for one single chapter? {#is-there-a-word-limit-for-one-single-chapter}

There is **basically no word limit in a single chapter**. That is, the sky (your device's performance) is the limit!

In theory, Pure Writer can handle an article of 100 million Chinese characters without lagging, and that in reality, on developer's device, Pure Writer can handle an article of 10 million Chinese characters without lagging. Don't take out the test on your own though, as it may dramatically increase the size of the backup, causing Cloud Backup to fail. YOU HAVE BEEN WARNED.

In daily use, keep the word count **under 20 thousand (20,000)** for one chapter to get a smoother writing experience. Some low-end devices may start to lag when editing a chapter for more than 10 thousand words, but even for them, just viewing the article won't cause any lagging issue.

## How can I check the time created / modified of a chapter? {#how-can-i-check-the-time-created--modified-of-a-chapter}

- Open the hamburger menu, click "More" icon, then tap "Zoom in".
- In the hamburger menu, click "Sort type" icon, tap "Type of time displayed", then select the option you want.

## Opening external documents {#opening-external-documents}

The app supports to open external plain text or Markdown documents.

Generally you can select one of these documents, and then select "Open with", and then "Pure Writer" in the Files app. If you are using other file manager apps, look up on their documentation for similar options.

## Cannot open / import a document that is too large {#cannot-open--import-a-document-that-is-too-large}

Previously, Pure Writer will lag or "freeze" when opening a large plain text file, and thus some users may report that "The app freezes" or "The phone isn't responding when using the app", which isn't true as the app is actively processing the file. Now, Pure Writer will refuse to import large files by opening external documents. If you still want to import a large file, copy & paste the content into the editor instead.

**Files that are too large are basically over 300 KiBs. This value may vary depending on your device's performance.**

## Custom font and font size {#custom-font-and-font-size}

This is a Pro feature, but unpaid users can still try this feature for free.

Android 10 and below: Place your TTF file under `/Documents/PureWriter/App`. Turn on "Custom font" in the settings and then restart the app.

Android 11 and above: Turn on "Custom font", select "Select font", then choose the font file.

For font size, see other settings. You can adjust title font size and content font size in the settings.

## Change the transparency of the text {#change-the-transparency-of-the-text}

Tap "more" icon on the top bar, tap "Spacing & Margins", then adjust "Text color Alpha / transparency (%)".

## Adjust the left and right margin of the text {#adjust-the-left-and-right-margin-of-the-text}

Tap "more" icon on the top bar, tap "Spacing & Margins", then adjust "Left Margin" and "Right Margin".

## Adjust line / paragraph spacing {#adjust-line--paragraph-spacing}

Tap "more" icon on the top bar, tap "Spacing & Margins", then adjust "Line spacing" and "Paragraph spacing".

## Is it possible to justify the text? {#is-it-possible-to-justify-the-text}

Android native TextView doesn't support justifying the text (align both ends of the text). While WebView can do this, the performance is pretty bad, so Pure Writer choose TextView.

We can do nothing about this, as it's an issue of Android itself, and thus should be solved by Google.

## Legibility issues after changing themes / wallpapers {#legibility-issues-after-changing-themes--wallpapers}

Under "Themes & Wallpapers", select "Fixed, don't switch automatically", then choose "Force Black Text Color" or "Force White Text Color", depending on your wallpaper. No other colors are available.

## Is it possible to change the color of the text? {#is-it-possible-to-change-the-color-of-the-text}

Currently, only black and white text color are supported, and we don't plan to support more colors for texts.

If you want to change the color of a certain part of texts, use Markdown and relevant HTML tags.

## Redo content that was mistakenly undone {#redo-content-that-was-mistakenly-undone}

Tap "more" icon on the top bar, then select "redo" icon at the bottom of the menu.

The menu will disappear after tapping "redo", thus user can clearly see how their article will change.

Redo button is also available in shortcut bar. See relevant paragraphs for more information.

## Restore the content of an article back to an earlier revision through History {#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history}

Tap "more" icon on the top bar, then select "History".

In History, you can see the history of the article (obviously), and selecting on a certain entry will allow you to preview the selected revision and decide if the article should be restored to that revision.

## Only one line / paragraph of the article can be clearly seen {#only-one-line--paragraph-of-the-article-can-be-clearly-seen}

"Typewriter Mode" is on. Turn it off by tapping "more" icon on the top bar, then selecting "Typewriter Mode".

## Is it possible to save the article as .docx or .epub? {#is-it-possible-to-save-the-article-as-docx-or-epub}

Currently we don't support these, sorry. There is a plan for saving articles as .docx files, but it's of low priority. Other formats like .epub require more work and changes in the code base, so support for these formats are not guaranteed to come in later versions.

## Articles exported by this app cannot be displayed correctly in other apps {#articles-exported-by-this-app-cannot-be-displayed-correctly-in-other-apps}

The app exports files in text encoding of UTF-8, thus it means that other apps you use may not support or fail to recognize the file as UTF-8 text encoding. Change the text encoding to UTF-8 in that app, or use an app that supports UTF-8.

## Clicking outline links in Time Machine only opens Books list {#clicking-outline-links-in-time-machine-only-opens-books-list}

Outlines are no longer there, for you can just create another book as your outline. The Books list pops out to tell you that you can create another book as your outline, and then open that book in Editor 2 to work just as fine as the original outline.

## Typewriter Mode {#typewriter-mode}

When turned on, the current paragraph is highlighted, allowing the user to focus more on the current text, and to a certain extent, avoid people behind the user to see all the text.

If you accidentally turned it on, just turn it off by tapping "more" icon on the top bar, then selecting "Typewriter Mode".

## Read-only Mode {#read-only-mode}

It's also known as "Reading Mode", for you can easily navigate through the article without accidental deletion of the text, thus ensuring that the content is **SAFE**.

For Advanced read-only mode:

When the cursor is not visible, you need to double-click the editor to show the cursor;

When the cursor IS visible, click the editor once to show the cursor;

When the cursor IS visible but the keyboard is collapsed, Go Back (either by tapping the Go Back button or swipe from the edge of the screen if applicable) and then you are now at Read-only Mode again.

## Turn on Read-only Mode {#turn-on-read-only-mode}

Read-only Mode is under the bottom-right corner menu `⊕`, click or hold the button to turn on Read-only Mode in the list.

## Turn off Read-only Mode {#turn-off-read-only-mode}

Double-clicking the editor will show the cursor and start editing, thus temporarily allow you to write.

Click or hold the button of the bottom-right corner menu `⊕` to turn off Read-only Mode in the list.

## Insert a new article at different positions {#insert-a-new-article-at-different-positions}

There are three related options in the bottom-right corner menu `⊕`: Insert a new article at the bottom of the article list; Insert a new article at the bottom of current Folder; New article after the current article. Hold the button to see these options.

## Options for the few people {#options-for-the-few-people}

"Options for the few people" are some options that developers don't recommend to change but have to provide for user requests. Options there includes Smooth cursor (default on), Align title to center (default on), Shortcut bar (default on), Comma to full stop when entering a newline (default off) and so on.

## The interface gets abnormally color inverted {#the-interface-gets-abnormally-color-inverted}

This happens in devices that provides a "more powerful dark mode" that forces apps to invert colors, thus causing colors of some parts that are already inverted to be inverted again (thus causing situations like white text on white background). Pure Writer cannot do anything about it if the device doesn't provide a way to stop forcing some of the apps to invert colors.

Solutions:

- In phone's settings app, exclude Pure Writer from the dark mode.
- Do not use the dark mode provided by Pure Writer.
- Report it to the device's manufacturer, so that they provide a way to disable forcing invert colors for certain apps.

## "This is a Pro feature" pop-ups {#this-is-a-pro-feature-pop-ups}

Custom wallpapers, Preview (including Markdown Quick Preview), Export, Material Design 2, Find & Replace, Export this Book, Editor 2, and Custom font are so-called Pro features that can be used without any limit by purchasing Pure Writer Pro.

Some of these provide trials for unpaid users, at the cost of displaying a pop-up every time they use.

If purchased, but still experiencing pop-ups, go to "Pure Writer Pro", then check if your Pure Writer account or Google account is logged in. If not, log in again, and open Google Play to make sure that your Google account is logged in.

## Is there a huge feature loss without Pure Writer Pro? {#is-there-a-huge-feature-loss-without-pure-writer-pro}

There **ISN'T**. The core features of Pure Writer are free, which includes excellent editor experience and Cloud Backup. Most of the features can be used without paying anything and, there aren't any third party advertisements even when unpaid.

Each year, Pure Writer will offer a discount on November 11. You can wait for the discount if you don't feel so hasty to buy a Pro at the current price. There might be some other discounts from time to time, so stay tuned.

## How does this app keep my custom wallpapers? {#how-does-this-app-keep-my-custom-wallpapers}

In "Themes & Wallpapers", the app will remember the wallpaper that the user once used, so that if they want to change it back, it wouldn't be a trouble.

The app keeps two of the most recent custom wallpapers. Hold the item of old wallpapers to delete them.

## Are wallpapers saved in backups? {#are-wallpapers-saved-in-backups}

Backup includes settings, which indeed includes the URL to the image or RGB value, and these wallpapers can be restored through backups. But if you choose "Local image", the exact image will not be included in the backup and you cannot recover that wallpaper solely through Pure Writer backups.

## Is it possible to customize the background when saving articles as images? {#is-it-possible-to-customize-the-background-when-saving-articles-as-images}

**Nope.**

Well, the article can get quite long, and thus custom background images had to be stretched, certainly not what users are expecting. There might be some solutions tho:

1. Use some color gradient when the custom background image isn't long enough. However images vary and thus cannot really achieve a universal good result.
2. Tile the image, just like wallpapers on desktops. Well, again, images vary, and when the image is overly complicated, the final image could be quite large in file size, thus is harder to download and may get compressed on social media.

## Something is wrong with Indent {#something-is-wrong-with-indent}

There are two reasons, most frequent though: Custom font and wrong languages.

- Custom font may not contain the glyph for the indent, or the glyph is wrong, in which cases the indent may not be long enough (indent displayed as two half-width spaces but expected two full-width spaces), or the indent is shown as tofus or dots.

  Pure Writer uses two full-width spaces (U+3000) for indentation in Chinese. Some fonts however may set the character's width half as it should be, or even totally change the glyph.

  **Solution**: Change to another font (or disable custom font) that can display the character U+3000 normally. Or, you can manually fix the problem by editing the font file if you know how to do that.

- You changed the language, in the app or through system settings.

  Pure Writer is international, and thus has different indentation rules for different languages. For example, in English the indentation is 4 half-width spaces, while in Japanese and Korean the indentation is 1 full-width space and so on.

  **Solution**: Change the language back, or change the app's language according to your text.

## No indentation when writing {#no-indentation-when-writing}

- Is Markdown mode on? Turn it off as Markdown doesn't support the indentation provided by the app.
- If Markdown mode is INDEED OFF, go to settings and be sure the "Indent" option is on.

## Cannot save as .txt file, only .md is shown {#cannot-save-as-txt-file-only-md-is-shown}

Articles with Markdown mode on are exported as .md, which is expected.

To save articles as .txt files, tap `M↓` icon on the top bar to turn Markdown mode off.

## Use Markdown / LaTeX in the app {#use-markdown--latex-in-the-app}

Pure Writer supports Markdown and certain HTML tags (like underline, `<u>Text</u>`), as well as LaTeX formulas, both inline and display style. However, the positions of the LaTeX formulas may be a bit too close to the bottom of a line than what you will expect.

To turn on Markdown / LaTeX, tap `TXT` icon on the top bar, and make it `M↓`.

To preview, tap the `M↓` button on the left of the `⊕` button.

Wanna try Markdown? read about the brief introduction written by the developers: [Simple Markdown Guide](/zh-hans/markdown/), or just read the part [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide) in this manual.

See also [Pure Writer Markdown FAQ](#pure-writer-markdown-faq).

## Markdown Panel {#markdown-panel}

Markdown Panel integrates some commonly used Markdown syntax, making it more convenient to insert Markdown syntax.

When Markdown mode is on, tap the `M↓` icon on the left of the shortcut bar to open Markdown Panel; When off, tap `⌘` then swipe left.

The panel includes several Markdown syntax, like bold, italic, insert image and so on, but you **cannot customize entries in Markdown Panel**.

## Is it possible to render Markdown in real time in this app? {#is-it-possible-to-render-markdown-in-real-time-in-this-app}

Currently, most of the devices cannot handle real-time rendering while keeping a decent performance. So, not now.

## It takes too much time to open the app {#it-takes-too-much-time-to-open-the-app}

Basically, it's because your articles are too long, and thus it takes more time for the app to open it.

Pure Writer is an editor app, not a reader app. It's a bad idea to import oversized articles, or never make use of chapter. Seperate them into several small parts, or just delete them in the app.

## App freezes when switching to Trash or other books {#app-freezes-when-switching-to-trash-or-other-books}

**Problem not solved after reading this paragraph? Send an email about your issue to the developer. ([writer@drakeet.com](mailto:writer@drakeet.com))**

There are too many articles in the Trash book, and thus your phone cannot handle it without lagging. Technically the app **ISN'T FREEZING**, but rather is actively loading articles, during which the app seems to be not responding. Wait until all articles are loaded, then delete all articles in the Trash book.

**Note that you shouldn't close the app when it's loading articles, or the app may crash at the next startup.**\
Solution when app crashes at startup:

1. Backup. If you've set Cloud Backup, then fine, but if not, check `Documents/PureWriter/backups/Auto` or other path you selected for the app. Copy the backups created when you didn't open the Trash book to other places. In this case, the desired backup is probably not the latest, and thus it is recommended to copy more than one backup, just in case.
2. Uninstall Pure Writer, then install the app again.
3. Restore backup. Connect to your Cloud Backup, or copy the local backups back, then restore to the backup created when you didn't open the Trash book.
4. Open the Trash book. Wait patiently, until all articles are loaded, then delete all articles in the Trash book.

**The app may also "freeze" while opening other books or large articles. You may experience it if you open books that you don't open often but frequently move chapters to them, or you switch to a low-end device while having oversized articles.**

## Is it possible to insert bold text or images in articles? {#is-it-possible-to-insert-bold-text-or-images-in-articles}

Pure Writer is an editor designed for plain text, while images or text with styles are so-called rich text, thus you cannot just insert an image like Microsoft Word. However, Pure Writer supports Markdown, thus you can use Markdown syntax to "insert" images, or "insert" bold texts, but to actually see them you'll have to preview the Markdown rendering result.

Coding an editor app to support rich text directly requires a lot more work, and will make the complexity of the editor rises significantly. More complexity means more bugs, less perfect.

So, Pure Writer has never thought of supporting rich text directly, and will not plan to do so in the future.

Interested in Markdown? Read about the brief introduction written by the developers: [Simple Markdown Guide](/zh-hans/markdown/), or just read the part [Pure Writer Markdown User Guide](#pure-writer-markdown-user-guide) in this manual.

## The app automatically creates an article / prompts me to "Skip" on startup {#the-app-automatically-creates-an-article--prompts-me-to-skip-on-startup}

Are you using apps that require you to "turn blah blah on in the Accessibility settings"? If so, it's probably caused by them. For example, if you're using apps that "helps you to skip startup ads", which basically all of them require you to turn on something provided by them, whitelist Pure Writer in these apps, or stop using them.

It should be noted that apps that requires to be turned on in the Accessibility settings can collect more information than other apps. Accessibility is designed for people with disabilities, so apps like TalkBack do have a good reason to have access to everything on the screen, to simulate clicks and swipes, and so on, because people with disabilities do rely on these apps to "see" the screen, or to "click" on the phone. For anything else however, by turning them on in the Accessibility settings, you won't know what they are going to collect, thus may cause leak of personal information, and a huge performance loss.

**See also**: [Case study of phone performance loss caused by Android accessibility service (Chinese)](https://www.androidperformance.com/2019/01/21/android-performance-case-jank-accessbility/)

**Update**: After v14.9.5, Pure Writer now refuses to create an article if the action is caused by these skip startup apps.

## Is there a limit to the number of devices that can log into a Pure Writer account at the same time? {#is-there-a-limit-to-the-number-of-devices-that-can-log-into-a-pure-writer-account-at-the-same-time}

Yes, with a limit of 3 devices. Log in on a 4th device will cause the 1st device to be logged out.

## Pure Writer Pro is lost but I have paid for it on Google Play {#pure-writer-pro-is-lost-but-i-have-paid-for-it-on-google-play}

This is caused by a cache expiration of the Google account on your system. Please make sure you are logged into the Google account that has paid Pure Writer Pro on your device.

The cache may be expired from time to time, and you should keep logged in. This is to prevent sharing accounts, or cases like if a user requests a refund, the app still consider them as "having paid for Pro".

**Solution**: Log out your Google account, then log into the Google account that has paid Pure Writer Pro, then open Pure Writer. This generates a new cache, making sure that Pure Writer Pro is activated.

## Cannot use Enter to insert line breaks on Chromebooks or Android x86 devices {#cannot-use-enter-to-insert-line-breaks-on-chromebooks-or-android-x86-devices}

Some of the Android x86 OSes, or modified ChromeOS-es, may change the way you input a line break. Try Ctrl+Enter or Shift+Enter instead (those two are the most common).

Search the OS and its way to insert line break on the Web if this is not solved.

## Cannot customize some of the features in the app {#cannot-customize-some-of-the-features-in-the-app}

You can search in the settings menu first, in case that it's just that you missed it on the first sight.

However, if we really didn't provide an option for it, then it means that you *shouldn't* change it. It may sound a bit appealing if you get a really detailed settings list, just like an airplane dashboard that can control everything, but if you consider it twice, then providing more options, will only make it more confusing and intimidating, and make settings that are really important to users more inaccessible. The app is designed to be ready to use right out of the box anyway, that is, the default setting should already fit your need. Moreover, providing a more consistent experience to users helps troubleshooting when something goes wrong.

You can leave your comment or send an email to the developer, if you think making [insert feature name] more customizable is better.

## Is there an iOS version of Pure Writer? {#is-there-an-ios-version-of-pure-writer}

**Yes.**

Pure Writer for iOS is available on the App Store for iPhone and iPad with iOS 26 or iPadOS 26 or later. It draws on ten years of building editors and is rebuilt from the ground up around native iOS design and interactions.

Try every feature free for 7 days. Afterwards, choose a monthly subscription, a yearly subscription, or a lifetime membership. If your Pure Writer account already has a membership, sign in to the same account on iOS to keep it, with no need to pay again. Memberships purchased through Google Play are managed by your Google account and cannot be transferred to iOS.

Learn more in [the iOS section of our homepage](/en/#ios-en), or download it from the [App Store](https://apps.apple.com/app/id6803257195).

## Is there a risk of articles being leaked by using Pure Writer? {#is-there-a-risk-of-articles-being-leaked-by-using-pure-writer}

**The app itself will not leak any content you write.**

Leaking users' articles is of no practical use to Pure Writer and is an unworthy and discreditable act.

The backup files are not encrypted however, as this would seriously affect the speed of opening and editing articles and take up the phone's performance, and that if anyone else has access to your Cloud Backup, or device itself (knows your PIN, password and so on), then the encryption is simply of no use anyway. Backups are stored in at most two places: your backup folder on your local device (auto backup and manual backup don't share the exact same folder btw), and your cloud drives connected to in Cloud Backup (without using Cloud Backup, your content may lost when your device is replaced, lost or damaged). Make sure those two places are safe and you are good to go.

Note: We cannot guarantee the safety of articles in cracked versions of Pure Writer. Do not use cracked versions. The free version is perfectly adequate for normal use anyway.

# Pure Writer Backup & Sync FAQ {#pure-writer-backup--sync-faq}

## About Cloud Backup {#about-cloud-backup}

Pure Writer supports Cloud Backup. That is, the app can make use of cloud drives and send backup files to them, and it's simple to set up, once and for all! Despite that we've provided multiple precautions and protection mechanics, without Cloud Backup, your content may still be lost when your device is lost or damaged or factory reset. No one can guarantee that your device will never be damaged or lost, and when bad things happen, without Cloud Backup, your content will be LOST FOREVER.

The app respects and protects the privacy of its users, so our server does not store any private information about the user, and the user's articles are not stored in any locations that aren't set by the user.

Cloud Backup, as said above, is quite easy. you can visit ["Pure Writer - Automatic Backup and Cloud Backup Tutorial" (Chinese)](/zh-hans/backups/) to learn about Pure Writer's automatic backup and Cloud Backup features.

If you do not set up Cloud Backup (for whatever reason, maybe no Internet connection?), you should manually save local backups, frequently, to a location that is still safe when bad things happen.

## Cloud Backup Configuration {#cloud-backup-configuration}

Open the app's settings, then click "Backup & Cloud sync".

To learn more about backup configuration, visit [Automatic Backup and Cloud Backup Tutorial (Chinese)](/zh-hans/backups/).

## Restore articles from old device to new device {#restore-articles-from-old-device-to-new-device}

There are two ways: Cloud Backup, and local backup files.

- Cloud Backup

  Set up Cloud Backup on the new device (be sure the configuration is the same), then click "Restore Backup". Select the backup that is correct (determine it by how many books and articles there are, also backup time, device name). Normally, just choose the latest backup from the old device, then select "OVERWRITE".

- Local backup files

  If your old device is still usable, click "Back up to local storage now" in "Backup & Cloud sync". Go to the backup folder (exact path is shown on that page), find the .pwb file, then send it to the new device. Open the file with Pure Writer, and you are good to go.

  If your old device is not usable, but fortunately manually saved local backups to somewhere that is accessible, send the latest backup file to the new device. You can send it to the backup folder set on the new device, then click "Restore Backup", or just open the backup file with Pure Writer.

  If your old device is not usable, and unfortunately, no local backups are saved, then there is **NO CHANCE to restore your articles**.

## Error: Your WebDAV configuration is incomplete or incorrect. {#error-your-webdav-configuration-is-incomplete-or-incorrect}

- Be sure that your account and password is correct. Maybe you missed some (part) of them, or maybe there are misspellings.
- Be sure that there are no extra spaces or line breaks. This may happen when you copy & paste your settings from elsewhere. Try manually input the configuration, and check twice.
- If there isn't anything wrong on your side, contact with your WebDAV provider.

## Only initial articles are present after restoring a backup on new device {#only-initial-articles-are-present-after-restoring-a-backup-on-new-device}

You should choose the backup file that is **from the old device and correct in file size**. Choosing the backup generated by the new device won't do anything.

## Does Pure Writer support automatic sync? {#does-pure-writer-support-automatic-sync}

There are two modes of Cloud sync: semi-automatic sync and manual sync.

When syncing is enabled, the article content will be automatically merged and updated when syncing between different devices. Please read "About Cloud Sync" in the cloud icon on the top bar of the app for details on sync timing, precautions, etc.

## Why there isn't a "fully automatic" Cloud sync mode? {#why-there-isnt-a-fully-automatic-cloud-sync-mode}

Well, due to Internet connections and other factors, Cloud sync will meet many problems, like conflicts, failures, ambiguous overwrite, thus we cannot make it "fully automatic". It's not even an easy job to handle conflicts on desktop devices (for example, `git`), so, on mobile devices? Nah.

That being said, semi-automatic mode basically fits users' need. Just be sure to read "About Cloud Sync", carefully.

## Is backup content automatically merged when using multiple devices? {#is-backup-content-automatically-merged-when-using-multiple-devices}

You can manually "merge backup" when restoring a backup. If you want to sync content between multiple devices without restoring backups all the time, enable Cloud sync in "Backup & Cloud sync".

**Please read "About Cloud Sync" carefully before enabling Cloud sync. Do not enable it if you don't understand the precaution.**

## How can I ensure that the article being edited is up-to-date when using Cloud sync across multiple devices? {#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices}

- Only using Cloud Backup

  When switching devices, restore backup every time before you use the app. Using "Merge" is preferred.

  If you are using multiple devices, using "Merge" can merge content from all these devices. Still, using one device as your main device is preferred.

  Since only a limited number of files are remained in the cloud drive folder, when one device make multiple cloud backups too often, there is a chance that all backups from other devices will be automatically cleaned.

- Using Cloud sync

  Please read "About Cloud Sync" carefully before enabling Cloud sync.

  There are two modes, semi-automatic sync and manual sync, and articles will sync across devices according to the mode you choose. When using "Manual", click the sync button at the bottom of the editor to sync the article across devices. When using "Semi-automatic", when the article is changed and the on-screen keyboard is collapsed, the sync will be performed automatically, with an interval of at least 6 seconds between syncs.

## Cannot find backup files in Google Drive {#cannot-find-backup-files-in-google-drive}

Google Drive stores backup files in "Application Data" folder, which is always hidden from users.

This also means that you **cannot use "Bridge: Upload" and "Bridge: Fetch"** when using Google Drive.

## Can I use [insert cloud drive provider name] for Cloud Backup? {#can-i-use-insert-cloud-drive-provider-name-for-cloud-backup}

Pure Writer currently supports Cloud Backup with WebDAV, Dropbox and Google Drive.

In theory, any cloud drive providers that supports WebDAV are supported. You can choose TeraCloud from Japan, Yandex Disk from Russia, and Box (box.com) from the United States, as they supports WebDAV.

## Cannot turn off automatic backup {#cannot-turn-off-automatic-backup}

Local automatic backups cannot be turned off, otherwise Pure Writer will not be able to keep your articles safe. The app will not eat up all your storage though, as it only keeps the latest 25 automatic backup files. Any automatic backup files older than those are automatically cleaned. The backups you make by manually clicking "Back up to local storage now" in Pure Writer are not included however; they will be stored in your device permanently unless you delete them yourself.

# Pure Writer Markdown User Guide {#pure-writer-markdown-user-guide}

## What's Markdown? {#whats-markdown}

Markdown is a mark*up* language for creating formatted text using a plain-text editor, easy to learn. Pure Writer supports Markdown (MD), by clicking on the `TXT` icon on the top bar, you can enable Markdown mode (icon shown as `M↓`).

The app also provides Markdown Panel, click the `M↓` icon on shortcut bar to open it.

### Note {#note}

1. **Spaces** are an important part of Markdown. Be careful of spaces.

2. Markdown syntax uses **half-width** characters. If you use a language that often uses full-width characters (e.g. Japanese), be sure to use the half-width ones.

3. Indent settings are **not available** when Markdown mode is on by default. Manually insert the indent if needed.

4. Markdown has variants. Pure Writer follows and implements the standard of CommonMark. Thus syntax in some variants (like `==highlight text==`) **are not supported**.

5. Syntax like heading, list, quote, table, checkbox, horizontal rule are not meant to be used **inline**, that is, you should always use them **at the beginning of the line** for them to be correctly rendered.

6. Pay attention to the cursor's position of a text shortcut. Some of the shortcut entries provided by Pure Writer support to surround the syntax around (before and after) the selected text. Wanna surround the text with your own text shortcut? Put the cursor in the place you want the actual text to be inserted in the content of the Shortcut content field.

7. By CommonMark, there should be **one line break between two lines**, or **two spaces at the end of a line** to render a line break. For example:

   ```md
   Paragraph 1

   Paragraph 2
   ```

   Enabling `GFM Line Breaks` in the app's settings can remove the above limit, thus no line break between two lines will also render a line break. This is enabled by default btw, and the guide will assume that `GFM Line Breaks` is enabled.

8. `|` represent the cursor in this guide, with an exception of the Table section of the guide.

## Guide {#guide}

### Headings {#headings}

In Markdown, headings are `#` + ` ` (a space) + heading content. You can multiple the `#` (up to 6 `#` symbols) to represent six levels of section headings. The more `#` there are, the smaller the heading will be. For example:

```md
# Heading level 1

## Heading level 2

### Heading level 3

#### Heading level 4

##### Heading level 5

###### Heading level 6
```

You can also "close" a heading by adding same amount of `#` after the heading, e.g. `## Heading level 2 ##`, which is not required in the app.

Alternatively, you can make heading like this:

```md
Heading
=======

Sub-heading
-----------
```

This only provides two levels of heading, and there should be more than 3 `=` or `-` for the app to recognize them as a heading. There shouldn't be any line breaks between the heading content and the `=` or `-` lines, otherwise they become normal text + horizontal rules.

### Bold & Italic {#bold--italic}

To make bold text or italic text, you will use `*` or `_` around the text.

Italic text uses one `*` or `_` around the text: `*Italic*` or `_Italic_`.

For bold, then two: `**Boldface**` or `__Boldface__`.

For bold and italic at the same time, then three: `***Boldface and Italic***` or `___Boldface and Italic___`.

The Markdown Panel provides this syntax, but only the `*` one. Using `*` is preferred.

### Underlines & Strikethroughs {#underlines--strikethroughs}

To represent a range of text that has been deleted from a document, use two `~` around the text: `~~Deleted text~~`. The text will be striked through.

Umm, underlines have to be inserted by using HTML tags. Use the tag `<u>|</u>` (`|` represents the cursor) inline to insert a range of text with underline. For exmaple: `<u>Text with underline</u>`.

### Ordered List {#ordered-list}

Ordered list is simple, just add a number, a dot and a space at the beginning of the line: `1. Firstly`.

The app will add `2.` and so on when pressing Enter.

### Unordered List {#unordered-list}

For unordered list, add `-`, `*` or `+` and a space at the beginning of the line. In Markdown Panel, we provide the shortcut and autocompletion of the first two.

The `-` one: `- Unordered list started with a dash`

The `*` one: `* Unordered list started with an asterisk`

The `+` one: `+ Unordered list started with a plus sign`

Note that when rendering unordered lists, list items with the same symbol are more close to each other, and those with different symbols are more separate from each other.

Ordered and unordered lists can be nested with each other, and the nesting can be done by adding at least two spaces in front of the list items.

### Quote {#quote}

When you want to quote a sentence, use `>` + ` ` (a space) + the sentence, e.g. `> Markdown uses email-style characters for blockquoting.`.

### Footnote {#footnote}

Want to add a footnote after a sentence? Add `[^Footnote name]`, and then, write the footnote content anywhere in the text as a seperate line in the following format: `[^Footnote name]:Footnote content`. Do not add a space after the `:` in the app.

Currently you cannot open a footnote as a pop-up, unlike other websites or software. Instead they are considered as links and therefore simply launches the browser, which kinda downgrades the experience. We are sorry for the inconvenience.

### Superscript & Subscript {#superscript--subscript}

Again, you'll have to use HTML tags.

Superscript: `<sup>|</sup>`; and Subscript: `<sub>|</sub>`.

For example: `x<sup>2</sup>+x+1` and `C<sub>2</sub>H<sub>5</sub>OH`.

### Text alignment {#text-alignment}

Again, HTML tags and attributes, this case `<p align="">|</p>`. In Markdown Panel we provide `<p align="center">|</p>`, but you can change `center` to left, center, right.

For example: `<p align="[insert alignment you want]">Text</p>`.

**Do not use** `<center>|</center>` tag.

### Insert images {#insert-images}

Inserting images is a relatively important feature for some of you, with a format of `![]()`.

In the brackets, write the name of the image, and in the parentheses, write the URL / path of the image. Write URL for images from the Web. Select a local image from the file picker when using the shortcut in the Markdown Panel, or write the local path to the local image.

When using online image services (like Imgur), you should pay attention to protect your privacy and choose a trustworthy service. When using local images, they cannot be moved or deleted, otherwise they won't show correctly, and local images aren't backed up with the article.

### Insert links {#insert-links}

It's a bit like inserting images, but you remove the `!`: `[]()`.

Write the link's text in the brackets, and write URL in the parentheses, for example: `[Pure Writer](https://writer.drakeet.com)`.

### Insert Tables {#insert-tables}

In Markdown Panel, we provide a shortcut to insert a table with 3 columns and 4 rows.

It's not Microsoft Excel, you don't get these fancy features, but only simple rows and columns.

Tables consist of 4 symbols: `|`, ` ` (spaces), `:` and `-`. `|` determines columns, spaces are for actual table content, `:` determines alignment of the table header and cells, `-` marks table headers.

For example:

```md
| Alignment left | Alignment center | Alignment right |
| :------------- | :--------------: | --------------: |
| left           |      center      |           right |
| left           |      center      |           right |
| left           |      center      |           right |
```

Result:

| Alignment left | Alignment center | Alignment right |
| :------------- | :--------------: | --------------: |
| left           | center           | right           |
| left           | center           | right           |
| left           | center           | right           |

Notes:

1. When inserting a table, insert a line break above the table, or the table will not be rendered correctly.
2. `:---` to align the cells and table header of the column to left. `:--:` for center and `---:` for right.
3. Spaces between `|` and `-` are ignored when rendering.
4. Spaces between cells' content and `|` are ignored when rendering. You can use spaces to make the table more pretty when not previewing. There must be at least one `-` for the table header.
5. `|` at the beginning and the end of a line can be omitted. Thus you should insert a line break below the table as well, in case that the next line that is supposed not to be in the table, is rendered in the table.

### Checkbox {#checkbox}

Checkboxes consists of `-` + ` ` (a space) + `[]` + ` ` (a space) + content. By adding a space in the brackets, the checkbox will be shown as unchecked. By adding an `x` in the brackets, the checkbox will be shown as checked. We've provided the corresponding shortcut in Markdown Panel; make sure to use it if it doesn't work properly.

For exmaple: `- [ ] Unchecked`, `- [x] Checked`.

### In-page links {#in-page-links}

In-page links, or anchors, point to the headings in the article.

You can navigate by using these links when previewing.

For example:

```md
# title1

...

[Back to title 1](#title1)
```

When previewing, the link will turn blue, and by clicking the link, it navigates to the corresponding heading.

**Note:**

- Headings are `#` + ` ` (a space) + content, but do not add a space in the links.
- Remove the spaces in the link even when there are spaces in the title. (in other softwares or Markdown variants however, they may replace the spaces to `%20` or `-`)
- You can only use these anchors via the option "Preview & Export". Currently these links are not usable in Quick Preview.
- You may experience problems when using these links. They may do nothing at all, or they launch the browser. We can do nothing about it currently, and sorry for the inconvenience.

### Horizontal rules {#horizontal-rules}

Horizontal rules consist of at least 3 dashes `-` in a single line.

Remember the headings? If you want to add a horizontal rule below a line of text, insert a line break between them.

### Text color {#text-color}

HTML tags again, in this case `<font color="|">|</font>`. Format is `<font color="[RGB HEX value or common color names]">Text</font>`.

For exmaple: `<font color="black">These are black!</font>`, `<font color="#000000">These are black too.</font>`.

You **cannot** use text color tag and text alignment tag at the same time. Text color **may not** be changed in this way when you use it in places like tables. **Use it with caution**.

### Escape characters {#escape-characters}

Let's say, you want to insert an asterisk at the beginning of the line, but do not want the line to become an unordered list, you add a backslash `\` before the asterisk. Markdown uses `\` for *escaping* charcters. That is, the symbols used by some syntax become themselves when rendering.

For example, `\*Italic\*` in Markdown will be rendered as `*Italic*`.

### Other HTML tags and syntax {#other-html-tags-and-syntax}

You can use HTML tags in Markdown. While in the app, we support some of them, like underline (`<u>|</u>` or `<ins>|</ins>`), superscript & subscript (`<sup>|</sup>` & `<sub>|</sub>`) and so on.

However, Pure Writer isn't HTML editor, thus we don't support all HTML syntax in the app. Test it out if you want to use some HTML syntax not listed in the guide.

### Code blocks {#code-blocks}

In Markdown, use ` ```|``` ` for inserting several lines of code, and use `` `|` `` to insert inline code.

We support syntax highlighting in code blocks, just specify the language after ` ``` `.

For example:

````md
```js

windows.addEventListener('load', function(){

console.log('windows loaded');

```

```python

def myfun(x):

    return(x**2)

```
````

See also [Markdown Editor Syntax Guide (Chinese)](https://segmentfault.com/markdown).

# Pure Writer Markdown FAQ {#pure-writer-markdown-faq}

## About Markdown standards in this app {#about-markdown-standards-in-this-app}

We follow CommonMark, see more on [CommonMark Spec](https://spec.commonmark.org/0.29/).

For what syntax can be used in this app, try it out on this website by CommonMark: [commonmark.js dingus](https://spec.commonmark.org/dingus/)

## Some Markdown syntax are not rendered in the app {#some-markdown-syntax-are-not-rendered-in-the-app}

Some variants provide an additional syntax for highlighting texts like `==|==`. This isn't in CommonMark, and we don't support them. You can try inline code blocks for a similar appereance (`` `Inline code blocks` ``, you can insert this via Markdown Panel), but again these are "code blocks", thus bold, italic, strikethrough, underline etc. will not be rendered in it.

## Why &lt;center&gt; tag isn't supported? {#why-center-tag-isnt-supported}

Use `<p align="center/left/right">|</p>` instead, as when we were implementing `<center>|</center>`, the app cannot correctly render it.

# Pure Writer Desktop Alpha FAQ {#pure-writer-desktop-alpha-faq}

**This section covers the early desktop alpha, which connected over a local network. The new Pure Writer Desktop is now available and syncs with your phone through the same cloud drive account. Download it from [Pure Writer Desktop](/en/desktop/).**

## Downloading Pure Writer Desktop {#downloading-pure-writer-desktop}

Pure Writer Desktop is delivered through [our website](/en/desktop/), Telegram channel, official QQ group and WeChat group, and Official WeChat account.

Don't trust the versions provided by third parties. We cannot help with content loss or leakage caused by the software downloaded from third party sources.

## Connect to Desktop {#connect-to-desktop}

Make sure the phone (the Android device) and the desktop are connected to the same Wi-Fi network or the same hotspot. Click the cloud icon on the top bar of the app on the phone, click "Connect Desktop", then input the IP address to the input field of Pure Writer Desktop. Once they are connected, the current editing article is synced across those two devices.

- If you see multiple IP addresses, try them line by line.
- The installation path of Pure Writer Desktop for Windows cannot contain special Unicode characters, like Chinese characters, or it won't be able to use.

## Cannot open Pure Writer Desktop {#cannot-open-pure-writer-desktop}

- We only supports 64-bit OSes. Are you using 32-bit OSes?
- Be sure you are downloading the installation file according to your OS.
- The installation path of Pure Writer Desktop for Windows cannot contain special Unicode characters, like Chinese characters, or it won't be able to use.

## Cannot connect the Android device to the desktop device {#cannot-connect-the-android-device-to-the-desktop-device}

- Devices should connect to the same Wi-Fi network or hotspot.
- Check whether your IP address is correct.
- The firewall may block Pure Writer Desktop from accessing to the network. Allow Pure Writer Desktop to have full access to the network (that is, when using Windows, choose the "Public network" option as well).
- AP Isolation may be enabled in your current Wi-Fi network. This is often enabled in public hotspots like those in schools, enterprise or restaurants in order to keep the network safe. Turn on hotspot on your phone or desktop devices, and connect the other device to the hotspot.

## Connection between devices is not stable {#connection-between-devices-is-not-stable}

The network connection itself is not stable. Or, Pure Writer on the Android device is stopped by the device itself for it's being "background running". We can't do anything about the network connection itself.

Currently, many Android devices can stably use this feature. We'll enhance the keep-alive mechanics in later versions. Here is some advice:

- Don't let the Android device automatically stop the app. For example, "Lock" the app in the Recents screen (aka overview screen, recent task list, or recent apps), disable the battery saver for Pure Writer, or simply stop the device from killing any apps running in the background. See also [Don’t kill my app!](https://dontkillmyapp.com/).
- Make sure those two devices are close to the router or AP, thus enhancing the connectivity stability. If your device supports to connect to Wi-Fi and serve as a Hotspot at the same time, connect the Android device to the Wi-Fi, then connect the desktop to the hotspot provided by the Android device, and make sure they are close to each other.

## Auto-connect doesn't work {#auto-connect-doesnt-work}

Your phone's IP address may change after switching from networks to networks. Thus you'll have to write the IP address again in Pure Writer Desktop.

You can try to adjust your Wi-Fi settings of your phone. Click on one of the Wi-Fi connections, then change "IP settings" (or anything alike) to "Static" (or anything alike). In this case, the IP address will not change when connecting to that specific Wi-Fi network.

## Ghosting effect of text in Pure Writer Desktop {#ghosting-effect-of-text-in-pure-writer-desktop}

Try adjust the Refresh Rate setting to "Fixed" (or things alike) in NVIDIA Control Panel (or things alike).

# Easter eggs {#easter-eggs}

## Easter eggs in Pure Writer {#easter-eggs-in-pure-writer}

On the Pure Writer Pro page, repeat an action (I'm not going to tell you that you are going to click something) for several times, and you are going to see the previously abandoned icon design of the app, and also a pop-up.

The previously abandoned design is now used in the splash screen when using Android 12 and above.
