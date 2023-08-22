---
title: "2023 08 22 配置友链页面"
date: 2023-08-22T11:13:19+08:00
lastmod: 2023-08-22T11:13:19+08:00
draft: false
tags: []
categories: ["pocket-book"]
authors:
- "koi"
---

### 序

友链页面的配置主要还是看网站风格和个人喜好, 虽然暂时还是小透明一枚, 没有什么友链可挂, 但还是想一次性将小破站修缮完整(给小破站一点排面😹), 这样将来也能投入到更纯粹的创作之中. 闲逛时感觉将光标悬于头像上头像便自动旋转360度的动态效果很有趣, 于是参考了Jay[^jay]的代码,  这位作者的代码加入了简单的移动页面适配, 且代码可读性比较高, 配置起来也比较简单. 最后调整了原方案的字体和配色, 与网站主题保持一致, 友链页面便搭建完成了, 在整个博客搭建过程中, 属于比较简单的一环.

[^jay]: [Jay: Hugo 篇四：添加友链卡片 shortcodes](https://blog.233so.com/2020/04/friend-link-shortcodes-for-hugo-loveit/#comments)

### 短代码模板

同样通过创建短代码shortcodes的方式引入友链模板. 在`/blog-yoli/layouts/shortcodes/`目录下创建短代码模板文件`friend.html`:

``` html
{{ if .IsNamedParams }}
<a target="_blank" href={{ .Get "url" }} title={{ .Get "name" }} class="friendurl">
  <div class="frienddiv">
    <div class="frienddivleft">
      <img class="myfriend" src={{ .Get "logo" }} />
    </div>
    <div class="frienddivright">
      <div class="friendname">{{ .Get "name" }}</div>
      <div class="friendinfo">{{ .Get "word" }}</div>
    </div>
  </div>
</a>
{{ end }}
```

### 友链页面文件

在`/blog-yoli/content/zh/`(后续copy到en目录下)下创建友链页面文件 `links.md`用以存放和展示友链:

![image-20230822115700409](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/hugo-friend-link-archive.png)

> 其中{{}}里面的内容即需要展示的友链主要信息组成: 姓名\链接\logo\简介
>
> 由于直接展示代码文本会被网站运行, 所以这里展示的是代码段截图😅

### 友链的样式设计

在样式文件`/blog-yoli/static/css/den.css`中添加友链的样式设计信息如下:

``` css
/* 友链 */
.friendurl {
	text-decoration: none !important;
	color: rgba(74, 58, 63, 0.817) 
}
   
.myfriend {
	width: 56px !important;
	height: 56px !important;
	border-radius: 50%;
	border: 1px solid #dddddd;
	padding: 2px;
	box-shadow: 1px 1px 1px rgba(5, 140, 150, 0.278);
	margin-top: 14px !important;
	margin-left: 14px !important;
	background-color: #fff;
}
   
.frienddiv {
  font-size: 12px;
	/* height: 85px;
	margin-top: 10px;
  margin-right: 1px;
  margin-left: 2px;
	width: 31%; */
  height: 92px;
  margin-top: 10px;
  width: 48%;
	display: inline-block !important;
	border-radius: 5px;
	background: rgba(255, 255, 255, 0.257);
	box-shadow: 0.3px 0.3px 0.3px 0.3px rgba(253, 253, 253, 0.085);
}
   
.frienddiv:hover {
	background: rgba(100, 87, 90, 0.063);
  text-decoration: underline;
}
    
.frienddiv:hover .frienddivleft img {
	transition: 0.6s !important;
	-webkit-transition: 0.6s !important;
	-moz-transition: 0.6s !important;
	-o-transition: 0.6s !important;
	-ms-transition: 0.6s !important;
	transform: rotate(360deg) !important;
	-webkit-transform: rotate(360deg) !important;
	-moz-transform: rotate(360deg) !important;
	-o-transform: rotate(360deg) !important;
	-ms-transform: rotate(360deg) !important;
}
   
.frienddivleft {
	width: 92px;
	float: left;
}
   
.frienddivleft {
	margin-right: 0.5px;
}
   
.frienddivright {
	margin-top: 18px;
	margin-right: 18px;
}
   
.friendname {
  font-weight: 600 !important;
  color :rgba(93, 59, 71, 0.804);
  text-shadow:1px 1px 2px rgba(142, 69, 95, 0.648);
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
}
   
.friendinfo {
  color :rgba(93, 59, 71, 0.804);
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
}
   
@media screen and (max-width: 600px) {
  .friendinfo {
   display: none;
  }
  .frienddivleft {
   width: 84px;
   margin: auto;
  }
  .frienddivright {
   height: 100%;
   margin: auto;
   display: flex;
   align-items: center;
   justify-content: center;
  }
  .friendname {
   font-size: 14px;
  }
 }
```

> 试图在自定义样式文件``custom.css``中引入这段代码,但并没有生效orz, 懒得折腾, 所以直接放进了网站样式主文件`den.css`文件中

### 最终呈现效果

{{< friend name="koi" url="https://www.yolichan.fun" logo="https://cdn.jsdelivr.net/gh/mewoooew/figureBed@main/img/202304022156812.png" word="爱摸鱼的修理工" >}}

![image-20230822114732588](https://cdn.jsdelivr.net/gh/mewoooew/picGO@main/images/hugo-friend-link-show.png)
