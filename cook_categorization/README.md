# 料理画像自動分類器

## 画像の分類

分類実行前にパスを通す。

```
$ export PYTHONPATH=~/caffe/python:${PYTHONPATH} 
```

画像に対して分類を実行する。

```
$ cd sugoi-up/cook_categorization
$ ./bin/classify [分類する画像へのパス]
> [結果ラベル]
```

例:

```
$ ./bin/classify target_images/guratan01.jpg
> 4
```

## 環境構築手順

1. [Caffe on EC2 Ubuntu 14.04 Cuda 7](https://github.com/BVLC/caffe/wiki/Caffe-on-EC2-Ubuntu-14.04-Cuda-7)からGPUインスタンスを立ち上げる
    * 以降の手順は実行ユーザーのホームディレクトリに `~/caffe` ディレクトリがあることを前提としています。
2. 本プロジェクトをcloneする.
    ```
    $ cd ~/
    $ git clone https://github.com/mls-itoc/sugoi-up.git
    ```

3. 分類対象の画像は、あらかじめリサイズが必要なため、必要に応じてツールをインストールしておく
    ```
    $ sudo apt-get install imagemagick
    ```

## 学習

学習は以下の手順で行う

```
$ cd ~/sugoi-up/cook_categorization
$ make
```

### make パラメータ

以下の手順は、全て `$ make` で実行されます。機能単体で実行する場合のみ、以下を実行してください。

学習用DBと学習モデルの削除

```
$ make clean
```

学習用画像ファイルと `train.txt` の取得

```
$ make get-images
```

`train.txt` と画像ファイルを元に学習用DB (LMDB)の生成

```
$ make lmdb
```

学習を実施し、学習モデルを生成する。

```
$ make model
```

## メモ

### libdc1394に関するエラー

分類時に以下のようなエラーが出る場合

```
libdc1394 error: Failed to initialize libdc1394
```

以下を実行しておく。

```
sudo ln /dev/null /dev/raw1394
```
