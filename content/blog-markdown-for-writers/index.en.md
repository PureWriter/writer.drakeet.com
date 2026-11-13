---
title: "Markdown for writers: what it is, and how it compares to plain text and Word - Pure Writer"
description: "Markdown is a way to mark headings, emphasis and lists in plain text with a few ordinary symbols. How it compares to plain text and rich text in Word, the syntax a writer actually needs, and the line break and list rules that trip people up."
date: 2026-11-13
lastmod: 2026-11-13
url: blog/markdown-for-writers/
jsonld: article
---

<!--
  博客文章：写文章够用的 Markdown（英文版）。简体主稿是同目录的 index.zh-hans.md，这里为英文读者重写。
  定位：回答「markdown vs plain text」「rich text vs markdown」「why use markdown instead of word」
  「what is markdown formatting」「markdown for writers」。
  与简体主稿的差别：
  - 英文读者多半在比较 Markdown 与纯文本、富文本、Word，所以把三者的对照表放在最前面，「为什么不用 Word」
    紧随其后；常见问题也换成这类问法（Is Markdown the same as plain text? 等）。
  - 删去中文特有的两条：星号紧挨全角引号时不生效（英文的引号前后通常有空格，不受影响）、段首用全角空格缩进
    （改为只说行首四个空格会变成代码块）。
  - 加了英文写作者会遇到的一条：行首「1986. 」这样的年份加句点会变成有序列表，要写成 1986\.（用 Hugo（goldmark）渲染核对过）。
  - 删去单个波浪号的陷阱：英文用 ~ 表示「大约」时前面有空格，不会配对成删除线（核对过），数字之间用 ~ 表示范围在英文里少见，
    为控制篇幅不写；相应地，纯纯写作「单个波浪号不产生删除线」一条也不写。
  - 其余（是什么、写法对照表、段落与换行、列表的空行与缩进、反斜杠、# 后的空格、--- 的陷阱）与主稿对应。
  通用知识的依据与主稿相同（CommonMark 与 GFM 规范，「2004 年由 John Gruber 提出」）。
  纯纯写作的事实与主稿相同，界面名称照英文使用手册（content/manual/index.en.md）：
  「What is Markdown?」（the TXT icon、the small M↓ button next to ⊕、“Switch to Markdown”、
  “Preview & Save as PDF, Long Image, DOCX, EPUB…”、the button that shows “Plain text” in the status bar）、
  「Note」第 4、7 条（“Treat Single Newlines as Line Breaks”、“Settings › Markdown Options”、Fine-tuning 里的
  “GFM line breaks / Soft break adds new line”）、「About the Markdown panel」、「Can Pure Writer render Markdown as I type?」、
  「Strikethrough and underline」、「Why don’t highlighting and some other syntax work?」、「Why can’t I center text with the <center> tag?」、
  「Why are documents exported as .md files?」、「Can I export to .docx, .epub, or other formats?」（Android 的
  “Preview & export…” 与 Pure Writer Pro）、「Can I write Markdown in Pure Writer Desktop?」、「Can I make text bold or insert images?」。
  《Markdown 简明教程》只有简体中文，这里不链接，改链英文手册的「Pure Writer Markdown User Guide」。
  维护：手册改了上述说法或界面名称，这里跟着改。示例都放在行内代码或代码块里；改动示例后要重新构建，
  核对页面上显示的是源码，尤其注意正文里不要出现成对的半角波浪号（会被渲染成删除线）。
-->

# Markdown for writers: what it is, and how it compares to plain text and Word

Markdown is a way of marking formatting in plain text with a few ordinary symbols: a line that starts with `# ` is a heading, and words wrapped in two asterisks are bold. The file stays plain text, so any text editor can open it; the formatting appears when an app that supports Markdown previews or exports it. A writer needs only a dozen or so marks, plus a few rules that explain most surprises.

## Markdown vs. plain text vs. rich text

| | Plain text | Markdown | Rich text (such as a Word document) |
|---|---|---|---|
| What the file holds | Only characters | Only characters, including marks like `#` and `**` | Text plus hidden formatting data |
| Headings, bold, lists | None | Written as visible symbols | Set with buttons or menus |
| Opens in | Any text editor | Any text editor; formatted in apps that support Markdown | Apps that support the format |
| Who decides the look | The app showing it | The app previewing or exporting it | The document itself |

A Markdown file stays readable even in an app that knows nothing about Markdown:

```markdown
## Chapter 3: The Storm

She put the letter back in the drawer and **didn’t look back**.
```

In a Markdown preview, the first line becomes a chapter heading and “didn’t look back” is bold.

John Gruber created Markdown in 2004. The CommonMark spec later pinned down the details, and GitHub Flavored Markdown (GFM) added tables, strikethrough and task lists. Many apps follow these two, though details differ between apps.

## Why writers use Markdown instead of Word

- **Your hands stay on the keyboard.** Headings, bold and lists are typed, not clicked.
- **There’s no hidden formatting.** What you see is everything in the file: no stray fonts or styles to clean up.
- **Your writing isn’t tied to one app.** A Markdown file, usually ending in .md, opens in any editor on any computer.
- **One draft, many formats.** The same file can be exported as a web page, PDF, Word document or ebook.

Markdown describes structure (this is a heading), not appearance (which font, what size). So it’s a poor fit when you need exact control over fonts, margins and page breaks, as in a résumé with a strict layout, or for complex mixes of text and images. Use a word processor for those.

## The Markdown syntax you actually need

| Format | What you type | What you get |
|---|---|---|
| Heading | `# Chapter One` | A level 1 heading; `##` is level 2, down to six levels |
| Bold | `**didn’t look back**` | **didn’t look back** |
| Italic | `*The Great Gatsby*` | *The Great Gatsby* |
| Strikethrough (extension) | `~~cut this line~~` | ~~cut this line~~ |
| Bulleted list | `- Character notes` | A bulleted item |
| Numbered list | `1. Opening` | A numbered item |
| Quote | `> A quoted passage` | A block quote, set off from the text |
| Horizontal rule | `***` or `---` on a line of its own | A line across the page, handy as a scene break |
| Link | `[Pure Writer](https://writer.drakeet.com)` | The clickable text “Pure Writer” |
| Image | `![Cover sketch](cover.jpg)` | The image; the bracketed text describes it |
| Inline code | `` `Ctrl+S` `` | `Ctrl+S`, shown as is in a monospaced font |
| Code block | A line of `` ``` `` above and below | Everything in between, shown as is |
| Table (extension) | See below | A table |
| Task list (extension) | `- [ ] Finish chapter 3` | An unchecked box; `[x]` is checked |

The three marked “extension” come from GFM, not the original Markdown, but many apps support them. Underscores also work for bold and italic (`__bold__`, `_italic_`), but not in the middle of a word, as in `un_believ_able`, so asterisks are the safer habit.

In a table, vertical bars separate the columns, and a row of hyphens separates the header. Colons set the alignment: `:---` left, `:---:` center, `---:` right. The bars needn’t line up; for a bar inside a cell, write `\|`.

```markdown
| Character | Role | First appears |
| :--- | :--- | ---: |
| Nora | Reporter | Chapter 1 |
| Eli | Teacher | Chapter 3 |
```

## Where people get stuck

### Line breaks and paragraphs

```markdown
The last sentence of one paragraph.
The first sentence of the next.
```

Under CommonMark, these two lines are one paragraph and display as a single line. Leave a blank line to start a new paragraph. To break a line inside a paragraph, as in a poem, end it with two spaces or a backslash `\` (which, unlike spaces, you can see). Some apps show every line break as is by default.

A paragraph that starts with four or more spaces becomes a code block, so don’t indent paragraphs with spaces.

### Lists need blank lines and the right indent

Without a blank line after a list, the next line joins the last item. Here it becomes part of “Train ticket”:

```markdown
- Umbrella
- Train ticket
At the station I realized I’d left my wallet at home.
```

Leave a blank line before a list too: under CommonMark, a numbered list starting with any number but 1 isn’t recognized right after a line of text. The same goes for quotes: a blank line ends one.

To nest a list, indent sub-items to where the text above starts: two spaces under `- `, three under `1. `. With only two spaces under `1. `, the sub-items start a new list instead.

```markdown
1. Chapter one
   - The storm
   - The letter
2. Chapter two
```

### Symbols that turn into formatting

Put a backslash before a mark to show it as is: `\*` shows an asterisk, and `\#` a hash sign. This catches writers out at the start of a line: a number followed by a period starts a numbered list, so `1986. A strange year.` turns into item number 1986. Write `1986\.` to keep it as text.

### A space after #, and the --- trap

`#Chapter` is plain text; `# Chapter` is a heading. And if you use `---` as a scene break, leave a blank line above it, or the line of text above becomes a level 2 heading. Using `***` avoids the problem.

## Using Markdown in Pure Writer

Pure Writer is a plain text editor for writing. It doesn’t support rich text; for headings or bold, you switch a document to Markdown. Each document is switched on its own:

- **Android**: Tap the `TXT` icon on the right of the top bar; it changes to `M↓`. Tap the small `M↓` button next to ⊕ in the bottom-right corner to switch between editing and preview.
- **iOS**: Tap the button in the top-right corner of the editor (it normally shows the document’s format) and choose “Switch to Markdown”. Headings, emphasis and the like are colored as you edit, with the marks still visible; to see the formatted result, use “Preview & Save as PDF, Long Image, DOCX, EPUB…”.
- **Desktop**: Click the button that shows “Plain text” in the status bar and choose “Markdown”. Pure Writer Desktop doesn’t render Markdown for now, so there’s no preview; once the document syncs to your phone, you can preview it there.

None of the three hides the marks as you type. On Android and iOS, the `M↓` button at the left end of the shortcut bar opens the Markdown panel for inserting headings, lists, tables and more; the desktop version has no panel.

Some details differ from the general rules above:

- It’s based on CommonMark, plus tables, task lists, strikethrough, LaTeX formulas and a few HTML tags. `==highlighted text==`, footnotes and the `<center>` tag aren’t supported; to center text, use `<p align="center">…</p>`.
- A single line break shows as a line break by default. The setting is “Treat Single Newlines as Line Breaks” in “Settings › Markdown Options” on iOS, and “GFM line breaks / Soft break adds new line” in Fine-tuning on Android.
- Markdown documents export as .md files; for .txt, switch to plain text first, which keeps the marks. Android and iOS can also save as PDF, DOCX or EPUB from the preview page (on Android, with Pure Writer Pro).

For every mark and how it behaves in Pure Writer, see the [Pure Writer Markdown User Guide](/en/manual/#pure-writer-markdown-user-guide).

## FAQ {#faq}

### Is Markdown the same as plain text?

A Markdown file is a plain text file that any text editor can open. Markdown adds a convention: symbols such as `#` for headings and `**` for bold, which apps that support Markdown display as formatting.

### Why use Markdown instead of Word?

A Word document is rich text: its formatting is stored inside the file, and it needs an app that supports the format. Markdown keeps formatting as visible symbols in plain text, so the file opens anywhere and carries no hidden styles. Word is better when you need exact control over page layout.

### How do I make a line break in Markdown?

Leave a blank line between paragraphs. Within a paragraph, end the line with two spaces or a backslash `\`; under CommonMark, pressing Enter once just joins the lines. Some apps, including Pure Writer by default, show a single line break as a line break.

### Can I write Markdown on my phone?

Yes. Markdown is plain text, so any app you can type in will do, though not every app can preview it. Pure Writer for Android and iOS can switch a document to Markdown, insert marks from the Markdown panel and preview the result.
