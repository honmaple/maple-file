<div align="center">
  <img src="./app/assets/icon/icon.png" width="150" />
  <h1>红枫云盘</h1>
</div>

<div align="center">
  <a href="https://github.com/honmaple/maple-file/releases/tag/v1.0.8" target="_blank">
    <img src="https://img.shields.io/badge/release-1.0.8-brightgreen.svg">
  </a>
  <a href="https://apps.apple.com/us/app/maplefile/id6743229674" target="_blank">
    <img src="https://img.shields.io/badge/app%20store-black.svg?logo=apple">
  </a>
  <a href="https://github.com/honmaple/maple-file/blob/master/LICENSE" target="_blank">
    <img src="https://img.shields.io/badge/license-GPL3.0-blue.svg">
  </a>

 [主页][home] | [下载][download] | [帮助文档][document]
</div>

[home]: https://fileapp.honmaple.com
[document]: https://fileapp.honmaple.com/guide/introduction.html
[download]: https://github.com/honmaple/maple-file/releases/tag/v1.0.8

> 使用 **Flutter** 实现的无服务端多协议云盘文件上传和管理APP

## 支持的存储
   - [X] 本地文件
   - [X] FTP
   - [X] SFTP
   - [X] S3
   - [X] SMB
   - [X] Webdav
   - [X] Alist
   - [X] 又拍云
   - [X] 115网盘
   - [X] 夸克网盘
   - [X] Github
   - [X] Github Release
   - [X] Mirror(镜像站，支持文件查看和下载，支持格式：清华源、阿里源或者其他 **NGINX** 文件列表源)

| 存储            | 文件列表 | 新建目录 | 重命名 | 移动 | 复制 | 删除 | 上传 | 下载 |
|----------------|--------|--------|-------|-----|-----|-----|-----|-----|
| 本地文件         | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| FTP            | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| SFTP           | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| S3             | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| SMB            | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| Webdav         | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| ALIST          | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| 又拍云          | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ✅  | ✅  |
| 115网盘         | ✅     | ✅     | ✅    | ✅  | ✅  | ✅  | ❌  | ✅  |
| 夸克网盘         | ✅     | ✅     | ✅    | ✅  | ❌  | ✅  | ❌  | ✅  |
| Github         | ✅     | ❌     | ❌    | ❌  | ❌  | ❌  | ❌  | ✅  |
| Github Release | ✅     | ❌     | ❌    | ❌  | ❌  | ❌  | ❌  | ✅  |
| Mirror         | ✅     | ❌     | ❌    | ❌  | ❌  | ❌  | ❌  | ✅  |

## 功能
   - 支持文件列表查看/复制/移动/删除/重命名/上传/下载
   - 支持桌面端拖拽上传(文件或者文件夹)
   - 支持文件多选及操作
   - 支持文件列表信息缓存
   - 支持回收站
   - 支持视频、音频、图片和文本文件的预览
   - 支持文件加密和压缩
   - 支持各存储之间的备份和同步(**测试中**)
   - 支持多语言(中文、英文)
   - 支持 **Web**, **Android**, **MacOS** 和 **Windows**

## 截图
<table rules="none">
  <tr>
    <td width="33%"><img src="./example/screenshot/01.png" /></td>
    <td width="33%"><img src="./example/screenshot/02.png" /></td>
    <td width="33%"><img src="./example/screenshot/03.png" /></td>
  </tr>
   <tr>
    <td width="33%"><img src="./example/screenshot/04.png" /></td>
    <td width="33%"><img src="./example/screenshot/05.png" /></td>
    <td width="33%"><img src="./example/screenshot/06.png" /></td>
  </tr>
</table>

<table rules="none">
   <tr>
    <td width="50%"><img src="./example/screenshot/desktop-01.png" /></td>
    <td width="50%"><img src="./example/screenshot/desktop-02.png" /></td>
  </tr>
</table>
