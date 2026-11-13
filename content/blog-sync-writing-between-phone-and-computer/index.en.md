---
title: How to sync writing between your phone and computer - Pure Writer
description: "To write on your phone and continue on your computer, use an online editor, a cloud drive folder or a writing app that syncs. How they compare, how to avoid overwrites, and how to set it up in Pure Writer."
date: 2026-11-13
lastmod: 2026-11-13
url: blog/sync-writing-between-phone-and-computer/
jsonld: article
---

<!--
  博客文章：手机和电脑同步写作怎么设置（英文版）。简体母稿是同目录的 index.zh-hans.md。
  定位：回答「sync writing between phone and computer」「write on phone and continue on computer」
  「writing app that syncs between phone and PC」。
  结构与母稿相同：三种办法的对比、容易出问题的地方（冲突与覆盖、以为同步完了、同步不等于备份），后半是纯纯写作的设置步骤，
  篇幅不超过全文三分之一。通用部分只写这类办法的共性，不点评具体产品。
  与母稿的差别：删去「中国大陆的用户推荐使用阿里云盘」一句，三家网盘中性并列，名称照英文手册写作 OneDrive、Dropbox、
  AliyunDrive（Android 与桌面版英文界面的顺序）；常见问题最后一问里的坚果云删去，只写 WebDAV 与 Google Drive。
  关于纯纯写作的事实与界面名称取自英文使用手册：「How does Pure Writer Desktop sync with my phone?」
  「Does Pure Writer sync automatically?」「Does sync happen in real time?」「Are backups merged automatically when I use
  several devices?」「How do I make sure I’m editing the latest version across devices?」「Why am I asked to update Pure Writer
  on my other devices?」「Pure Writer Desktop won’t sync with my phone」「About cloud backup」「Which cloud services can I back up to?」
  「How do I set up cloud backup?」。
  维护：手册改了上述各节的说法（同步时机、冲突的处理、手动同步的入口、支持的网盘、版本要求、排查顺序）或界面名称，这里跟着改。
-->

# How to sync writing between your phone and computer

There are three common ways to work on the same draft on your phone and your computer: an online document editor, a cloud drive’s synced folder, or a writing app with built-in sync. Whichever you choose, three habits prevent most problems: sign in to the same account on both devices, let one device finish syncing before you switch to the other, and don’t edit the same document on both at once.

## Three ways to sync

| | Online document editor | Cloud drive synced folder | Writing app with built-in sync |
|---|---|---|---|
| Needs a connection to edit? | Usually, though some offer offline editing | No; only to sync | Usually not; changes sync once you’re back online |
| Where your text is stored | On the provider’s servers | A file on each device, plus a copy in the cloud drive | A copy on each device; the sync data is on the app’s servers or in a cloud drive you connect, depending on the app |
| When both sides change the same text | Changes are usually merged in real time | The drive doesn’t understand what’s in the file, so it usually keeps one version or saves a conflicted copy for you to compare | Depends on the app; common approaches are keeping the later change or keeping both versions |
| Best for | People with a reliable connection who write with others | People who manage drafts as files and write mostly on a computer | People who write on their phone a lot and need to pick up long drafts anywhere |

A synced folder is easiest on a computer. On a phone, you usually need the cloud drive’s app, or an editor that can read and write files in the cloud drive, to open a file, edit it and save it back.

## Where syncing usually goes wrong

### Editing on both sides at once

If you edit a document on your computer before the changes from your phone have gone out, you end up with two versions. When they sync, the software has to decide what to keep: some apps keep the later version, others keep both and let you choose. Either way, you’ll need to check and tidy up afterward.

The fix is to write each document on only one device at a time. If both sides really were changed, first find the version that was replaced in the version history, then combine the two by hand.

### Thinking it has synced when it hasn’t

The most common case: you finish writing on your phone and lock the screen or switch to another app right away. To save battery, phones limit what apps can do in the background, so your changes may not go out until the next time you open the app. A dropped connection or an expired cloud drive sign-in can also stop syncing.

The other case is when one device has finished syncing but the other hasn’t received the changes yet. A finished sync only means that this device has exchanged changes with the cloud; the other device updates only after it’s online and checks for changes.

So before you switch devices, check the sync status or sync once by hand. On the other device, make sure the last paragraph you wrote has arrived before you start writing.

### Sync is not a backup

The point of syncing is to keep your devices the same. If you delete a chapter by mistake on one device, the deletion syncs to the others; if you replace a long passage by mistake, the replacement syncs too.

So alongside sync, you need a backup that sync doesn’t change, such as backup files you save regularly or backups your writing app makes automatically.

## Syncing between phone and computer with Pure Writer

Pure Writer for Android, iOS and desktop (Windows and macOS) syncs through your own cloud drive: connect each device to the same account of the same cloud drive and turn on cloud sync. All three apps support OneDrive, Dropbox and AliyunDrive. You don’t need a Pure Writer account, and your devices don’t need to be on the same Wi-Fi network or online at the same time.

- **Desktop**: Click the cloud icon in the top-right corner of the window to open the “Backup and sync” window, click “Sign in to OneDrive”, “Sign in to Dropbox”, or “Sign in to AliyunDrive”, allow access in your browser, then return to Pure Writer and click “Continue”. Then check “Cloud sync”. The first time you turn it on, keep Pure Writer open until it shows “First sync complete”.
- **Android**: In “Settings › Backup & cloud sync”, set “Cloud connection type” to the same cloud drive, sign in to the same account, then check “Cloud sync”.
- **iOS**: In “Settings › Backup & Cloud Sync › Cloud Drive”, connect the same cloud drive account, then turn on “Cloud Sync”.

Syncing doesn’t happen keystroke by keystroke: while you keep writing, Pure Writer syncs at intervals, and when you stop typing, hide the keyboard or leave the app, it starts syncing shortly after. Before switching devices, you can sync by hand: on desktop, click “Cloud sync” at the bottom of the window; on Android, tap the sync button at the bottom of the editor; on iOS, tap “Sync Now” in “Settings › Backup & Cloud Sync › Cloud Sync”. Please update Pure Writer to the latest version on every device, because earlier versions can’t read the new sync data.

For more, see the [Pure Writer Backup & Sync FAQ](/en/manual/#pure-writer-backup--sync-faq) in the user manual.

## FAQ {#faq}

### Do my phone and computer need to be on the same Wi-Fi network to sync?

No. Online document editors, cloud drives and writing apps with cloud sync all sync over the internet, so each device just needs its own connection. Pure Writer syncs through a cloud drive, and your devices don’t need to be online at the same time or signed in to a Pure Writer account.

### Does syncing between phone and computer happen in real time?

It depends. Online document editors usually save to the server as you type, a cloud drive uploads a file after it’s saved, and writing apps each have their own timing. Pure Writer doesn’t sync keystroke by keystroke; it starts syncing shortly after you stop typing or leave the app.

### What happens if I edit the same document on my phone and computer at the same time?

If neither side’s changes have synced yet, you get a conflict. Online document editors can usually merge both sets of changes; a cloud drive usually keeps one version or saves a conflicted copy; writing apps handle it in different ways. Pure Writer doesn’t splice the text from both sides together: it usually keeps the later change, and the version that was replaced can usually be found in that document’s History.

### Why won’t Pure Writer sync between my phone and computer?

Check these in order: both sides use the same cloud drive and are signed in to the same account; “Cloud sync” is turned on on both; Pure Writer is updated to the latest version on every device; your network connection works and your cloud drive sign-in hasn’t expired; and your device’s time is correct. Pure Writer for Android can’t sync with Pure Writer Desktop when it uses WebDAV or Google Drive. For troubleshooting and how to export diagnostics, see [Pure Writer Desktop won’t sync with my phone](/en/manual/#cannot-connect-the-android-device-to-the-desktop-device) in the user manual.
