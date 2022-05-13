# babassl-benchmark 相关脚本说明
## Dockerfile
这个是 github actions self-hosted runner 镜像的 dockerfile，build 命令：
```
docker build . -t github-actions-runner
```

docker 容器启动命令：
```
docker run --rm -e GITHUB_PAT="$GITHUB_PAT" -e GITHUB_REPO_NAME="BabaSSL/BabaSSL" --cpus=1 --memory=1G -it github-actions-runner
```
其中，`$GITHUB_PAT`是 github 的 Personal Access Tokens 变量，需要在 github -> Settings -> Developer settings -> Personal access tokens，然后设置到变量 `$GITHUB_PAT` 中。
entrypoint.sh 和 runsvc.sh 是 Dockerfile 的 entrypoint 执行脚本。

## speed_parse.py
这个是解析 babassl speed 结果并保存到 mysql 数据库的 python 脚本，用法参数如下：
```
# python3 ./speed_parse.py -h
usage: speed_parse.py [-h] [-c COMMIT] [-l LAST_COMMIT] [-d DATE]
                      [-j JOB_DATE] -f FILE -t
                      {symmetric_encryption,asymmetric_encryption,signature,digest,key_exchange,phe}
                      --mysql-host MYSQL_HOST --mysql-user MYSQL_USER
                      --mysql-password MYSQL_PASSWORD --mysql-db MYSQL_DB
                      [--mysql-port MYSQL_PORT]

Parsing babassl speed test result and saving to the rds

optional arguments:
  -h, --help            show this help message and exit
  -c COMMIT, --commit COMMIT
                        git my commit id
  -l LAST_COMMIT, --last_commit LAST_COMMIT
                        git last commit id
  -d DATE, --date DATE  speed test date, for example: 2022-02-11 11:22:33
  -j JOB_DATE, --job-date JOB_DATE
                        run job date, for example: 2022-02-11 11:22:33
  -f FILE, --file FILE  speed test result file
  -t {symmetric_encryption,asymmetric_encryption,signature,digest,key_exchange,phe}, --type {symmetric_encryption,asymmetric_encryption,signature,digest,key_exchange,phe}
                        speed test algorithm type
  --mysql-host MYSQL_HOST
                        mysql host
  --mysql-user MYSQL_USER
                        mysql user
  --mysql-password MYSQL_PASSWORD
                        mysql password
  --mysql-db MYSQL_DB   mysql db
  --mysql-port MYSQL_PORT
                        mysql port
```
这个文件在 github actions workflow 中会调用。详情参考：https://github.com/BabaSSL/BabaSSL/actions/workflows/speed-test.yml

## babassl-speed-result.sql
speed_parse.py 脚本解析文本文件后保存到 mysql 数据库的表结构 SQL，可以在阿里云 RDS 产品中创建数据库并执行该 SQL 来创建表。
