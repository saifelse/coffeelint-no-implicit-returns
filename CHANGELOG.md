## 0.0.6

Bug fixes:
  - Avoid calling `class.walkBody` as this mutates the AST, causing issues in
    other lint rules (#11). See:
    [coffeescope#12](https://github.com/za-creature/coffeescope/issues/12)

## 0.0.5

Bug fixes:
  - Warn on functions that end on non-pure loops and switches

Housekeeping:
  - Add repository field to package.json
  - Add index.js instead of assuming .coffee extension is registered
