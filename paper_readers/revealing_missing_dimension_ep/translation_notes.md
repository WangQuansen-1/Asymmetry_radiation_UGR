# Translation and Extraction Notes

## Scope

This is a study-oriented reader for the main 9-page article, not a complete paragraph-by-paragraph bilingual translation. It preserves the article's argument structure, page anchors, figure placement, and core original/Chinese block pairs. The supplementary PDF is identified but not yet read in detail.

## Source Files

- Zotero item: `GBHX46SI`
- Main PDF attachment: `X8Q38BJ7`
- Supplementary PDF attachment: `GCZ7VLL8`
- Extracted text: `extracted/main_text_by_page.txt`
- Rendered page images: `assets/page-1.png` through `assets/page-9.png`
- Figure crops: `assets/fig1.png` through `assets/fig6.png`

## Extraction Quality

- The main PDF has a selectable text layer.
- Default text extraction has some two-column reflow issues, especially on pages 1-3 and 9.
- Page images were rendered and inspected to recover the argument order and figure placement.
- The PDF includes user highlights; these were visually useful for identifying the most important theoretical claims.

## Pending Work

- Full paragraph-level bilingual translation of all body text.
- Detailed reading of the 32-page supplementary PDF, especially the coupled-mode derivation, Green's-function derivation, SALT comparison, and acoustic boundary implementation.
- More precise equation-by-equation reconstruction if this paper will be used directly in a theory manuscript.

## Verification

- `paper.md` contains `**Original:**` and `**中文:**` source pairs.
- All image links in `paper.md` point to existing files under `assets/`.
- `source_map.json` records stable source block IDs and parses as JSON.

