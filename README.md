# research-debian-packaging

研究 Debian 打包 ( Packaging ) 相關文獻、設計流程。

## 專案操作

### 啟動開發模式

使用 CLI 呼叫開發容器

```
do dev
```

開發主要處理 ```/app``` 目錄下的腳本，其中腳本用途如下：

+ ```inst```：部署程序 ( 或稱安裝程序 ) 腳本集，主要執行安裝程序與相應內容的處理過程
+ ```wrap```：包裝程序腳本集，主要執行專案內容發佈程序、包裝程序的處理過程

### 發佈

使用 CLI 呼叫發佈程序，將指定的來源內容與部屬腳本整合。

```
do pub
```

發佈主要會執行 ```app/wrap/publish.sh``` 程序，並執行 ```conf/publish/main.sh``` 為發佈後處理程序。

### 包裝

使用 CLI 呼叫包裝程序，將發佈的內容包裝成指定的壓縮格式並添加相關腳本

```
do pack
```

包裝主要會執行 ```app/wrap/package.sh``` 程序，並執行 ```conf/package/main.sh``` 為發佈後處理程序。

## 文獻

+ [Debian Packaging](https://wiki.debian.org/Packaging/Intro)
    - [Chapter 7. Basics of the Debian package management system](https://www.debian.org/doc/manuals/debian-faq/pkg-basics.en.html)
+ 教學
    - [Debian Packaging by Example](https://john-tucker.medium.com/118c18f5dbfe)
    - [如何製作「deb檔(Debian Package)」](https://samwhelp.github.io/book-ubuntu-basic-skill/book/content/package/how-to-build-package.html)
