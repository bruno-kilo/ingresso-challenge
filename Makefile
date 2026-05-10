.PHONY: build test clean resolve

PACKAGE_PATH = Packages/IngressoKit

build:
	swift build --package-path $(PACKAGE_PATH)

test:
	swift test --package-path $(PACKAGE_PATH)

clean:
	swift package --package-path $(PACKAGE_PATH) clean

resolve:
	swift package --package-path $(PACKAGE_PATH) resolve
