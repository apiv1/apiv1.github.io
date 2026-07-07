import sys
from pathlib import Path
from pdf2docx import Converter


def convert(pdf: Path, docx: Path | None = None):
    docx = docx or pdf.with_suffix(".docx")
    cv = Converter(str(pdf))
    try:
        cv.convert(str(docx))
    finally:
        cv.close()
    return docx


def main():
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        return

    if len(args) == 1 and "*" in args[0]:
        args = [str(p) for p in Path(".").glob(args[0])]

    for pdf in map(Path, args):
        if pdf.suffix.lower() != ".pdf" or not pdf.is_file():
            print(f"[跳过] {pdf}")
            continue
        print(f"[完成] {pdf} -> {convert(pdf)}")


if __name__ == "__main__":
    main()
