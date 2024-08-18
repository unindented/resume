INPUT := .
MARKDOWN := $(INPUT)/index.md
STYLE := $(INPUT)/style.css
IMAGES := $(wildcard images/*)

OUTPUT := docs
HTML := $(OUTPUT)/index.html
PDF := $(OUTPUT)/index.pdf
WORD := $(OUTPUT)/index.docx
TEXT := $(OUTPUT)/index.txt

all: $(HTML) $(PDF) $(WORD) $(TEXT)

$(HTML): $(MARKDOWN) $(STYLE) $(IMAGES)
	pandoc \
		--embed-resources \
		--standalone \
		--from markdown+smart \
		--to html5 \
		--css https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css \
		--css $(STYLE) \
		--output $(HTML) \
		$(MARKDOWN)

$(PDF): $(HTML)
	pnpm install
	pnpm print $(HTML) $(PDF)

$(WORD): $(MARKDOWN) $(IMAGES)
	pandoc \
		--from markdown \
		--to docx \
		--output $(WORD) \
		$(MARKDOWN)

$(TEXT): $(MARKDOWN)
	pandoc \
		--standalone \
		--from markdown+smart \
		--to plain \
		--output $(TEXT) \
		$(MARKDOWN)

clean:
	rm -rf $(OUTPUT)/*

.PHONY: clean
