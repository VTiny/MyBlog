 

## 本工程初始化方式

#### step1. clone本工程

```shell
git clone https://github.com/MrLiuxia/MyBlog.git ${path}
```

#### step2. 同步-submodule

```shell
cd ${path}
git submodule init
git submodule update

```

#### step3. 应用submodule-next的本地修改

```shell
cd themes/next
git am -s < ../../patch/next/0001-update-personal-settings.patch
cd ...
```

#### step4. 初始化node

```shell
npm install
```

#### step5. 本地hexo构建

```shell
hexo clean
hexo generate
hexo server
```



> todo 初始化脚本