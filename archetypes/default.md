---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
lastmod: {{ .Date }}
draft: false
tags: []
categories: ["{{ trim (replace .File.Dir "posts/" "") "/" }}"]
authors:
- "koi"
---

