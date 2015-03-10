dirs = $(shell ls */Makefile | cut -f1 -d /)

all:
	$(foreach dir,$(dirs),cd $(dir); make; cd ..;)
