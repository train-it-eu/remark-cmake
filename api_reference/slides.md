class: title-slide

# cmake.remark API Reference

## `https://github.com/train-it-eu/remark-cmake`

Mateusz Pusz  
September 27, 2018

---
# `add_remark_engine()`

```cmake
# add_remark_engine(TargetName
#                   ENGINE file
#                   HTML_TEMPLATE file.html.in
#                   [RESOURCES resource...])
```

- Defines a _remark engine_
- `ENGINE` - path to a `remark.js` engine
- `HTML_TEMPLATE` - default HTML template to be used for slides generation
- `RESOURCES` - various dependencies used by your slide deck template (scripts, images, etc)

---

# `add_remark_engine()` example

```cmake
add_remark_engine(default_engine
    ENGINE scripts/remark-latest.min.js
    HTML_TEMPLATE template.html.in
    RESOURCES
        favicon.ico
        scripts/jquery.min.js
        scripts/laser_ptr.js
)
```

---

# `add_remark_style()`

```cmake
# add_remark_style(TargetName
#                  DEPENDS engine_or_parent_style
#                  [HTML_TEMPLATE file.html.in]
#                  [BASE_DIR dir]
#                  SOURCES src1 [src2...]
#                  [RESOURCES resource...])
```

- Defines _presentation style and slide layout_
- Hierarchical approach
- `DEPENDS` - name of a target created with `add_remark_engine()` or `add_remark_style()`
- `HTML_TEMPLATE` - style can overwrite a default HTML template defined by the engine
- `BASE_DIR` - subdirectory to prepend to every `SOURCE` and `RESOURCE`
- `SOURCES` - CSS files to use for the style
- `RESOURCES` - additional files used by the style (images, fonts, etc)

---

# `add_remark_style()` example

```cmake
add_remark_style(remark-style-base
    DEPENDS default_engine
    SOURCES
        css/base.css
)
```

```cmake
add_remark_style(remark-style-default
    DEPENDS remark-style-base
    SOURCES
        css/default.css
        css/default_colors.css
)
```

---

# `add_remark_language()`

```cmake
# add_remark_language(TargetName
#                  [BASE_DIR dir]
#                  SOURCES src1 [src2...])
```

- Defines/Overwrites _highlighting_ for specific language
- `BASE_DIR` - subdirectory to prepend to every `SOURCE`
- `SOURCES` - JavaScript files with highlighting definition

---

# `add_remark_language()` example

```cmake
add_remark_language(remark-language-cmake
    SOURCES
        scripts/cmake.language.js
)
```

---

# `add_remark_slides()`

```cmake
# add_remark_slides(TargetName [ALL] [HANDOUTS]
#                   NAME name
#                   [TITLE title]
#                   STYLE style
#                   [HTML_TEMPLATE file.html.in]
#                   [STYLE_TEMPLATE file.css.in]
#                   [SCRIPT java_script]
#                   [CHAPTERS chapter...]
#                   [MARKDOWN_SLIDES file.md...]
#                   [LANGUAGES language...])
#                   [RESOURCES resource...])
```

- Defines _one presentation_

---

# `add_remark_slides()`

- `ALL` - defines that the CMake target should be built by default
- `HANDOUTS` - generates presentation handouts (no animations, some slides can be excluded) 
- `NAME` - name of the output directory and HTML file
- `TITLE` - title visible in a tab browser
- `STYLE` - name of a style target created with `add_remark_style()`
- `HTML_TEMPLATE` - each presentation can overwrite a default HTML template
- `STYLE_TEMPLATE` - presentation specific customization of `STYLE` 
- `SCRIPT` - custom JavaScript to be used with that presentation
- `CHAPTERS` - names of chapter targets created with `add_remark_chapter()`
- `MARKDOWN_SLIDES` - markdown files to aggregate in a presenation (if chapters are not used)
- `LANGUAGES` - name of language target created with `add_remark_language()`
- `RESOURCES` - resources used by the presentation (i.e. images)

---

# `add_remark_slides()` example

```cmake
add_remark_slides(example_presentation ALL
    NAME "Slides_about_CMake_with_CMake"
    TITLE "How to create slides about CMake with CMake?"
    STYLE remark-style-default
    STYLE_TEMPLATE style.css.in
    MARKDOWN_SLIDES slides.md
    LANGUAGES
        remark-language-cmake
    RESOURCES
        img/questions.jpg
        img/train-it.png
        img/warning.png
)
```

---

# `add_remark_chapter()`

```cmake
# add_remark_chapter(TargetName
#                    [BASE_DIR dir]
#                    MARKDOWN_SLIDES file.md [file2.md...]
#                    [RESOURCES resource...])
```

- `BASE_DIR` - subdirectory to prepend to every `MARKDOWN_SLIDE` and `RESOURCE`
- `MARKDOWN_SLIDES` - markdown files to be aggregated into a presentation chapter
- `RESOURCES` - resources used by the presentation chapter (i.e. images)

---

class: small-code

# `add_remark_chapter()` example

.left-column[
```cmake
set(TRAINING_NAME "api_reference")

add_remark_chapter(${TRAINING_NAME}_chapter_title
    BASE_DIR "1 - Title"
    MARKDOWN_SLIDES
        slides.md
)

add_remark_chapter(${TRAINING_NAME}_chapter_api
    BASE_DIR "2 - API Reference"
    MARKDOWN_SLIDES
        slides.md
)

add_remark_chapter(${TRAINING_NAME}_chapter_end
    BASE_DIR "3 - End"
    MARKDOWN_SLIDES
        slides.md
    RESOURCES
        img/warning.png
)
```
]

--

.right-column[
```cmake
add_remark_slides(${TRAINING_NAME} ALL HANDOUTS
    NAME ${TRAINING_NAME}
    TITLE "cmake.remark API Reference"
    STYLE remark-style-default
    STYLE_TEMPLATE style.css.in
    LANGUAGES
        remark-language-cmake
*   CHAPTERS
*       ${TRAINING_NAME}_chapter_title
*       ${TRAINING_NAME}_chapter_api
*       ${TRAINING_NAME}_chapter_end
)
```
]


---

class: small-code

# Handouts generation

.left-column[
## Original

```markdown
# Slide with animation

This part

--

and this part

--

will not generate separate slides in handouts

---

exclude: handouts

# Slide that should not be included in handouts

This slide wil not be included in handouts

---

# Next slide
```
]

.right-column[
## Handouts

```markdown
# Slide with animation

This part

and this part

will not generate separate slides in handouts

---

# Next slide
```

- Handouts generator removes
  - all `--` animation breaks
  - whole slides with `exclude: handouts`
- Useful for PDF files generation
]

---

# More info?

.info[
**https://github.com/train-it-eu/remark-cmake**
]

- **`remark.cmake`** script
- Source of _that presentation_
- Presentation with _API Reference_
- Example _style and layout_
- Simple JavaScript scripts (i.e. _laser_)
- Custom _highlighting for CMake_ language

---
class: section-title-slide
background-image: url(img/warning.png)
<!-- https://openclipart.org/detail/18736/programming-addictive-sign -->
