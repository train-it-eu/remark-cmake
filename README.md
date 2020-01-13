# remark-cmake
CMake helper to build [remark.js](http://remarkjs.com) based presentations.

## Why?

- Brings benefits for large slide decks
- Slides generation and C++ sample code compilation in one CMake project
- Slides content is orthogonal to presentation layout and style
  - easy to switch different styles for the same content
- Easy reuse of slides and whole chapters
- Handouts generation engine
- Easier to write Markdown in *.md file (instead of *.html)

### Handouts

Handouts generator removes
- all -- animation breaks
- whole slides with exclude: handouts

Useful for PDF files generation

## How?

- Download [remark.cmake](cmake/remark.cmake) script
- Define your favorite presentation style and layout
- If needed, fix or add custom language highlighting
- Prepare presentation content as a Markdown file
- Aggregate all above in one CMake project

## Example presentations

- [How to create slides about CMake with CMake?](https://train-it-eu.github.io/remark-cmake/Slides_about_CMake_with_CMake/Slides_about_CMake_with_CMake.html)
- [cmake.remark API Reference](https://train-it-eu.github.io/remark-cmake/api_reference/api_reference.html)
