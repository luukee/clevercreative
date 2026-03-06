# clevercreative.com SEO

[Basecamp: Clever Website Optimization](https://3.basecamp.com/5423290/projects/46302916)

Lighthouse reports and runbook for [clevercreative.com](https://www.clevercreative.com) (SEO and performance audits).

## [clevercreative.com SEO Github Pages](https://luukee.github.io/clevercreative/)

## What’s in this repo

- **lighthouse/** – HTML reports and index
  - `index.html` – list of report links (one per URL)
  - `urls.txt` – URLs to audit (one per line; `#` comments allowed)
  - `run-all.sh` – script that runs Lighthouse for every URL in `urls.txt`
  - `www.clevercreative.com_*.report.html` – generated Lighthouse reports

## Running reports

1. Install [Lighthouse CLI](https://github.com/GoogleChrome/lighthouse#cli): `npm install -g lighthouse`
2. From the `lighthouse` folder: `./run-all.sh`
3. Reports are written as `www.clevercreative.com_<path>.report.html` (e.g. `www.clevercreative.com_work.report.html`).

To use a different URL list: `./run-all.sh my-urls.txt`

## Viewing reports

- **Local:** Open `lighthouse/index.html` in a browser.
- **GitHub Pages:** After enabling Pages in repo Settings, the reports index is at `…/lighthouse/index.html`.
  - [Pico Framework CSS](https://picocss.com/docs)

## Fix plan

See [Fix Lighthouse first-run issues](.cursor/plans/fix_lighthouse_first-run_issues_877b4c80.plan.md) for prioritized fixes from the first run (JS error, performance, SEO link text, heading order).
