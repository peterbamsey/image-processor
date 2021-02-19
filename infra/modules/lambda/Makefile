SHELL := /bin/bash

FUNCTION_NAME=image-processor
BUILD_FOLDER=build/$(FUNCTION_NAME)
SOURCE_FOLDER=source/$(FUNCTION_NAME)

export PYLINTHOME=.

init:
	pip3 install pylint

lint:
	pylint $(SOURCE_FOLDER)/*.py

build: init lint clean
	mkdir -p $(BUILD_FOLDER)
	pip3 install -r $(SOURCE_FOLDER)/requirements.txt -t $(BUILD_FOLDER)
	cp $(SOURCE_FOLDER)/*.py $(BUILD_FOLDER)/

clean:
	rm -rf $(BUILD_FOLDER)
