all: clean get-images lmd model

CONVERTER=~/caffe/build/tools/convert_imageset
CAFFE=~/caffe/build/tools/caffe
RESIZE=100

clean:
	rm -rf models
	rm -rf images
	rm -rf test_lmd 
	rm -rf train_lmd 

lmd:
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle=true ./ ./images/train.txt train_lmd
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle=true ./ ./images/train.txt test_lmd

get-images:
	./get_images

model:
	@if [ ! -d models ]; then \
	  mkdir models; \
	fi
	@$(CAFFE) train -solver=solver.prototxt
