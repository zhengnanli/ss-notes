set working-directory := "lectures"

entry := "lec.typ"
output := "lec.pdf"
pdf_standard := "a-2u"

default: build

build:
    typst compile {{entry}} --pdf-standard {{pdf_standard}}

watch:
    typst watch {{entry}} --pdf-standard {{pdf_standard}}

clean:
    rm -f {{output}}
