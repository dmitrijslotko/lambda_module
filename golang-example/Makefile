GOARCH ?= arm64 
ARTIFACTS_DIR ?= ./.build

lambda:
	@echo "Building Lambda."
	rm -rf ./.build
	go mod tidy
	GOOS=linux GOARCH=$(GOARCH) go build -o bootstrap 
	@echo "Copying bootstrap to $(ARTIFACTS_DIR)/bootstrap"
	mkdir -p $(ARTIFACTS_DIR) 
	cp ./bootstrap $(ARTIFACTS_DIR)/bootstrap
	chmod +x $(ARTIFACTS_DIR)/bootstrap
	rm -rf bootstrap
	@echo "Build complete."