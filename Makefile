.POSIX:
export ROOTDIR ?= $(eval ROOTDIR := $(shell git rev-parse --show-toplevel))$(ROOTDIR)
include $(ROOTDIR)/make.mk

.DEFAULT_GOAL := build

.PHONY: build
build: docker/bake

.PHONY: docker docker/%
docker: configure FORCE
	@$(MAKE) -C docker
docker/%: configure FORCE
	@$(MAKE) -C docker $*

.PHONY: test/e2e
test/e2e: configure
	@cd tests && export PROJECT_ROOT=$(ROOTDIR) && $(BATS) .

# Shared (used by both format and lint)
_SHFILES = $(GIT) ls-files '*.sh' '*.bats' | tr '\n' '\0'

.PHONY: format
format: configure
	@$(_SHFILES) | xargs -0 $(SHFMT) -w

.PHONY: lint
lint: configure
	@$(_SHFILES) | xargs -0 $(SHFMT) -d

.PHONY: count
count: configure
	@$(CLOC) $$($(GIT) ls-files)

.PHONY: clean
clean:
	@rm -rf $(MAKEDIR) .dockerignore

.PHONY: purge
purge: clean
	@$(GIT) clean -fxd

ASDF_VERSION ?= v0.18.0
.PHONY: prepare prepare/asdf prepare/cloc
prepare: sudo
	@command -v asdf >/dev/null 2>&1 || $(MAKE) prepare/asdf
	@command -v cloc >/dev/null 2>&1 || $(MAKE) prepare/cloc
	@awk '!/^#/ && NF {print $$1}' .tool-versions | \
		while read t; do asdf plugin add "$$t" 2>/dev/null || true; done
	@rcfile=$$(mktemp); \
		{ asdf install 2>&1; echo $$? >$$rcfile; } | grep --line-buffered -v 'is already installed' || true; \
		rc=$$(cat $$rcfile); rm -f $$rcfile; exit $$rc
prepare/asdf:
	@command -v brew >/dev/null 2>&1 && brew install asdf || { \
		o=$$(uname | tr A-Z a-z); a=$$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/'); \
		curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/$(ASDF_VERSION)/asdf-$(ASDF_VERSION)-$$o-$$a.tar.gz" \
			| $(SUDO) tar -xz -C /usr/local/bin asdf; \
	}
prepare/cloc:
	@$(PKG_INSTALL) cloc

.PHONY: configure
configure:
	@for cmd in asdf $(BATS) $(SHFMT) $(CLOC) docker; do \
		command -v $$cmd >/dev/null 2>&1 || { echo "$$cmd is missing, run \`make prepare\`"; exit 1; }; \
	done
