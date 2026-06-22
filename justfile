set working-directory := "lectures"

entry := "lec.typ"
output := "lec.pdf"
pdf_standard := "a-2u"

git_hash := `git rev-parse --short HEAD`
git_date := `git log -1 --format=%cd --date=short`

default: build

build:
    typst compile {{entry}} --pdf-standard {{pdf_standard}} --input git-hash={{git_hash}} --input git-date={{git_date}}

watch:
    typst watch {{entry}} --pdf-standard {{pdf_standard}} --input git-hash={{git_hash}} --input git-date={{git_date}}

clean:
    rm -f {{output}}
