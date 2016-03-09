all: clean lmd model

CONVERTER=~/caffe/build/tools/convert_imageset
MEAN=~/caffe/build/tools/compute_image_mean.bin
CAFFE=~/caffe/build/tools/caffe
RESIZE=100

clean:
	rm -rf models
	#rm -rf images
	rm -rf test_lmd 
	rm -rf train_lmd
	rm -rf meanfile.binaryproto 

lmd:
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle / ./images/train.txt train_lmd
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle / ./images/train.txt test_lmd
	@$(MEAN) train_lmd meanfile.binaryproto

get-images:
	./get_images

model:
	@if [ ! -d models ]; then \
	  mkdir models; \
	fi
	@$(CAFFE) train -solver=solver.prototxt
