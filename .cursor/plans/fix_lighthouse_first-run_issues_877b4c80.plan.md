---
name: Fix Lighthouse first-run issues
overview: "Address the highest-impact issues from the first Lighthouse run: a site-wide JavaScript error, poor Performance (LCP, TBT, render-blocking), SEO link text on the work page, and heading order on six pages. The site is hosted on Squarespace; fixes are done in Squarespace admin (custom code, content, and theme), not in this repo."
todos: []
isProject: false
---

# Fix most important Lighthouse issues (first run)

## Context

- **Site:** clevercreative.com (Squarespace). This repo only contains [lighthouse/](lighthouse/) reports and scripts; the live site is edited in Squarespace.
- **Scores (sample):** Home Performance 0.31, SEO 1; Work Performance 0.53, SEO 0.92; Press Performance 0.47, SEO 1. Accessibility and Best Practices are high (0.96–0.98).
- **Main problem area:** Performance (all pages), plus one SEO audit and one accessibility audit on specific pages.

---

## 1. Fix JavaScript error (all 20 pages) — Critical

**Audit:** `errors-in-console` (score 0 on every page)

**Issue:** `SyntaxError: Unexpected end of input` on the main document at **line 13183, column 87** (so it’s inline/injected script, not a separate file).

**Impact:** Breaks or delays script execution, increases Total Blocking Time, and can affect crawlability.

**Actions:**

- In Squarespace: **Settings → Advanced → Code Injection** (and any **Code** blocks in page/section headers/footers). Look for:
  - Incomplete or truncated `<script>...</script>` (missing `</script>`, unclosed brackets, or pasted code that was cut off).
  - Third-party snippets (analytics, chat, etc.) that might be malformed.
- Identify the block that corresponds to the end of the page (around the reported line in the rendered HTML). Fix or remove the broken snippet.
- Re-run Lighthouse on the home page and confirm `errors-in-console` passes.

---

## 2. Performance: quick wins (all pages)

**Main culprits from reports:**


| Issue                     | Example (home)                                       | Action                                                                                                                                                                                |
| ------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Render-blocking resources | ~1.9s savings; Squarespace CSS + Google Fonts        | In Code Injection, add `rel="preload"` for critical fonts if possible; defer non-critical custom CSS/JS. In Squarespace Design → Fonts, use only needed weights.                      |
| Unused CSS/JS             | 136 KiB CSS, 843 KiB JS (much from Squarespace core) | Remove or trim custom CSS/JS; avoid duplicate analytics or scripts. Cannot fix Squarespace core bundles.                                                                              |
| LCP (14.3s home)          | Very slow largest contentful paint                   | Ensure hero/above-the-fold image is optimized and not lazy-loaded; add `width`/`height`; use next-gen format if possible. Fixing the JS error will reduce TBT and help interactivity. |
| DOM size (1,370 nodes)    | “Avoid an excessive DOM size”                        | Simplify layout: fewer nested sections/blocks on key pages; collapse or lazy-load heavy sections (e.g. big grids) where possible.                                                     |
| Images                    | Unsized images, offscreen images                     | Add explicit `width` and `height` in image blocks; rely on Squarespace lazy-load for below-fold images.                                                                               |


**Order of operations:** Fix the JS error first, then images and fonts, then trim custom code and simplify DOM where you control content/layout.

---

## 3. SEO: non-descriptive link text (work page only)

**Audit:** `link-text` (score 0) — “Links do not have descriptive text”

**Issue:** Many links use the same generic text **“Read More”** (e.g. to cleverbranded.com/dc-comics, apres-nails-gel-x, fhi-heat, etc.). Same text for different URLs hurts accessibility and SEO.

**Actions:**

- On the **Work** page (project/case study listing), change each “Read More” to **unique, descriptive text**, e.g.:
  - “Read more about DC Comics” / “Read more about Apres Nails Gel X” / “Read more about FHI Heat”
- Or use **aria-label** on the link if you must keep “Read More” visually, e.g. `aria-label="Read more about DC Comics"` (Squarespace may allow this in a code block or link settings).
- Re-run Lighthouse on the work page and confirm `link-text` (and SEO category) improve.

---

## 4. Accessibility: heading order (6 pages)

**Audit:** `heading-order` (score 0) on: **home, fhi-heat, privacy-policy, spi-1, vca-tradeshow, work**

**Issue:** Heading levels don’t follow a strict order (e.g. H1 → H2 → H3 with no skips, like going from H2 to H4).

**Actions:**

- On each of the six pages, in Squarespace:
  - Use the **heading block** or text block “Heading” and assign the correct level (Heading 1 = H1, Heading 2 = H2, etc.).
  - Ensure one H1 per page, then H2 for main sections, then H3 for subsections, with no skipped levels.
- Check any **custom HTML** or code blocks that output headings and fix levels there too.
- Re-run Lighthouse on those URLs and confirm `heading-order` passes.

---

## 5. Optional: re-run and track

- After each change (or batch), run your script for the affected URLs, e.g.:
  - `./run-all.sh` for full set, or run Lighthouse manually for one URL.
- Regenerate or update [lighthouse/index.html](lighthouse/index.html) if you add/remove URLs or change report filenames (your current index already lists path-based reports).
- Focus next runs on Performance and the audits above to confirm improvements.

---

## Summary


| Priority | Issue                                                | Scope     | Where to fix                                                 |
| -------- | ---------------------------------------------------- | --------- | ------------------------------------------------------------ |
| 1        | JavaScript syntax error                              | All pages | Squarespace Code Injection / code blocks                     |
| 2        | Performance (LCP, TBT, render-blocking, images, DOM) | All pages | Squarespace Design, fonts, images, custom code; fix JS first |
| 3        | “Read More” link text                                | Work page | Squarespace Work page content / links                        |
| 4        | Heading order                                        | 6 pages   | Squarespace heading blocks / custom HTML on those pages      |


## Checklist

- **1. JavaScript error** — Fix syntax error in Code Injection / code blocks; re-run Lighthouse on home and confirm `errors-in-console` passes
- **2. Performance** — After JS fix: fonts, hero/LCP image, image dimensions, trim custom CSS/JS; reduce DOM where possible
- **3. SEO link text** — Work page: change each “Read More” to descriptive text (or add aria-label); re-run on work page
- **4. Heading order** — Home, fhi-heat, privacy-policy, spi-1, vca-tradeshow, work: fix H1→H2→H3 (no skips); re-run on those URLs
- **5. Re-run & track** — Run `./run-all.sh` (or single URLs); update reports; confirm improvements on Performance and above audits

---

No edits are required in this repo; all fixes are on the live Squarespace site and in its admin.