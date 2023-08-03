---
title: "{{ replace .Name "-" " " | title }}"
date: {{ .Date }}
draft: false
tags: []
categories: ["{{ trim (replace .File.Dir "posts/" "") "/" }}"]
authors:
- "mewooew"
---

