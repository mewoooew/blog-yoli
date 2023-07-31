---
title: "搜索"
date: 2023-07-31T13:57:23+08:00
menu: "main"
weight: 110
rss_ignore: true
---

## 站内检索

请直接在下方的输入框中输入你想要搜索的内容


{{< search >}}

<br />


***
> `pagefind `[^pagefind] 是通过分词的方式来进行搜索的，所以搜索功能只会在命中分词的时候生效，比如现在有一个词 碳酸危机，搜索 `碳酸`、`危机`或者`碳酸 危机` 都可以搜到对应的内容，但是直接搜索 `碳酸危机` 会得不到任何搜索结果，这就是分词导致的

[^pagefind]: [pagefand 官方文档](https://pagefind.app/)

>这种分词的优势是可以大大减少索引文件的大小，hugo 默认生成的索引文件包含了每篇文章的全文，随着文章的增多生成的索引文件会膨胀的比较快，而 pagefind 这种通过分词生成索引文件的方式，只会在有新的分词的时候或者新的文章的时候（因为需要记录分词对应的文章的一些信息，比如链接）索引文件的大小才会有些微增加，生成的索引文件膨胀的就会慢很多.[^点半九]

[^点半九]: [点半九 给我的blog加上搜索功能](https://www.dianbanjiu.com/post/%E7%BB%99%E6%88%91%E7%9A%84blog%E5%8A%A0%E4%B8%8A%E6%90%9C%E7%B4%A2%E5%8A%9F%E8%83%BD/)

> Pagefind 是一个独立的命令行工具，可以通过 npm install pagefind 来安装。其原理是：运行 Pagefind 命令，扫描所有静态网页并生成索引；用户搜索时，通过网页中内嵌的 JavaScript 脚本来访问预先生成的索引，从而实现静态全文检索。[^白汤四物]

[^白汤四物]: [白汤四物 为 Hugo 静态网站添加全文检索功能](https://www.fournoas.com/posts/adding-full-text-search-to-a-hugo-static-website/)
