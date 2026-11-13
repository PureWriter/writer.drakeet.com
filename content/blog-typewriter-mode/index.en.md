---
title: What is typewriter mode? Typewriter scrolling vs. focus dimming - Pure Writer
description: "Typewriter mode means either typewriter scrolling, which keeps the line you’re typing at a fixed height, or dimming all but the current sentence, line or paragraph. How they differ and when to turn them off."
date: 2026-11-13
lastmod: 2026-11-13
url: blog/typewriter-mode/
jsonld: article
---

<!--
  博客文章：打字机模式是什么（英文版）。简体母稿是同目录的 index.zh-hans.md。
  定位：回答「typewriter mode」「what is typewriter mode」「typewriter scrolling」「focus mode vs typewriter mode」。
  结构与母稿相同：两种含义（打字机滚动、聚焦淡化）与对比、适用场合与何时关闭，后半与常见问题里才写纯纯写作三端的做法。
  不写打字机的历史，也不描述别家软件的具体做法。
  与母稿的差别：英文读者常把「focus mode」与「typewriter mode」混着搜，所以「是不是一回事」一问照留，问法改成英文的说法；
  第二种含义在英文里没有通行的叫法，正文称作「focus dimming」，只作说明用，不当作术语强调。其余内容与母稿一一对应。
  纯纯写作的事实与界面名称取自英文使用手册（content/manual/index.en.md）：「What is typewriter mode?」
  「Why is only one paragraph or line of my text clear?」「About status bar focus mode (Android)」，
  以及「What is Markdown?」下「Note」第 3 条（iOS 版的打字机模式在 Markdown 文章里不生效）；产品一句话介绍取自英文首页。
  桌面版的「Keep the last edited line near the center」，手册只写了名字、说明它不是淡化效果；本文按名字说它接近
  「打字机滚动」，没有展开它的具体行为（与母稿相同）。
  维护：手册改了相关说法或界面名称，这里跟着改。
-->

# What is typewriter mode? Typewriter scrolling vs. focus dimming

Typewriter mode is a display option in writing apps that borrows something from writing on a typewriter. The name usually refers to one of two things. Typewriter scrolling keeps the line you’re typing at a fixed height on the screen, usually the middle, and moves the text up as you write. Focus dimming shows the sentence, line or paragraph you’re working on normally and fades the rest. Apps don’t agree on which one the name means: some use it for the first, some for the second, and some offer both.

## Two kinds of typewriter mode

### Typewriter scrolling: the text moves, your eyes stay put

In an ordinary editor, the cursor moves down the screen as you write. Once it reaches the bottom, the page scrolls up one line at a time, so for most of a long session you’re looking at the bottom edge of the screen. On a phone, that means the line you’re typing stays pressed against the top of the on-screen keyboard.

Typewriter scrolling fixes the line you’re typing at a set height, usually the middle of the screen. Each new line moves the text up instead of moving the cursor down. That’s how a typewriter works: the point where letters land stays still, and the paper rolls up.

### Focus dimming: only the current passage stays clear

Focus dimming leaves scrolling alone and changes contrast instead. The sentence, line or paragraph with the cursor is shown normally, and the rest of the text is faded. When you move on to the next paragraph, the highlight moves with you.

This borrows the other side of the typewriter: once a word is typed, it’s hard to change, so you keep going forward. Fading what you’ve already written makes it easier to keep writing instead of rereading.

### Side by side

| | Typewriter scrolling | Focus dimming |
|---|---|---|
| What it does | Keeps the line you’re typing at a fixed height; the text moves up with each new line | Shows the current sentence, line or paragraph normally and fades the rest |
| What changes | Where the text sits on the screen | How bright the text is |
| What it helps with | Your eyes stay in one place instead of following the bottom of the screen | Earlier text is less distracting, so you’re less tempted to go back and edit |

The two don’t conflict, and some apps let you turn on both. When an app mentions typewriter mode, check which kind it means. If the effect isn’t what you expected, you may be looking for the other one.

## When to use typewriter mode

### For first drafts

The hardest part of a first draft is not stopping to fix what you just wrote. With the previous paragraphs in full view, it’s easy to start reworking a sentence or cutting a paragraph, and your momentum is gone. Focus dimming keeps your attention on the paragraph in front of you. Typewriter scrolling keeps the line you’re typing at a comfortable height, so you’re not looking down at the bottom of the screen for an hour at a time.

Focus dimming has a side benefit: faded text is hard to read from a distance, so someone glancing at your screen from behind you is less likely to make out what you’re writing.

### Turn it off for revising and proofreading

Revising means reading the whole piece and comparing one part with another: whether the plot contradicts itself, whether a word comes up too often, whether one paragraph leads naturally into the next. Faded text gets in the way of that, so turn focus dimming off. Typewriter scrolling matters less when you revise, but with the line you’re editing held in the middle of the screen, less text fits below it. Turn it off too when you want to see as much text as possible at once.

That’s why many writers turn typewriter mode on while drafting and off while revising, and use it as a switch between writing and editing.

## Typewriter mode in Pure Writer

Pure Writer is a plain text editor for writing, available for Android, iPhone and iPad, and desktop. Its typewriter mode is the second kind: the paragraph with the cursor is shown normally and the rest of the text is dimmed. It differs between the apps:

- **Android**: Turn “Typewriter mode” on or off in Settings. Under “Typewriter mode” in “Settings › Fine-tuning”, you can choose “Paragraph mode” or “Line mode” (requires Pure Writer Pro).
- **iOS**: Turn “Typewriter Mode” on or off in Settings. It highlights only the current paragraph, and it works only in plain text documents, not in Markdown documents.
- **Desktop**: There’s no dimming effect. Settings has a different option, “Keep the last edited line near the center”, which, as the name suggests, is closer to typewriter scrolling.

For more, see [What is typewriter mode?](/en/manual/#typewriter-mode) in the user manual.

## FAQ {#faq}

### Why is only one paragraph clear while the rest of my text is faded?

A focus-dimming typewriter mode is on: the app shows the paragraph (or sentence, or line) with the cursor normally and fades the rest. Your text hasn’t changed, and it looks normal again once you turn the option off. In Pure Writer, this is typewriter mode, which you can turn off in Settings on both Android and iOS. Pure Writer for Android can also be set to highlight only the line with the cursor, so if only one line is clear, the cause is the same.

### How do I turn off typewriter mode?

Find “Typewriter mode” or a similarly named switch in the app’s settings and turn it off. In Pure Writer:

- **Android and iOS**: Turn off “Typewriter mode” (on iOS, “Typewriter Mode”) in Settings.
- **Desktop**: There’s no dimming to turn off. If you don’t want the last edited line kept near the center of the screen, turn off “Keep the last edited line near the center” in Settings.

### Is focus mode the same as typewriter mode?

No. “Focus mode” means different things in different apps; often it hides toolbars, menus and other parts of the interface so that only the text is left on the screen. Typewriter mode acts on the text itself, changing where it sits or how bright it is.

Pure Writer for Android has a “Status bar focus mode”, which only simplifies the system status bar, keeping essential icons such as the battery; it has nothing to do with typewriter mode. It’s in “Settings › Status bar focus mode” and is available only when “Hide status bar” is off. Pure Writer for iOS doesn’t have this option. For a cleaner writing screen on iOS, turn on “Hide the Status Bar” in Settings.

### Does typewriter mode work in Markdown documents?

It depends on the app. In Pure Writer for iOS, typewriter mode works only in plain text documents, not in Markdown documents.
