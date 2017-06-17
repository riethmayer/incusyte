BIN = /usr/bin/env Rscript
INPATH = ./data
OUTPATH = ./output
OUT = $(OUTPATH)/$(shell date "+%Y%m%d")

incusyte = $(OUT)/foo.csv
filename = ./fixtures/plate_example.txt

$(incusyte): ./bin/incusyte.R
	@mkdir -p $(@D)
	./$< --output $@ --file $(filename)

incusyte: $(incusyte)

all: $(incusyte)

.PHONY: install
install: Install.R
	brew bundle
	./$<
