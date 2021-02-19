SHELL := /bin/bash

FUNCTION_NAME=image-processor
BUILD_FOLDER=build/$(FUNCTION_NAME)
SOURCE_FOLDER=source/$(FUNCTION_NAME)

export PYLINTHOME=.

init:
	rm -rf $(FUNCTION_NAME)-env; \
	virtualenv $(FUNCTION_NAME)-env -p python3; \
	source $(FUNCTION_NAME)-env/bin/activate; \
	pip install pylint

lint:
	source $(FUNCTION_NAME)-env/bin/activate; \
	pylint $(SOURCE_FOLDER)/*.py

build: init lint clean
	mkdir -p $(BUILD_FOLDER)
	source $(FUNCTION_NAME)-env/bin/activate; \
	pip install -r $(SOURCE_FOLDER)/requirements.txt; \
	cp $(SOURCE_FOLDER)/*.py $(BUILD_FOLDER)/

clean:
	rm -rf $(BUILD_FOLDER)
