---
title: "How to never lose your writing: autosave, version history and backups - Pure Writer"
description: "How to not lose your writing and how to recover lost writing: the four ways drafts get lost, autosave vs. backup, why sync is not a backup, the 3-2-1 rule, and Pure Writer’s six layers of protection."
date: 2026-11-13
lastmod: 2026-11-13
url: blog/never-lose-your-draft/
jsonld: article
---

<!--
  博客文章：怎样才不会丢稿（英文版）。简体母稿是同目录的 index.zh-hans.md。
  定位：回答「how to not lose your writing」「how to recover lost writing」「autosave vs backup」「does sync count as backup」。
  与母稿的差别：母稿以「写小说怎么存稿」为题，英文读者的说法更泛，标题改为「How to never lose your writing」，
  正文不限于小说；四种丢稿情况、分层的防线、同步不等于备份、3-2-1 原则（作为经验法则）、写长篇的习惯、找回的顺序与母稿一一对应。
  母稿链接的《保护机制》页只有简体中文，这里不链接；六道防线的名目取自母稿，逐项在英文页面里核对过出处：
  - 自动保存、废纸篓：英文首页「Features at a Glance › Saving & Recovery」（Autosave and History；Trash: restore deleted documents）；
  - 撤销与重做：手册「How do I redo something I undid by mistake?」；
  - 历史记录：手册「How do I restore an earlier version of a document from History?」「How long is History kept? Is it included in backups?」；
  - 自动备份：手册「Why can’t I turn off automatic backups?」；
  - 云备份：手册「About cloud backup」「Which cloud services can I back up to?」，《Automatic and Cloud Backup Tutorial》（/en/backups/）。
  「卸载重装后稿子还在吗？」：iOS 版删除 App 时一并删除 App 内的数据与本机备份，取自英文版 iOS 隐私政策
  「Data on your device: deleted when you delete the App」与手册「Could my writing be stolen through Pure Writer?」；
  Android 版卸载不删除备份、重装后选原来的文件夹，取自英文备份教程「Local automatic backups」。
  桌面版卸载后数据怎样，手册没有写，这一问只写 iOS 版与 Android 版（与母稿相同）。
  多设备时保留较晚的修改、被替换的一版在历史记录里：手册「Are backups merged automatically when I use several devices?」。
  维护：手册或备份教程改了相关说法或界面名称，这里跟着改。
-->

# How to never lose your writing: autosave, version history and backups

Writing usually gets lost in one of four ways: you close the app without saving, or it crashes; you delete or overwrite something and the change gets saved; the device is lost, broken or reset, or the app is uninstalled; or one device overwrites newer work from another. The defense is layered: autosave, a version history you can roll back to, a trash folder for deleted documents, local backups, and at least one backup kept off the device.

## Four ways writing gets lost, and how to prevent each

### Closing without saving, or a crash

Use an app that saves automatically. If yours needs saving by hand, save after every paragraph or so (Ctrl+S on Windows, Command+S on a Mac).

### Deleting or changing something, and then it gets saved

The downside of autosave is that a deleted paragraph gets saved just as quickly as a new one. Three things can undo the damage: undo, for a mistake you just made; version history, to go back to how a document looked a few hours or days ago; and a trash folder, to get back a document you deleted entirely.

### A lost, broken or reset device, or an uninstalled app

Everything on a device, including the backups an app keeps there, goes with the device. On phones, uninstalling an app usually deletes the data it keeps inside itself too. That’s why you need at least one backup that isn’t on the device.

### Devices overwriting each other

If you open a draft on your computer and keep writing before your phone has finished syncing its newer version, the old version can replace the new one. Before you switch devices, let the one you were using finish syncing, wait for the changes to arrive on the other, and don’t edit the same chapter on both at once. See [How to sync writing between your phone and computer](/en/blog/sync-writing-between-phone-and-computer/).

## Sync is not a backup

Sync keeps your devices the same: delete a chapter on one, and it’s deleted on the others too. A backup is a copy from an earlier point in time that you can restore after a deletion or a bad edit. You need both.

A common rule of thumb is the 3-2-1 rule: keep at least three copies of your data, on two different kinds of storage, with one copy somewhere else. For a writer, that can be as simple as the original on your device, the backups your writing app keeps on the device, and a copy backed up automatically to a cloud drive or iCloud.

## Habits for long projects

- **One document per chapter.** A single huge file is slower to open, edit and sync.
- **Automatic cloud backup.** Don’t rely on remembering to back up by hand.
- **A check before big changes.** Before you switch phones, reinstall your system or uninstall an app, make sure there’s a recent backup off the device and that it opens.
- **A copy at milestones.** When you finish a part or before you submit, export a TXT or DOCX file and keep it on a cloud drive or another device.

## How to recover lost writing

Work from the nearest option outward:

1. **Undo.** If you just deleted something, try undo first (Ctrl+Z, or Command+Z on a Mac).
2. **Version history.** Look for History, Version History or something similar in your app, and see whether you can go back to a version from before the problem.
3. **Trash.** If a whole document is gone, check the app’s trash, and your computer’s Recycle Bin or Trash.
4. **Local backups.** In the app’s list of backups, find one from before the problem and restore it.
5. **Backups in a cloud drive or iCloud.** If the device is broken or the app is gone, connect the same cloud drive account, or sign in to the same Apple Account, on a new device and restore from there.

Don’t uninstall and reinstall the app while you’re still looking: some apps keep their local backups inside the app, and uninstalling deletes them. If another device may still have the old version, keep it offline so it doesn’t sync, and copy the text off it first.

## The six layers of protection in Pure Writer

Pure Writer protects your writing with these layers:

| Layer | What it does |
|---|---|
| Autosave | Documents are saved automatically as you edit; there’s nothing to save by hand. |
| Undo and redo | Undo a deletion or a change, and redo if you went too far. See [How do I redo something I undid by mistake?](/en/manual/#redo-content-that-was-mistakenly-undone) |
| History | Each document keeps the versions saved recently, and you can restore it to one of them. See [How do I restore an earlier version of a document from History?](/en/manual/#restore-the-content-of-an-article-back-to-an-earlier-revision-through-history) |
| Trash | Documents you delete by mistake can be restored from the Trash. |
| Automatic backups | Backups are kept on your device automatically, in tiers by time, and there’s no switch to turn them off. See [Why can’t I turn off automatic backups?](/en/manual/#cannot-turn-off-automatic-backup) |
| Cloud backup | Connect your own cloud drive (OneDrive, Dropbox or AliyunDrive), and backups are uploaded automatically; on iOS, you can also back up to your own iCloud. See the [Automatic and Cloud Backup Tutorial](/en/backups/). |

History has limits. Each document keeps up to a set number of entries, and older ones are cleaned up. History is stored only on your device: by default it isn’t included in backups, and cloud sync doesn’t bring it to your other devices, so it’s no substitute for backups. With cloud sync on, when the same document was changed on two devices, the later change is usually kept, and the version that was replaced can usually be found in that document’s History.

## FAQ {#faq}

### If my app autosaves, do I still need backups?

Yes. Autosave keeps only the current version: it protects you from closing without saving or a crash, but a deletion or a bad edit gets autosaved too, and if the device is lost or broken, the writing goes with it. You also need a version history and a backup that isn’t on the device.

### Does sync count as a backup?

No. Sync keeps your devices the same, so something deleted on one device is deleted on the others too. A backup is a copy from an earlier point in time that you can restore from after a mistake.

### Will my writing still be there after I uninstall and reinstall the app?

It depends on where the app keeps your documents and backups, so before you uninstall, make sure there’s a usable backup somewhere other than the device. In Pure Writer:

- **iOS**: Deleting the app deletes the documents and local backups inside it. If “Back Up to iCloud” is on, or there are backups in your cloud drive, you can restore from them after you reinstall.
- **Android**: Uninstalling doesn’t delete the backups in `Documents/PureWriter/Backups`. After you reinstall, if Pure Writer asks you to choose a folder, choose the same one as before (usually `Documents`), and you’ll find them again in “Restore backup”.

### How long is version history kept?

It varies between apps, and it’s usually not kept forever. In Pure Writer, each document keeps up to a set number of History entries and older ones are cleaned up; on iOS, History also has a size limit. To back up History along with your documents, use “Back up locally with all history” on Android or “Back Up Now (Including History)” on iOS.
