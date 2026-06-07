---
description: Create a polished HTML slide deck from content. Offers 6 visual styles from glassmorphism to immersive single-file decks with per-slide animation lifecycles.
argument-hint: <file path, URL, or paste content directly>
user-invocable: true
model: sonnet
---

# Slides Skill

Generates a polished HTML slide deck from source content. Always ask the user which style they want before building.

## Style selection

Before generating slides, present the available styles:

> Which visual style do you want for this deck?
>
> 1. **Glassmorphism** — Animated floating orbs with frosted-glass cards. Premium and modern.
> 2. **Particles** — Three.js particle background with mouse reactivity. Big slide numbers as design element.
> 3. **White** — Clean light theme, horizontal navigation. Best for data-heavy content and printing.
> 4. **Immersive** (default) — Full environmental deck: subtle grid, glow orbs, cursor-reactive glow, pill nav with progress ring, per-slide animation lifecycles. Zero dependencies.
> 5. **Dark** — Same engine as Immersive but noir palette: ember orange + cyan. Dramatic and high-contrast.
> 6. **Midnight** — React + framer-motion + Vite. Beat system for progressive reveals. Spring physics. Requires build step.
>
> Or I can generate **one demo slide in all 6 styles** so you can compare.

Default to **Immersive** (style 4) if user doesn't specify.

---

## Navigation (all styles share)

Every style uses horizontal slide-by-slide navigation:
- Arrow keys (left/right), Space (forward), Home/End
- Dot indicators with active state
- Touch swipe (50px threshold)
- Hash deep links (`#3` goes to slide 3)
- Directional transitions (translateX with momentum)

---

## Input handling

1. If given a file path → read and use as content
2. If given a URL → fetch and extract content
3. If given pasted text → use directly
4. If given an existing HTML deck as reference → match its structure and CSS patterns

---

## Build rules

**Immersive (default) — single self-contained HTML file:**
- Inline `<style>` and `<script>` (fine for local use)
- Google Fonts via `<link>` is OK
- Per-slide animation lifecycles (elements animate in on slide enter)
- Subtle grid background, glow orbs, cursor-reactive ambient light
- Pill navigation with progress ring

**Multi-file styles (Glassmorphism, Particles, White):**
- HTML file + external `slides.js` for navigation
- Inline `<style>` is OK
- System font stack (no external font CDNs)
- No inline `<script>` tags (all JS in external files)

**Midnight:**
- React + framer-motion + Vite project
- Beat system for progressive reveals
- Spring physics animations
- Requires `npm install && npm run dev`

---

## Slide content guidelines

- One idea per slide
- Max 5-7 bullet points (prefer fewer)
- Use large numbers and short phrases for impact
- Include speaker notes as HTML comments if the user provides talking points
- Data slides: one chart/table per slide, clearly labeled
- Title slides: bold statement or question, minimal text

---

## Charts (CSS-only bar charts)

When generating bar charts, use this pattern to ensure bars render at correct heights:

```css
.bar-chart { display: flex; align-items: flex-end; gap: 12px; height: 120px; }
.bar-group { display: flex; flex-direction: column; align-items: center; justify-content: flex-end; flex: 1; height: 100%; }
.bar { width: 100%; border-radius: 4px 4px 0 0; }
```

Critical: `.bar-group` MUST have `height: 100%` and `justify-content: flex-end` — without this, percentage heights on `.bar` elements won't render (they need an explicitly-sized parent).

---

## Output

1. Generate the slide deck file(s)
2. Open in browser: `open <filename>.html`
3. Report: number of slides, style used, file location
4. Offer: "Want me to adjust any slides, change the style, or add speaker notes?"
