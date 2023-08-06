---
title: "#Pagefind 为静态博客配置站内搜索工具"
date: 2023-08-06T20:18:13+08:00
lastmod: 2023-08-06T20:18:13+08:00
draft: false
tags: []
categories: ["pocket-book"]
authors:
- "mewooew"
---

### 序 方案选择

`hugo`官网文章[Search for your Hugo Website](https://gohugo.io/tools/search/)介绍了几种为静态网站添加全文检索功能的方法。其中比较有特色的搜索工具有基于倒挂索引(`inverted index`)的`lunr.js`和`Fuse.js`, 二者都是使用比较广泛的全文搜索工具, 后者还具有模糊查询的功能. 不过二者在搜索时需要浏览器把所有文章请求下来, 建立倒挂索引`index.json`, 再对索引进行搜索, 随着网站内容增加, `index.json`的体积会越来越大, 会导致网络请求延时, 若考虑生成`index.json`时只输出标题等关键字, 会导致搜索质量大幅下降. 因此将目光转向了[pagefind](https://pagefind.app/) 搜索工具. 

`Pagefind`是一个独立的命令行工具, `Pagefind`是一个独立的命令行工具, 其原理是：运行`Pagefind`命令, 扫描所有静态网页并生成索引; 用户搜索时, 通过网页中内嵌的`JavaScript`脚本来访问预先生成的索引，从而实现静态全文检索。[^白汤四物] 也就是说, 网站内容的索引实在生成网站之前就已经完成了, 无需浏览器进行生成, 减少了后期网络请求延时的顾虑. 而且在使用了`GitHub Action`的前提下, `Pagefind`生成索引的步骤也可以集成到博客部署的工作流中, 不必每次生成网站都要运行一遍`Pagefind`.

[^白汤四物]:[白汤四物: 为 Hugo 静态网站添加全文检索功能](https://www.fournoas.com/posts/adding-full-text-search-to-a-hugo-static-website/)

[pagefind](https://pagefind.app/) 是通过分词的方式来进行搜索的, 所以搜索功能只会在命中分词的时候生效. 比如现在有一个词 碳酸危机, 搜索`碳酸` \ `危机`或者`碳酸 危机`都可以搜到对应的内容, 但是直接搜索`碳酸危机`会得不到任何搜索结果, 这就是分词导致的.

这种分词的优势是可以大大减少索引文件的大小, `hugo`默认生成的索引文件包含了每篇文章的全文, 随着文章的增多生成的索引文件会膨胀的比较快, 而`pagefind`这种通过分词生成索引文件的方式, 只会在有新的分词的时候或者新的文章的时候(因为需要记录分词对应的文章的一些信息, 比如链接)索引文件的大小才会有些微增加, 生成的索引文件膨胀的就会慢很多.[^点半九]

[^点半九]:[点半九: 给我的blog加上搜索功能](https://www.dianbanjiu.com/post/%E7%BB%99%E6%88%91%E7%9A%84blog%E5%8A%A0%E4%B8%8A%E6%90%9C%E7%B4%A2%E5%8A%9F%E8%83%BD/)

在`hugo`中调用`Pagefind`的方式通常为在自定义`html`页面模板或者自定义引入`shortcode`,再在搜索页面`markdown`文档引入相关代码,这里图省事参考了同一主题`hugo-theme-den`的使用者[pseudoyu](https://www.pseudoyu.com/zh/search/)作者的代码,使用shortcode的方式, 同时还结合了[白汤四物](https://www.fournoas.com/posts/adding-full-text-search-to-a-hugo-static-website/) \ [点半九](https://www.dianbanjiu.com/post/%E7%BB%99%E6%88%91%E7%9A%84blog%E5%8A%A0%E4%B8%8A%E6%90%9C%E7%B4%A2%E5%8A%9F%E8%83%BD/)等作者的教程了解了实现站内检索功能是如何实现的. 

### 安装Pagefind并生成静态索引

首先通过手动发布实现`Pagefind`搜索功能, 以便于在本地进行`debug`, 之后再考虑整合进`GitHub Action`工作流.

* 安装并发布

  在博客根目录`blog-yoli/`下通过命令行工具`npm`安装`Pagefind`工具并发布`hugo`站点(站点静态文件默认是发布到`blog-yoli/public`文件夹下):

  ```shell
  npm i pagefind
  hugo
  ```

* 生成索引

  扫描`public`文件夹, 生成`Pagefind`索引, 并放到`blog-yoli/public/search`目录下(不必自己新建, 指定`--bundle`参数后, 没有这个目录的话`Pagefind`会自己生成)

  ```shell
  npx pagefind --source public --bundle-dir search
  ```

  也可以通过配置文件实现相同的操作:

  ```yaml
  # Pagefind 会自动在当前目录下查找pagefind.yml配置文件，
  # 使用参数或配置文件的效果是等价的
  # 在根目录blog-yoli下新建pagefind.yml配置文件,添加保存以下规则:
  source: public
  bundle_dir: search
  ```

  这样之后每次只需要直接运行, 就能更新索引文件, 并放到配置文件中的指定目录下:

  ```shell
  npx pagefind
  ```

  >`Pagefind`默认存放静态文件的文件夹名为`_pagefind`, 每次生成静态索引文件后, `Pagefind`会将索引文件放入`blog-yoli/public/_pagefind/`目录下, 但为了避免之后将网站部署到`GitHub Pages`上时, `GitHub`可能会忽略\_开头的文件, 所以最好自己指定一个文件夹名, 比如这里的`search`, 之后静态索引文件将存放在`blog-yoli/public/search/`目录下.

### 在静态网页中添加搜索入口

* 创建`html`格式的`shortcodes`文件

  在`/blog-yoli/layouts/shortcodes/`目录下新建`search.html`模板文件,输入保存以下代码:

  ```html
  <link href="/search/pagefind-ui.css" rel="stylesheet">
  <script src="/search/pagefind-ui.js" type="text/javascript"></script>
  
  <div id="search"></div>
  <script>
      window.addEventListener('DOMContentLoaded', (event) => {
          new PagefindUI({ element: "#search" });
      });
  </script>
  ```

  其中链接目录的文件夹要与之前设置的索引静态文件存放的文件夹名相一致,比如此处为`search`

* 创建搜索页面

  在`/content/zh/`(弄完后可以`en`目录下原样copy过去)目录下新建文档`search.md`文档作为显示在网站上的搜索页面:

  ```shell
  hugo new search.md
  ```

  并在`search.md`文档中正文处添加以下内容作为展示在搜索页面上的搜索框(因为直接展示代码会被hugo以为要执行而不显示, 所以这里展示的是需要输入的代码片段的图片):

  ![image-20230806220255292](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/hugo-pagefind-search-md.png)

  文件头的参数设置中(没有的及自己添加)要注明要在主菜单`main`中添加页面入口, 以及权重`weight`(决定页面入口在菜单栏的位置先后, 这样就无需在网站配置文件`config.toml`中另行编辑菜单设置规则了), 并且不要编入rss订阅内容`rss_ignore`:

  ```markdown
  ---
  title: "搜索"
  date: "不要改, hugo会自己生成"
  menu: "main"
  weight: 110 (视具体情况修改)
  rss_ignore: true
  ---
  ```

* 效果预览

  引入`Pagefind`短代码的静态网页在本地服务器进行预览`hugo server -D`时是不显示的, 要看效果的话需要在正式推送到服务端之后才能看到.

### 整合入GitHub Action工作流

* 添加`Pagefind`生成索引步骤

  编辑 `/blog-yoli/.github/workflows/hugo.yml` 文件, 在 `steps` 小节中的 `Build` 和 `Deploy` 操作之间添加如下内容:

  ```yaml
  - name: Install nodejs
      uses: actions/setup-node@v3
      with:
        node-version: 18
    - run: npm i pagefind
    - run: npx pagefind --source public --bundle-dir search
  ```

* 尝试运行并查看效果:

  ```shell
  git add .
  git commit -m "add search function"
  git push -u origin master
  ```

  等待几分钟后部署成功后,在浏览器通过域名访问 https://www.yolichan.fun/zh/search/就能看到搜索页面啦:

  ![image-20230806213742990](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/hugo-pagefind-result-page.png)

### 后记

写不动了...三月的时候好像就是因为本地调试的时候总是看不到搜索框, 以为卡bug了, 一直没有走出来, 连`fuse.js`也去尝试使用了一下, 无果😢😢😢. 这次一边配置, 还喜欢顺手玩一下`GitHub Action`的一键发布功能, 一次顺手部署完之后, 无意中发现能在网页端看到搜索框了,才恍然大雾(对, 大雾, 因为依然不清楚这是个什么原理)苦涩, 但是开心, 解决了小站一大bug, 呜呜呜.
