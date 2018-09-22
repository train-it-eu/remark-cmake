# The MIT License (MIT)
#
# Copyright (c) 2016 train-it.eu
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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

add_remark_slides(${TRAINING_NAME} ALL HANDOUTS
    NAME ${TRAINING_NAME}
    TITLE "cmake.remark API Reference"
    STYLE remark-style-default
    STYLE_TEMPLATE style.css.in
    LANGUAGES
        remark-language-cmake
    CHAPTERS
        ${TRAINING_NAME}_chapter_title
        ${TRAINING_NAME}_chapter_api
        ${TRAINING_NAME}_chapter_end
)
