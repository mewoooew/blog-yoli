---
title: "#hugo #GitHub-Pages #GitHub-action 博客搭建笔记  "
date: 2023-07-25T20:05:37+08:00
draft: false
tags: ["Programming","hugo","github"]
categories: ["ideas","pocket-book","album"]
authors:
- "koi"
---

### 序 建站之初

[hugo](https://gohugo.io/)使用`go`语言进行编译生成静态博客文件系统, 将文件系统发布到服务器上, 即可通过访问服务器来访问生成的静态博客网站, 这里服务器可以自己购买, 也可以直接部署在[GitHub](https://github.com/)提供的免费服务器上, 即[GitHub pages](https://pages.github.com/)的方式. `hugo`生成网站时拥有极快的渲染速度, 而且无需在服务器上搭建数据库, 免去了数据库系统学习和管理的烦恼(为了搭建网站提前选修了一个学期数据库系统原理的本人知道真相后😢), 由于之前搭建云主机使吃了不少苦, 这里果断选择了部署到`GitHub pages`上的方案, 无需自己维护服务, 更稳定安全, 因为建站初衷是为了开一个记录的树洞bot, 作为友人🍧的生日礼物, 所以搭配一个具有特殊意义的域名是必不可少哒. 总的来说, 一个完整的静态博客demo至少需要以下三部分的准备:

* 静态网站生成器 - `hugo`
* 存放页面的仓库 - 通过`GitHub pages`的方式托管在`GitHub`家的免费服务器上
* 域名 - `GitHub pages`的方式自带一个域名但这里选择绑定自定义域名嗷

接下来便一一展开这个demo如何实现哒~

### 使用`hugo`安装\配置\生成静态网站

* 安装`hugo`

  在`archlinux`系统上安装`hugo`并验证`hugo`版本 (其他系统均有相应的安装指令 不熟就不科普啦😅)

  ```shel
  sudo pacman -S hugo
  hugo version
  ```

  使用`hugo`创建一个博客项目, 且命名为`blog-yoli`, 记得先cd到想要存放这个博客项目的目录位置.

  ```she
  cd ~/echoo
  hugo new site blog-yoli
  ```

* 配置博客主题

  查找`hugo`配置教程留意了很多风格, 最后选择了博主[pseudoyu](https://www.pseudoyu.com/zh/about/)使用的[hugo-theme-den](https://github.com/shaform/hugo-theme-den)主题, 有mood且简单, 专注于内容创作.

  ![image-20230802152737164](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/yu-blog%E5%B0%81%E9%9D%A2%E6%88%AA%E5%9B%BE.png)

   `pseudoyu`前辈写的[搭建教程](https://www.pseudoyu.com/en/2022/05/29/deploy_your_blog_using_hugo_and_github_action/#top)[^pseudoyu]也很详尽, 多亏了他的教程`yolichan的树洞bot`才能从零到有, 也通过github借鉴了很多部署方案, 最最主要的是, 前辈在搭建博客时使用的方案应该都是比对挑选过的, 很稳定. 

  参考教程, 将原主题仓库fork到自己的`GitHub`账户后,在本地使用`git submodule`进行链接到fork后形成的远程仓库.

  我们可以将`GitHub`上的主题仓库直接 `git clone` 下来进行使用，但这种方式有一些弊端，当之后自己对主题进行修改后，可能会与原主题产生一些冲突，不方便版本管理与后续更新.  [^pseudoyu]                           

  [^pseudoyu]:[pseudoyu: Hugo + GitHub Action，搭建你的博客自动发布系统](https://www.pseudoyu.com/en/2022/05/29/deploy_your_blog_using_hugo_and_github_action/#top)

  ```shell
  cd blog-yoli
  git init
  git submodule add https://github.com/mewoooew/hugo-theme-den.git themes/hugo-theme-den`
  ```

* 更新主题

  初始化

  ```shell
  # 如果是直接clone的他人的博客项目
  git submodule update --init --recursive
  ```

  同步本地修改到仓库

  ```she
  git submodule update --remote
  ```

* 主题配置及发布

  链接到仓库后并添加主题文件夹后, 还需要将主题文件夹示例站点`blog-yoli/themes/hugo-theme-den/exampleSite/`中的文件复制到博客根目录下才能生效:

  ```shell
  `cp -rf themes/hugo-theme-den/exampleSite/* ./``
  ```

  由于一些原主题代码不能直接使用, 后面`hugo --server`调试时会有报错, 多次尝试后发现最简单粗暴的方式是删除`content/en/posts/*`下的文章, 因为这些代码主要是由这些文章页面进行引用的😵‍💫.

  ```shell
  cp -rf themes/hugo-theme-den/exampleSite/* ./
  ```

  如果要启用多语言并且开箱使用原主题的一些模板, 还可以将主题文件夹`themes`下的`i8n` `layouts` `static`文件夹直接复制到博客根目录下, 例如:

  ```shell
  cp -rf /themes/hugo/hugo-theme-den/i18n ./
  ```

  后面可以慢慢调整\修改\使用自己定制的一些方案.

* 站点细节配置

  关于站点名称\目录分配\默认语言等站点细节都可以在配置文件`config.toml`中进行配置, 关于网站的样式设计细节存放在`blog-yoli/static/css/den.css`文件中, 不同主题的配置参数不太一样嗷, 多踩几次坑熟悉了就好 😢.

* 发布新文章

  ```she
  hugo new posts/blog-test.md
  ```

  生成文章默认模板 `echoo/blog-yoli/archetypes/default.md`
  如果配置文件设置了默认语言(例如中文zh)的话,指令应该是``hugo new zh/posts/blog-test.md`` 不然文章会不显示. 除了`关于页`\ `搜索页`\ `友链页`等,平时的blog文章应该都放在``blog-yoli/content/zh/posts``文件夹下.

* `hugo`还有一大优点就是可以本地调试预览

  ```shell
  hugo server -D
  # -D 参数表示渲染时显示处于草稿draft状态的文章页面
  ```

  运行后通过在浏览器访问 http://localhost:1313 即可预览网站搭建效果, 之后可以一边修改网站配置一边查看实时效果, 有点所见即所得的意思啦. 

### 部署GitHub Pages

* 首先准备好一个自家的域名(可以没有)

  下面都以`yolichan.fun`为例.

* 创立符合 `username.github.io` 命名形式的仓库

  建议勾选public(公有, 免费), 但不要勾选添加 ``README.md``文件, 不然之后本地同步远程仓库会比较麻烦, 多一道``git pull``的工序下面都以 [mewoooew.github.io](https://github.com/mewoooew/mewoooew.github.io) 为例.

  `GitHub Pages` 项目需要符合 `username.github.io` 的特殊命名格式，仓库建立完成后，可以在设置中配置自己注册的自定义域名来指向 `GitHub Pages` 生成的网址。[^pseudoyu] 

  ![image-20230802153708295](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/%E5%88%9B%E7%AB%8B%E7%AC%A6%E5%90%88username-github-io%E5%91%BD%E5%90%8D%E5%BD%A2%E5%BC%8F%E7%9A%84%E4%BB%93%E5%BA%93.png)

* 将`GitHub Pages`设置中的`custom domian`和博客配置文件`config.toml`中的`baseURL`都改为自定义域名 https://www.yolichan.fun/

  <img src="https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/%E5%88%9B%E7%AB%8B%E8%87%AA%E5%91%BD%E5%90%8D%E4%BB%93%E5%BA%93.png" alt="image-20230802110625986"/>

* 域名解析

  配置完`GitHub Pages`后还需要通过`DNS解析`将域名指向`GitHub Pages`提供的个人主页域名, 这样才能让访者在浏览器访问自定义域名被导向`GitHub Pages`个人主页.

  在需要在域名托管商进行`DNS解析`,选择`CNAME`,指向 `GitHub Pages` 网址, 这里选择的域名托管商[cloudflare](https://www.cloudflare.com/zh-cn/), 这样可以顺便使用上他家CDN加速服务.

  <img src="https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/cloudflare%E5%AF%B9%E5%8D%9A%E5%AE%A2%E7%AB%99%E7%82%B9%E8%BF%9B%E8%A1%8CDNS%E8%A7%A3%E6%9E%90%E8%AE%BE%E7%BD%AE.png" alt="image-20230802112647640"/>

  `CNAME` 解析没法设置 root 域名(无任何前缀的yolichan.fun), 只能设置 `www.yolichan.fun` 或其他子域名, 而子域名容易被`SEO优化`掉: 一些搜索引擎如alex或一些搜索查询工具网站等等默认是自动去掉`www.`来辨别网站的; 据说使用子域名的网站权重也相对更低. 对此, 参考`pseudoyu`的教程, 通过 `Cloudflare` 上自定义规则设置域名重定向, 如此访问`https://yolichan.fun`时就会被重定向到`https://www.yolichan.fun`

  <img src="https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/Cloudflare%20%E4%B8%8A%E8%87%AA%E5%AE%9A%E4%B9%89%E8%A7%84%E5%88%99%E8%AE%BE%E7%BD%AE%E5%9F%9F%E5%90%8D%E9%87%8D%E5%AE%9A%E5%90%91.png" alt="image-20230802112922144"/>

### 在GitHub Pages上发布博客

要`GitHub Pages`显示博客网页, 还需要将`hugo`生成的的静态网页资源发布到之前创建的`mewoooew.github.io`仓库. 可以手动发布或者通过配置`GitHub Action`自动发布, 手动发布流程简单好上手, `GitHub Action`自动发布可以实现网站每日自动更新, 持续集成/交付(`CI/CD`), 这里选择`GitHub Action`的方式, 如果想使用自动发布的方式的化继续推荐`pseudoyu`的教程. 至于`GitHub Action`的实现方式则同时参考了`pseudoyu`的`教程`和[reuixiy(一休儿)](https://io-oi.me/about/)的[教程](https://io-oi.me/tech/deploy-hugo-to-github-pages-via-github-actions/).[^reuixiy]

[^reuixiy]: [reuixiy: 使用 GitHub Actions 部署 Hugo 博客到 GitHub Pages](https://io-oi.me/tech/deploy-hugo-to-github-pages-via-github-actions/)

* 另创建一个`GitHub`远程仓库`blog-yoli`用于存放博客源文件(即整个`blog-yoli/`下的站点文件系统), 创建的时候同样不建议勾选`创建README.md`.

* 初始化博客源文件本地仓库

  ```shell
  # !~/blog-yoli/
  # 将博客根目录初始化为git本地仓库
  git init
  # 将博客根目录下的文件(. 表示所有内容)提交到git本地仓库
  git add .
  # 提交说明, 编辑说明文字有利于建立追踪, 防失忆很好用
  git commit -m "new"
  ```

* 将本地仓库同步到远程仓库

  ```shell
  # 将本地仓库源与GitHub网站上托管的远程仓库进行链接
  # 只有初始化的时候需要链接, 之后都可以直接进行推送
  git remote add origin git@github.com:mewoooew/blog-yoli.git
  # 如果之前没有在本地配置过GitHub账户的话还要根据提示配置一下账户信息
  # 生成SSH密钥对(配好钥匙再开门), 存储到GitHub网站上, 才能链接成功
  # 将本地仓库内容推送到远程仓库, -u表示强制推送
  git push -u origin master
  ```

* 建立`GitHub Action`工作流

  在博客根目录下新建配置文件`blog-yoli/.github/workflows/build.yml`用以指示`GitHub Action`工作流程:

  ```yaml
  name: GitHub Pages
  
  on:	#表示 GitHub Action 触发条件
    push:
    pull_request:
  
  jobs: #GitHub Action 中的任务
    deploy:
      runs-on: ubuntu-latest # GitHub Action 运行环境
      concurrency:
        group: ${{ github.workflow }}-${{ github.ref }}
      steps:
        - name: Checkout    	#检出最新代码到 GitHub Actions 的虚拟环境中
          uses: actions/checkout@v3 #GitHub Action 中的插件
          with:
            submodules: true  # Fetch Hugo themes (true OR recursive)
            # `submodules` 值为 `true` 
            # 可以同步博客源仓库的子模块，即我们的主题模块。
            fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod
  
        - name: Setup Hugo
          uses: peaceiris/actions-hugo@v2 #GitHub Action 中的插件
          with:
            hugo-version: 'latest'
            extended: true
  
        - name: Build
          run: hugo --minify
  
        - name: Deploy
          uses: peaceiris/actions-gh-pages@v3 #GitHub Action 中的插件
          with:
            #  Note that the GITHUB_TOKEN is NOT a personal access token. A GitHub Actions runner automatically creates a
            #  GITHUB_TOKEN secret to authenticate in your workflow. So, you can start to deploy immediately without any
            #  configuration.
            #  personal_token参数值不要修改，github action 会自动引用
            personal_token: ${{ secrets.PERSONAL_TOKEN }}
            external_repository: mewoooew/mewoooew.github.io
            publish_branch: master
            publish_dir: ./public
            commit_message: ${{github.event.head_commit.message }}
  ```

  其中`EXTERNAL_REPOSITORY` 改为自己的 `GitHub Pages` 仓库.
  至于`PERSONAL_TOKEN`要想成功引用,需要先创建一个要在 `GitHub` 账户下 `Setting - Developer setting - Personal access tokens` 下创建一个 `Token`:

  ![image-20230802121550747](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/GitHub%E4%B8%AD%E5%88%9B%E5%BB%BAtoken.png)

  创建时开启`repo`与`workflow`权限

  ![image-20230802121645661](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/token%E5%BC%80%E5%90%AF%C2%A0repo%C2%A0%E4%B8%8E%C2%A0workflow%E6%9D%83%E9%99%90.png)

  复制生成的 `Token`（注：只会出现一次）, 然后在博客源仓库的 `Settings - Secrets - Actions` 中添加 `PERSONAL_TOKEN` 环境变量为刚才的 `Token`, 这样 `GitHub Action` 就可以引用 生成的`Token`了.

  完成上述配置后, 推送代码至仓库, 即可触发 `GitHub Action`, 自动生成博客页面并推送至 `GitHub Pages` 仓库.原本空白的`mewoooew/mewoooew.github.io`仓库会出现发布内容.

  ```shell
  # !~blog-yoli/
  git add .
  git commit -m "test"
  git push -u origin master
  ```

  在`GitHub`仓库控制台`Actions`处可以查看部署日志以便于debug

  ![image-20230802175333915](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/GitHub%20Actions%E6%8E%A7%E5%88%B6%E5%8F%B0.png)

* 绑定自定义域名

  在``blog-yoli/static/``目录下新建无后缀的文件``CNAME``, 并在文件中输入自定义域名.

  ![image-20230802122014890](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/%E6%96%B0%E5%BB%BA%E6%97%A0%E5%90%8E%E7%BC%80%E7%9A%84%E6%96%87%E4%BB%B6CNAME%E6%96%87%E4%BB%B6.png)

* 一键发布文章\推送至`GitHub`远程仓库

  创建`shell`脚本`yoli.sh`

  ```shell
  #!/bin/bash
  # 使用方法:
  # bash yoli.sh "提交说明的内容"
  
  # \033[0;32 "..." \033[0m 表示绿色打印中间字符串变量
  # 在命令行输出绿色提示"Deploying updates to GitHub..."
  echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"
  
  # 将中文目录下的文章复制到英文目录下
  cp -rf ./content/zh/posts/* ./content/en/posts/
  
  # 清除缓存
  git rm -rf --cached $(git ls-files)
  # 提交内容
  git add .
  # 提交说明
  # $#表示提供的参数个数
  # $1表示提供的第一个参数
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg"
  
  # 推送到远程仓库
  git push -u origin master
  ```

  这样子, 博客文章发布或者站点配置更新流程就变成了:

  ```shell
  # ~/blog-yoli/
  # hugo新建markdown格式的文档:
  hugo new /zh/posts/postname.md
  # 打开markdown编辑器编辑postname.md文档内容并保存
  # 需要学习一些基本markdown语法哎呀呀
  # 推荐Typora 所见即所得 搭配pigGO进行图床管理很方便
  # 然后终端直接运行脚本yoli.sh
  bash yoli.sh "关于本次提交的说明,比如: 添加了评论系统"
  # 大概过个一两分钟(第一次部署会慢些)就能通过配置的域名yolichan.fun访问博客站点啦
  ```

  ![image-20230802131946420](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/blog-yoli%E5%88%9D%E8%B2%8C.png)

* 使用`cloudflare`提供的`CDN`加速服务来为访问网站提速

  只需要在`DNS`管理那里将代理状态勾选上即可, 如果需要 `SSL/TLS 严格加密模式`, 可以在解析`A记录`时暂时将代理状态禁用, 也就是暂时禁用`CDN`, 解析生效后, 在`GitHub Pages`后台开启`Enforce HTTPS` , 待`Github Pages`的`https`生效后, 再将`CloudFlare`的代理状态启用.

  ![image-20230802124113395](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/%E5%90%AF%E7%94%A8CDN%E5%8A%A0%E9%80%9F.png)

### 后记

搭建网站的事四月前就开始弄了, 几乎没接触过前端的我为了赶工照猫画虎弄出了一个很简单的demo, 最最最离谱的是当时连评论系统都建好了, 结果创建的文章不能显示, 当时迷迷糊糊用了一些野路子最终还是把生日祝福加上去了, 但是但是, 由于踩坑受创太多, 后面一直在摆, 小破站就像一间漏雨的小屋, 一直没有得到修补(修理工😢). 兜兜转转到7月, 心中还是没能放下小破站, 正好经历了一些心境的转变, 开始对自己不再那么push, 经历了一次搬家算是彻底告别了校园生活, 每天骑自行车去工位, 然后回到自己的小窝, 开始动手自己带便当🍱(单位食堂好贵...). 日子归于平静, 反而一点一点重拾了建站的信心, 因为当初的bug一直没有排查, 所以除了一些能看懂的配置文件(实在不想再配置一遍), 源码删了个尽, 后知后觉想起生日祝福的页面还没有保留的时候我😢😢😢. 

打开教程从头来了一遍, 鉴于之前的踩坑经验, 再建站反而要顺利很多, 就连文章不显示的bug在不知不觉间摸清了, 然后我收获了:

 一些`html`和`css`代码的调用原理, 一些`markdown`基础语法, `git`管理工具, 还有困扰我已久的`GitHub`到底是用来干嘛的. 之前一直以为就是一个存代码的云盘, 现在发现还能进行代码管理以及`GitHub Pages` \ `GitHub Action`等工具也很有趣, 之后的评论系统/图床管理也都用到了`GitHub`, 虽然现在的我依然无法给出一个准确定义, 但至少它现在在我眼里是一个神奇的网站. 其实还运用到了`go`语言的知识, 但主要是一些模板和短代码使用到了`go`语言语法, 而这部分基本上是直接网上复制来的, 最多修改一些参数, 所以不会`go`语言其实影响不大. 奇怪的知识一直在增加...但很有趣...除了bug...

回归建站初衷. 曾经经历过一段封闭压抑的日子, 仿佛一台卡住了传送带的机器, 只有输入没有输出, 结果就是内部部件的损耗. 然而主流的社交平台太多限制, 管理起来也有诸多不便, 所以博客或许会是一个不错的选择. 就是这忽高忽低的分享欲...还有就是和好朋友分开了, 积攒的很多分享欲常常会搁置过期, 记忆它时常出走...如果能将这些想法记录下来放到小站上, 想起对方的时候就打开博客看看, 感觉很不错的样子, 所以接下来的工作: 除了继续完善小站的搭建(一点修理工的自我修养)以外最重要的就是实现共同协作啦,  一起期待吧◕‿◕｡

### TODO

- [x] 网站美化\文章样式设计\图床管理
- [x] 搭建评论系统
- [x] 添加站内搜索功能
- [x] 配置友链展示页面(有总比没有好hhh)
- [ ] 实现共同协作
- [ ] 增加网站数据统计分析功能
- [ ] 添加自动关联文章功能
- [ ] 添加回到顶部按钮
- [ ] 等一个适合的logo


