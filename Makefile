SHELL := /bin/sh

SOURCE_FILES = $(wildcard *.odt)

PDF_FILES = $(SOURCE_FILES:.odt=.pdf)
FDF_FILES = $(SOURCE_FILES:.odt=.fdf)

GENERATED_FILES ?= $(PDF_FILES) $(FDF_FILES)

.PHONY : all
all : pdf fdf

.PHONY : pdf
pdf : $(PDF_FILES)

%.pdf : %.odt
	@libreoffice --headless --convert-to pdf $^ \
  "-env:UserInstallation=file:///tmp/libreofficebug"

.PHONY : fdf
fdf : $(FDF_FILES)

%.fdf : %.pdf
	@pdftk $^ generate_fdf output $@

.PHONY : watermark
watermark : watermark.pdf
watermark.pdf : Makefile
	@convert -background none -fill grey \
  -geometry +50+0 \
  -font DejaVu-Sans-Condensed -pointsize 10 \
  label:'commit $(shell git rev-parse HEAD)' -set label '' -page letter $@

.PHONY : clean
clean :
	@rm -f $(GENERATED_FILES)
