all: clean lmd model

CONVERTER=../build/tools/convert_imageset
CAFFE=../build/tools/caffe
RESIZE=100

clean:
	rm -rf models
	rm -rf test_lmd 
	rm -rf train_lmd 

lmd:
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle=true ./ ./train.txt train_lmd
	@$(CONVERTER) -resize_height=$(RESIZE) -resize_width=$(RESIZE) -shuffle=true ./ ./train.txt test_lmd

model:
	@if [ ! -d models ]; then \
	  mkdir models; \
	fi
	@$(CAFFE) train -solver=solver.prototxt
