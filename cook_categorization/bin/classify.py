#!/usr/bin/env python
# -*- coding: utf-8 -*-

import matplotlib 
matplotlib.use('Agg') 

import numpy as np
import sys
import os

# 0 - debug
# 1 - info (still a LOT of outputs)
# 2 - warnings
# 3 - errors 
os.environ['GLOG_minloglevel'] = '2'
import caffe

resize_size = 100

# デプロイ用ネットワークファイルへのパス
MODEL_FILE = "./deploy.prototxt"

# 学習済みモデルへのパス
PRETRAINED = "./models/snapshot_iter_20000.caffemodel"

# 予測を行う画像ファイルへのパスをコマンドライン引数から受け取る
argvs = sys.argv
argc = len(argvs)

if argc < 2:
    print("Usage: python classify.py <image_path>")
    sys.exit(1)

IMAGE_FILE = argvs[1]

# CPUモードを設定
# caffe.set_mode_cpu()

# モデルの読み込み
net = caffe.Classifier(MODEL_FILE, PRETRAINED, channel_swap = (2,1,0),
                        image_dims = (resize_size, resize_size))

# 入力画像の読み込み
input_image = caffe.io.load_image(IMAGE_FILE, color = True)

# 画像分類処理を実行
prediction = net.predict([input_image], False)

# 予測結果を出力
#print("prediction shape: {}".format(prediction[0].shape))
print("{}".format(prediction[0].argmax()))

