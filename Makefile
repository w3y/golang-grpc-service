.PHONY: all

# check os and arch
GOOS	= linux
GOARCH	= amd64

UNAME	:= $(shell uname)
OS		:= $(shell echo $(UNAME) |tr '[:upper:]' '[:lower:]')
ARCH	:= $(shell uname -m)
ifeq ($(OS), darwin)
	GOOS = darwin
endif

ifneq ($(ARCH), x86_64)
	GOARCH = 386
endif

# Replace backslashes with forward slashes for use on Windows.
# Make is !@#$ing weird.
E		:=
BSLASH 	:= \$E
FSLASH 	:= /


# Directories
WD			:= $(subst $(BSLASH),$(FSLASH),$(shell pwd))
MD			:= $(subst $(BSLASH),$(FSLASH),$(shell dirname "$(realpath $(lastword $(MAKEFILE_LIST)))"))
PKGDIR		= $(MD)
CMDDIR		= $(PKGDIR)/cmd
DISTDIR		:= $(WD)/dist
CONFDIR		:= $(WD)/conf

REPO = golang-grpc-service

# generate protobuf
proto_gen:
	@for d in ./proto/*/*/; do \
		protoc --proto_path=. --proto_path=$(GOPATH)/src \
			--go_out=plugins=grpc:$(GOPATH)/src $$d/*.proto; \
		echo "compiled: $$d*.proto"; \
	done

proto_clean:
	@rm -f $(GOPATH)/src/$(REPO)/exmsg/*/*/*.pb.go

proto_combo: proto_clean
proto_combo: proto_gen


test_all:
	@go fmt ./...
	@go test -cover $(allpackages)
	@go vet ./...


version:
	@echo $(VERSION)