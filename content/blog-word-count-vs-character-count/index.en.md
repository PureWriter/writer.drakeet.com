---
title: "Word count vs. character count: what’s the difference? - Pure Writer"
description: "Word count and character count are not the same: one counts words, the other every letter, digit and punctuation mark, with or without spaces. An example counted each way, and why tools disagree."
date: 2026-11-13
lastmod: 2026-11-13
url: blog/word-count-vs-character-count/
jsonld: article
---

<!--
  博客文章：字数与字符数的区别（英文版）。简体母稿是同目录的 index.zh-hans.md。
  定位：回答「word count vs character count」「is word count and character count the same」
  「difference between word count and character count」「character count with spaces」。
  与母稿的差别（为英文读者重写）：
  - 母稿的主线是中文的「字数」（汉字与标点一个算一个，一串英文或数字算一个词）。英文版改为以 words 与 characters
    （with spaces、no spaces）为主线，换成英文例句。
  - 加了一节「为什么不同工具数得不一样」：连字符、数字、单独的标点、emoji 与 UTF-16 编码单元。
    只写可以从计数方式推出的情形（只按空格分词的工具会怎样数），不说某个具体软件怎样数。
  - 母稿「英文和日文怎么数」改成「中文与日文」一节：词与词之间不用空格，所以按字符计数；这一节沿用母稿的中英混排例句，
    纯纯写作设置项的作用在这里最明显。
  - Word 的「字数统计」对话框只写确定的三项：「Words」「Characters (no spaces)」「Characters (with spaces)」。
  - 母稿「投稿与平台上的字数」压成一段，不写任何平台的具体规则与上限。
  例句「The rain stopped, and she finally opened the letter.」：按空白分词 9 个单词；字母 42、标点 2（逗号、句号）、
  空格 8；计空格 52、不计空格 44、不计空格与标点 42。母稿例句「周末用 iPhone 写了 2000 字，很开心。」共 25 个字符：
  汉字 9、字母 6、数字 4、中文标点 2、半角空格 4；按空白分开是 5 段。以上都用 Python 逐个数过，改例句时重新数。
  emoji 的编码单元：👍 是 2，带肤色的 👍🏽 与国旗 🇯🇵 各是 4（同样用 Python 核对过）。
  纯纯写作的事实与界面名称取自英文使用手册「About the word count options」一节；母稿例句在纯纯写作里的两个计数
  （13 与 21）按该节对「Count words individually」与「Exclude spaces and line breaks」的说明推出（与母稿相同）。
  英文例句在纯纯写作里的计数不写：手册没有说半角标点在「Count words individually」下怎样计。
  维护：手册改了相关说法或界面名称，这里跟着改。
-->

# Word count vs. character count: what’s the difference?

Word count and character count are not the same. A word count is the number of words in a text. A character count is the number of individual characters: every letter, digit and punctuation mark, and, if you count “with spaces”, the spaces too. An English sentence has several times more characters than words, and the two character counts differ by exactly the number of spaces in the text.

## Words, characters and spaces

- **Word count**: most tools count a word as a run of characters between spaces or line breaks, so a comma or period attached to a word doesn’t add to the count. “letter.” is one word.
- **Character count without spaces**: every letter, digit and punctuation mark counts as one; spaces don’t.
- **Character count with spaces**: the same, plus the spaces between words. Whether line breaks are counted too varies from tool to tool.

## One sentence, counted four ways

> The rain stopped, and she finally opened the letter.

This sentence has 42 letters, 2 punctuation marks (a comma and a period) and 8 spaces.

| Count | Result | What’s counted |
|---|---|---|
| Words | 9 | The, rain, stopped, and, she, finally, opened, the, letter |
| Characters with spaces | 52 | 42 letters + 2 punctuation marks + 8 spaces |
| Characters without spaces | 44 | 42 letters + 2 punctuation marks |
| Characters without spaces or punctuation | 42 | Letters only |

Every number in that table is a correct answer to “how long is this sentence?” Before you compare two counts, make sure they were made the same way.

## The Word Count dialog in Microsoft Word

Microsoft Word’s Word Count dialog shows several numbers. Three of them match the counts above:

- “Words”
- “Characters (no spaces)”
- “Characters (with spaces)”

The difference between the two character counts is the number of spaces in your document.

## Why different tools give different counts

Even two tools that both count “words” don’t always agree. The usual reasons:

- **Hyphenated words.** Is “e-mail” one word or two? A tool that splits only at spaces counts “a 2,000-word draft” as three words; one that also splits at hyphens counts four.
- **Numbers.** “2,000” and “3.5” are normally one word each, but a tool that treats commas and periods as separators may split them.
- **Punctuation on its own.** A dash with spaces on both sides counts as a word in a tool that splits only at spaces.
- **Emoji.** Many programs count characters in UTF-16 code units, the way programming languages such as JavaScript and Java measure the length of a string. Common letters, digits, punctuation marks and Chinese characters take one code unit each, but many emoji take two, and emoji built from several characters, such as a thumbs-up with a skin tone or a country flag, can take four or more.

None of these is a mistake. The tools are answering slightly different questions.

If you’re writing to a limit, go by the counting rule the publication, contest or website states, or the number its own form shows, and leave some margin if you’re not sure.

## Chinese and Japanese: characters instead of words

Chinese and Japanese are written without spaces between words, so splitting at spaces doesn’t work. Text in these languages is usually measured in characters: each Chinese character, kana and punctuation mark counts as one. When Chinese writers talk about a word count, they usually mean this kind of count, with a run of Latin letters or digits counted as one.

Here is a sentence that mixes Chinese with an English word and a number, with an ordinary space on each side of “iPhone” and “2000”. It says, roughly, “Wrote 2,000 characters on my iPhone this weekend. Very happy.”

> 周末用 iPhone 写了 2000 字，很开心。

It has 9 Chinese characters, 6 Latin letters, 4 digits, 2 full-width punctuation marks and 4 spaces. Splitting it at spaces gives 5 pieces, which says nothing about its length. Counted the usual ways:

| Count | Result |
|---|---|
| Characters with spaces | 25 |
| Characters without spaces | 21 |
| Chinese characters and punctuation, with “iPhone” and “2000” as one each | 13 |
| The same, without punctuation | 11 |

This is where a writing app’s word count settings matter.

## Word count settings in Pure Writer

Pure Writer is a plain text editor for writing. Pure Writer for Android and iOS has a “Word count” section in Settings with two options:

- “Count words individually”: when on, a run of Latin letters, digits and similar characters counts as one, while each Chinese character or full-width punctuation mark still counts as one; spaces and line breaks aren’t counted. It’s on by default when the app language is anything other than Chinese, Japanese, Korean or Thai, and off by default in those four.
- “Word count & punctuation” (on iOS, “Word Count Mode & Punctuation”): choose from three modes, “Exclude spaces and line breaks”, “Include all symbols and text”, and “Exclude all punctuation, spaces, and line breaks”. This option has no effect while “Count words individually” is on.

For the Chinese sentence above, Pure Writer counts 13 with “Count words individually” on, and 21 with it off and “Exclude spaces and line breaks” selected.

“Exclude all punctuation” works from a list of common punctuation marks, so a few symbols that aren’t on the list are still counted. Some characters, such as emoji, count as 2. Pure Writer Desktop has no setting for how words are counted. For details, see [About the word count options](/en/manual/#about-different-modes-of-word-count) in the user manual.

## FAQ {#faq}

### Are word count and character count the same?

No. A word count counts words; a character count counts every letter, digit and punctuation mark, and sometimes the spaces too. “The rain stopped, and she finally opened the letter.” has 9 words, 44 characters without spaces and 52 characters with spaces. In Chinese and Japanese, which don’t put spaces between words, what people call a word count is usually a character count.

### What does “character count with spaces” mean?

It’s the number of characters including the spaces between words. A character count without spaces leaves the spaces out, and the difference between the two is the number of spaces in the text. Whether line breaks are included varies between tools.

### Does punctuation count toward the word count or character count?

Punctuation attached to a word, like the period in “letter.”, doesn’t add a word to a word count, but in a character count, punctuation marks count just like letters. Some tools can leave punctuation out. In Pure Writer for Android and iOS, turn off “Count words individually” in the “Word count” section of Settings, then choose “Exclude all punctuation, spaces, and line breaks” under “Word count & punctuation” (on iOS, “Word Count Mode & Punctuation”).

### Why does an emoji count as two characters?

Many programs count characters in UTF-16 code units. Common letters, digits and punctuation marks take one code unit each, but many emoji take two, and emoji built from several characters, such as a country flag, can take four or more. Pure Writer also counts emoji and some other characters as 2.

### Why is Pure Writer’s count different from Microsoft Word’s?

Their counting rules aren’t identical. Word shows “Words”, “Characters (no spaces)” and “Characters (with spaces)” side by side, while Pure Writer counts according to the options in the “Word count” section of its settings. To compare, set Pure Writer to the closest equivalent: for Word’s “Words”, turn on “Count words individually”; for “Characters (no spaces)”, turn it off and choose “Exclude spaces and line breaks”. Even then, emoji and symbols that aren’t on Pure Writer’s punctuation list may be counted differently, so small differences are normal.
