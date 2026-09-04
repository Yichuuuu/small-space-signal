# Small Space Signal

Small Space Signal is an independent guide site for renters and compact homes.
It is built with Jekyll and the [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes)
remote theme, then customized with a restrained editorial skin.

## Public site

https://yichuuuu.github.io/small-space-signal/

## Theme configuration

- Remote theme: `mmistakes/minimal-mistakes@4.28.0`
- Site configuration: `_config.yml`
- Navigation: `_data/navigation.yml`
- Editorial styles: `_sass/small-space-signal.scss`
- Theme entry stylesheet: `assets/css/main.scss`
- Guides collection: `_guides/`
- Standalone pages: `_pages/`

The theme version is pinned so that upstream releases cannot unexpectedly
change the public site. Minimal Mistakes is used under its MIT license.

## Local preview

Ruby and Bundler are required for a local Jekyll preview.

```powershell
bundle install
bundle exec jekyll serve --livereload
```

Open `http://127.0.0.1:4000/small-space-signal/`.

GitHub Pages can build the remote theme without Ruby being installed on the
editor's computer. The repository must publish from the `master` branch and
repository root for the current setup.

## Add a guide

Create a Markdown file in `_guides/`. Keep an explicit permalink so links stay
stable when titles or filenames change.

```yaml
---
title: "A clear, useful guide title"
description: "A concise search description."
excerpt: "One sentence shown on the home page."
date: 2026-09-04
last_modified_at: 2026-09-04
author: "Yichu"
permalink: /articles/example-guide.html
category: "Storage"
categories:
  - "Storage"
tags:
  - "small apartment"
  - "home organization"
layout: single
author_profile: false
read_time: true
show_date: true
share: true
toc: true
toc_sticky: true
---
```

## Affiliate content

The required disclosure page is `_pages/affiliate-disclosure.md`. Any guide
that gains affiliate links should also place a clear disclosure near those
links. Do not present unverified specifications, prices, ownership, or hands-on
testing as fact.
