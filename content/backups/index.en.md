---
title: Automatic and Cloud Backup Tutorial - Pure Writer
description: How to set up backups in Pure Writer for Android, iOS, and desktop. It covers where local automatic backups are kept, connecting OneDrive, Dropbox, or AliyunDrive for cloud backup, “Back Up to iCloud” on iOS, and restoring from a backup.
lastmod: 2026-11-07
---

<!--
  自动备份与云备份教程（英文）。旧地址 /backups_en 是 2019—2023 年的 Android 版备份教程的入口，服务器 301 到这里。

  来历：旧英文页停在 2023 年，只有 Android 的两节（自动备份、Dropbox 等网盘），比简体版短得多；第一轮迁移按旧站线上版本原样保留。
  2026-11-07 官网重建的第 F 步，据重写后的简体中文页（index.zh-hans.md）逐段重做，章节与简体一一对应：
  本机自动备份、连接网盘、iOS 的「Back Up to iCloud」、给仍在用 WebDAV 或 Google Drive 的读者的一小节、从备份恢复、云同步。
  旧页标题里的拼写错误「Bakup」随重写改正，id 不变。
  只适合中国大陆的内容不写（docs/content.md 第七节）：
  - 坚果云：WebDAV 一小节只讲 WebDAV 与 Google Drive，不提坚果云的应用密码与网址写法；
  - 「中国大陆的用户推荐使用阿里云盘」一句；
  - 网盘切换截图 DriveOnAndroidGuide.jpg（中文界面，构建的市场检查会拦）。
  从备份恢复一节不提纯纯写作账号：iOS 的账号入口只在简体中文界面显示，繁体与英文不引导读者登录账号；
  只说恢复要靠存有备份的网盘、iCloud 或备份文件，与英文手册「About cloud backup」一致。

  写法：
  - 事实以英文使用手册「Pure Writer Backup & Sync FAQ」一章为底本，说法与手册一致；细节链到手册对应的问答，不在这里重复。
    改这一页时先对照简体页与英文手册，三者不能互相矛盾。
  - 只写各端已经发布的现行行为；分端写「**Android**:」「**iOS**:」「**Desktop**:」，与英文手册相同。
  - 界面名称照各端英文界面的实际写法（Android values/strings.xml、iOS Localizable.xcstrings 的 en、桌面版 res/StringRes.kt），
    用弯引号括起，菜单路径用 ›；动作写 tap（手机）、click（电脑）。
  - 网盘写 AliyunDrive（iOS 与桌面版的英文界面这样写；Android 英文界面写作「Aliyun Drive」，Android 的设置步骤里照界面写），
    与英文手册相同。三家并列时按 Android 与桌面版英文界面的顺序写 OneDrive、Dropbox、AliyunDrive；
    专讲 iOS 时照 iOS 英文界面的顺序 Dropbox、OneDrive、AliyunDrive。
  - Android 列表里 WebDAV 与 Google Drive 的名字带「(not supported in new versions)」，正文转述，不加引号。
  - hugo.toml 关闭了 typographer，弯引号与撇号直接写在源文件里。

  锚点与结构：
  - 旧页（069a297:backups_en.html，Typora 生成）的三个 id 都沿用：标题；「Auto Backup」的 id 落在本机自动备份一节；
    「Cloud Sync & Backup」的 id 落在连接网盘一节。新增的章节不写 id，由 Hugo 按标题生成；页内链接用的是生成的 id，
    改这些标题时要一并改链接。
  - 整页一个 h1，章节 h2，小节 h3（docs/content.md 第八节）。没有截图。
-->

# Automatic and Cloud Backup Tutorial {#pure-writer---auto-bakup--cloud-backup-tutorial}

Pure Writer automatically keeps backups on your device, so you can restore your documents if something is deleted by mistake or goes wrong. But local backups are on the same device as your documents: if the device is lost, damaged, or reset to factory settings, they’re lost together, and on iOS, local backups are also deleted when you delete the app.

So please set up at least one kind of cloud backup: connect your own cloud drive, and on iOS, you can also use “Back Up to iCloud”. You only need to set it up once. After that, Pure Writer backs up automatically, and there’s nothing you need to do day to day; when something needs your attention, such as an expired cloud drive sign-in, Pure Writer lets you know.

This tutorial explains how to set it up on Android, iOS, and desktop. The backup settings are in:

- **Android**: “Settings › Backup & cloud sync”; the menu of the cloud icon in the top-right corner of the main screen also has this item;
- **iOS**: Tap the button in the top-right corner of the editor (it usually shows the current document’s format) and choose “Backup & Cloud Sync”. You can also tap “⋯” on the right of the top bar, tap the gear in the top-right corner to open “Settings”, and choose “Backup & Cloud Sync”;
- **Desktop**: Click the cloud icon in the top-right corner of the window to open the “Backup and sync” window.

For more questions, see the [Pure Writer Backup & Sync FAQ](/en/manual/#pure-writer-backup--sync-faq) in the User Manual.

## Local automatic backups {#auto-backup}

When your documents change, Pure Writer automatically makes a backup on your device. There’s nothing to set up, and it can’t be turned off. Automatic backups don’t take up storage without limit: they’re kept in tiers by time, with more kept from recent times and fewer from earlier periods, and older ones are cleaned up automatically. Backups you make by hand aren’t cleaned up automatically; they’re kept until you delete them yourself.

- **Android**: Backups are saved in the Pure Writer folder in your phone’s storage, usually `Documents/PureWriter/Backups`. Tap “Back up locally” to make one right away. Uninstalling Pure Writer doesn’t delete these backups. After you reinstall, if Pure Writer asks you to choose a folder, choose the same one as before (usually `Documents`), and you’ll find them again in “Restore backup”. If you’ve chosen a folder, you can see it in “Settings › PureWriter folder”.
- **iOS**: Backups are kept inside the Pure Writer app. Under “Local Backups” in “Backup & Cloud Sync”, there are three groups: “Automatic Backups”, “Manual Backups”, and “Before Restore”, and below them you can see how far back automatic backups go. Tap “Back Up Now” to make a manual backup. To save a copy somewhere else, tap “⋯” next to that backup under “Manual Backups” and choose “Save to Files”.
- **Desktop**: Backups are saved in the `Backups` folder inside the data folder, and the backup list is in the “Backup and sync” window. On Windows, the data folder is PureWriter in your Documents folder; on macOS, it’s PureWriter in your home folder.

By default, backups don’t include History. To back up History too, use “Back up locally with all history” on Android or “Back Up Now (Including History)” on iOS; see [How long is History kept? Is it included in backups?](/en/manual/#how-long-is-history-kept-is-it-included-in-backups)

Some automatic backups may be incremental backups, which save only what changed. You can restore from them in Pure Writer as usual, but their files can’t be used on their own to restore. For how they differ from full backups, see [What’s the difference between incremental and full backups in the backup list?](/en/manual/#whats-the-difference-between-incremental-and-full-backups-in-the-backup-list)

## Cloud backup: connecting a cloud drive {#cloud-sync--backup}

Cloud backup saves backups to your own cloud drive, so you can restore from it when you switch devices or your device is lost or damaged. The cloud drives each app supports:

- **Android**: OneDrive, Dropbox, and AliyunDrive. WebDAV and Google Drive are also listed, marked as not supported in new versions; we no longer recommend them (see [below](#still-using-webdav-or-google-drive-android)).
- **iOS**: Dropbox, OneDrive, and AliyunDrive. There’s also “Back Up to iCloud” (see [below](#back-up-to-icloud-ios)).
- **Desktop**: OneDrive, Dropbox, and AliyunDrive.

If you use Pure Writer on several devices, choose the same cloud drive on each of them and sign in to the same account. All three apps use only one cloud drive at a time; to switch to another one later, see [Can I back up to two cloud drives at the same time?](/en/manual/#can-i-back-up-to-two-cloud-drives-at-the-same-time)

**Android**:

1. Open “Settings › Backup & cloud sync”.
2. Tap “Cloud connection type” and choose the cloud drive you want: OneDrive, Dropbox, or Aliyun Drive.
3. Tap “Sign in” below it, then follow the prompts to sign in to your cloud drive account and allow access.
4. Once you’re signed in, Pure Writer uploads backups to your cloud drive automatically. To back up right away, tap “Back up to cloud”.

**iOS**:

1. Open “Backup & Cloud Sync” and tap “Cloud Drive”.
2. Tap “Connect Dropbox”, “Connect OneDrive”, or “Connect AliyunDrive”, then follow the prompts to sign in to your cloud drive account and allow access.
3. Once connected, Pure Writer uploads backups to your cloud drive automatically. To upload one right away, tap “Back Up to Cloud Now”.

**Desktop**:

1. Click the cloud icon in the top-right corner of the window to open the “Backup and sync” window.
2. Click “Sign in to OneDrive”, “Sign in to Dropbox”, or “Sign in to AliyunDrive”.
3. Sign in to your cloud drive account in your browser and allow access, then return to Pure Writer and click “Continue”.
4. Once you’re signed in, Pure Writer uploads backups to your cloud drive automatically.

### Back Up to iCloud (iOS)

Pure Writer for iOS also has “Back Up to iCloud”. When iCloud is available on the system, it’s on by default and automatically saves a copy of your backups to your own iCloud, for restoring after you switch devices or reinstall the app. You can find its switch and status in “Backup & Cloud Sync › Back Up to iCloud”. Before using it, make sure this device is signed in to an Apple Account and that there’s space left in your iCloud storage.

- It can be used together with a cloud drive.
- Backups in iCloud can be restored only in Pure Writer for iOS, not on Android or desktop.
- It’s only for restoring and doesn’t sync what you’re editing. Images in Markdown documents aren’t saved with it either; they’re saved with your cloud drive backups.

### Still using WebDAV or Google Drive? (Android)

Under “Cloud connection type” on Android, WebDAV and Google Drive are marked as not supported in new versions: new versions released after October 31, 2027 won’t support them. Versions already installed aren’t affected and won’t stop working. With them, images in Markdown documents aren’t saved with cloud backup and cloud sync, and you can’t sync with Pure Writer for iOS or Pure Writer Desktop.

We recommend switching to OneDrive, Dropbox, or AliyunDrive:

1. On the “Backup & cloud sync” page, tap “Cloud connection type”, choose one of them, and sign in;
2. Tap “Back up to cloud”.

If you use cloud sync on several devices, switch first on the device with the latest content, then switch your other devices to the same cloud drive. The backups already on your WebDAV server aren’t deleted. For more, see [About WebDAV (Android)](/en/manual/#about-webdav-android) and [I can’t find my backup files in Google Drive (Android)](/en/manual/#cannot-find-backup-files-in-google-drive).

## Restoring from a backup

When you get a new device or reinstall Pure Writer, you can restore your documents from a cloud drive, from iCloud (iOS only), or from a backup file:

- **From a cloud drive**: On the new device, connect the same cloud drive account as on the old one (see [above](#cloud-sync--backup)). If the new device has no content yet, Pure Writer asks whether to restore from a backup it finds in the cloud drive; just follow the prompts. You can also choose a backup from the backup list at any time: on Android, in “Restore backup”; on iOS, in “Cloud Drive › Cloud Backups” or “Recent Backups”; on desktop, in the backup list in the “Backup and sync” window. Usually, you can choose the latest one from your old device.
- **From iCloud (iOS)**: If your old iPhone or iPad had “Back Up to iCloud” turned on, sign in to the same Apple Account on the new device and install Pure Writer, and it asks whether to restore from the backup in iCloud. You can also choose “Restore from iCloud Backup” in “Back Up to iCloud”.
- **From a backup file**: Full backups (`.pwb` files) from any of the three apps can be restored on the others. For how to export a backup file on the old device and import it on the new one, see [How do I restore documents from my old device on a new one?](/en/manual/#restore-articles-from-old-device-to-new-device)

When restoring, you can choose “Merge” or “Overwrite” (on iOS, “Merge and Restore” or “Overwrite and Restore”):

- **Merge**: keeps the content on this device and merges in the content of the backup. Choose this if you’ve already written something on the new device.
- **Overwrite**: first makes a backup of the content on this device, then replaces it with the content of the backup. When cloud sync is on, it becomes “Restore and sync” (on iOS, “Overwrite and Sync”); see [Merge or overwrite?](/en/manual/#merge-or-overwrite)

Also keep in mind:

- To restore your documents, you need a cloud drive or iCloud that has your backups, or a backup file.
- If your old device no longer works, and there are no backups in your cloud drive or iCloud and no backup files you saved yourself, your documents can’t be restored.
- If you still see the starting documents after restoring, you’re usually still in the original book; see [Why do I still see the starting documents after restoring a backup on a new device?](/en/manual/#only-initial-articles-are-present-after-restoring-a-backup-on-new-device)

## Cloud sync

Once a cloud drive is connected, you can also turn on cloud sync, which syncs documents between the devices signed in to the same cloud drive account, including new documents, edits, and deletions:

- **Android**: Check “Cloud sync” on the “Backup & cloud sync” page;
- **iOS**: Turn it on in “Backup & Cloud Sync › Cloud Sync”;
- **Desktop**: Check “Cloud sync” in the “Backup and sync” window.

Connect all your devices to the same account of the same cloud drive, and update Pure Writer to the latest version on each of them. Cloud sync is no substitute for backups: something deleted on one device is deleted on your other devices too. Please read the explanation in the app before turning it on. For when syncing happens and what to keep in mind when you use several devices, see [Does Pure Writer sync automatically?](/en/manual/#does-pure-writer-support-automatic-sync) and [How do I make sure I’m editing the latest version across devices?](/en/manual/#how-can-i-ensure-that-the-article-being-edited-is-up-to-date-when-using-cloud-sync-across-multiple-devices)
