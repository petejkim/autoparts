image:
	@docker build -t nitrousio/autoparts-builder .
.PHONY: image

shell: image
	@./script/buildenv
.PHONY: shell
