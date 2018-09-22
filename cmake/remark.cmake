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

function(validate_unparsed prefix)
    if(${prefix}_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "Invalid arguments '${${prefix}_UNPARSED_ARGUMENTS}' for target '${target}'")
    endif()
endfunction()

function(validate_argument_exists prefix arg)
    if(NOT ${prefix}_${arg})
        message(FATAL_ERROR "${arg} not provided for target '${target}'")
    endif()
endfunction()

function(validate_arguments_exists prefix)
    foreach(arg ${ARGN})
        validate_argument_exists(${prefix} ${arg})
    endforeach()
endfunction()

function(validate_remark_taget target)
    if(NOT TARGET ${target})
        message(FATAL_ERROR "'${target}' is not a target")
    endif()
    get_target_property(remark_type ${target} REMARK_TYPE)
    if(remark_type IN_LIST [ARGN])
        message(FATAL_ERROR "'${target}' is not a valid target type")
    endif()
endfunction()

function(file_list_add_base_dir_and_validate output_list base_dir)
    foreach(f ${ARGN})
        get_filename_component(f ${f} ABSOLUTE BASE_DIR ${base_dir})
        if(NOT EXISTS ${f})
            message(FATAL_ERROR "${f} not found for target '${target}'")
        endif()
        list(APPEND list ${f})
    endforeach()
    set(${output_list} ${list} PARENT_SCOPE)
endfunction()

function(resources_append output_list base_dir)
    list(APPEND list ${${output_list}} ${base_dir})
    foreach(f ${ARGN})
        file(RELATIVE_PATH f ${base_dir} ${f})
        list(APPEND list ${f})
    endforeach()
    set(${output_list} ${list} PARENT_SCOPE)
endfunction()

function(quote output_list)
    string(REPLACE ";" "\" \"" list "${ARGN}")
    set(${output_list} \"${list}\" PARENT_SCOPE)
endfunction()


#
# add_remark_engine(TargetName
#                   ENGINE file
#                   HTML_TEMPLATE file.html.in
#                   [RESOURCES resource...])
#
function(add_remark_engine target)
    # parse arguments
    set(options)
    set(oneValueArgs ENGINE HTML_TEMPLATE)
    set(multiValueArgs RESOURCES)
    cmake_parse_arguments(add_remark_engine "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # validate and process arguments
    validate_unparsed(add_remark_engine)
    validate_arguments_exists(add_remark_engine ENGINE HTML_TEMPLATE)
    file_list_add_base_dir_and_validate(add_remark_engine_ENGINE        ${CMAKE_CURRENT_LIST_DIR} ${add_remark_engine_ENGINE})
    file_list_add_base_dir_and_validate(add_remark_engine_HTML_TEMPLATE ${CMAKE_CURRENT_LIST_DIR} ${add_remark_engine_HTML_TEMPLATE})
    file_list_add_base_dir_and_validate(add_remark_engine_RESOURCES     ${CMAKE_CURRENT_LIST_DIR} ${add_remark_engine_RESOURCES})

    # add custom target and its properties
    add_custom_target(${target}
        DEPENDS
            ${add_remark_engine_ENGINE}
            ${add_remark_engine_RESOURCES}
        SOURCES
            ${add_remark_engine_HTML_TEMPLATE}
            ${add_remark_engine_RESOURCES}
    )
    set_target_properties(${target}
        PROPERTIES
            REMARK_TYPE ENGINE
            REMARK_DIR ${CMAKE_CURRENT_LIST_DIR}
            HTML_TEMPLATE ${add_remark_engine_HTML_TEMPLATE}
    )

    # set the list of resources as target's property
    resources_append(resources ${CMAKE_CURRENT_LIST_DIR} ${add_remark_engine_ENGINE} ${add_remark_engine_RESOURCES})
    set_property(TARGET ${target} PROPERTY RESOURCES ${resources})
endfunction()


#
# add_remark_style(TargetName
#                  DEPENDS engine_or_parent_style
#                  [HTML_TEMPLATE file.html.in]
#                  [BASE_DIR dir]
#                  SOURCES src1 [src2...]
#                  [RESOURCES resource...])
#
function(add_remark_style target)
    # parse arguments
    set(options)
    set(oneValueArgs DEPENDS HTML_TEMPLATE BASE_DIR)
    set(multiValueArgs SOURCES RESOURCES)
    cmake_parse_arguments(add_remark_style "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # validate and process arguments
    validate_unparsed(add_remark_style)
    validate_arguments_exists(add_remark_style DEPENDS SOURCES)
    validate_remark_taget(${add_remark_style_DEPENDS} STYLE ENGINE)
    if(add_remark_style_HTML_TEMPLATE)
        file_list_add_base_dir_and_validate(add_remark_style_HTML_TEMPLATE ${CMAKE_CURRENT_LIST_DIR} ${add_remark_style_HTML_TEMPLATE})
    else()
        # import from DEPENDS
        get_target_property(html_template ${add_remark_style_DEPENDS} HTML_TEMPLATE)
        set(add_remark_style_HTML_TEMPLATE ${html_template})
    endif()
    if(add_remark_style_BASE_DIR)
        file_list_add_base_dir_and_validate(add_remark_style_BASE_DIR ${CMAKE_CURRENT_LIST_DIR} ${add_remark_style_BASE_DIR})
    else()
        set(add_remark_style_BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    endif()
    list(GET add_remark_style_SOURCES 0 main_style)
    file_list_add_base_dir_and_validate(add_remark_style_SOURCES   ${add_remark_style_BASE_DIR} ${add_remark_style_SOURCES})
    file_list_add_base_dir_and_validate(add_remark_style_RESOURCES ${add_remark_style_BASE_DIR} ${add_remark_style_RESOURCES})

    # add custom target and its properties
    add_custom_target(${target}
        DEPENDS
            ${add_remark_style_DEPENDS}
            ${add_remark_style_SOURCES}
            ${add_remark_style_RESOURCES}
        SOURCES
            ${add_remark_style_SOURCES}
            ${add_remark_style_RESOURCES}
            ${add_remark_style_HTML_TEMPLATE}
    )
    set_target_properties(${target}
        PROPERTIES
            REMARK_TYPE STYLE
            MAIN_STYLE ${main_style}
            HTML_TEMPLATE ${add_remark_style_HTML_TEMPLATE}
    )

    # prepare and set the list of target's resources
    get_target_property(resources ${add_remark_style_DEPENDS} RESOURCES)
    resources_append(resources ${add_remark_style_BASE_DIR} ${add_remark_style_SOURCES} ${add_remark_style_RESOURCES})
    set_property(TARGET ${target} PROPERTY RESOURCES ${resources})
endfunction()


#
# add_remark_language(TargetName
#                  [BASE_DIR dir]
#                  SOURCES src1 [src2...])
#
function(add_remark_language target)
    # parse arguments
    set(options)
    set(oneValueArgs BASE_DIR)
    set(multiValueArgs SOURCES)
    cmake_parse_arguments(add_remark_language "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # validate and process arguments
    validate_unparsed(add_remark_language)
    if(add_remark_language_BASE_DIR)
        file_list_add_base_dir_and_validate(add_remark_language_BASE_DIR ${CMAKE_CURRENT_LIST_DIR} ${add_remark_language_BASE_DIR})
    else()
        set(add_remark_language_BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    endif()
    list(GET add_remark_language_SOURCES 0 file)
    file_list_add_base_dir_and_validate(add_remark_language_SOURCES ${add_remark_language_BASE_DIR} ${add_remark_language_SOURCES})

    # add custom target and its properties
    add_custom_target(${target}
        DEPENDS
            ${add_remark_language_SOURCES}
        SOURCES
            ${add_remark_language_SOURCES}
    )
    set_target_properties(${target}
        PROPERTIES
            REMARK_TYPE LANGUAGE
            FILE ${file}
        )

    # prepare and set the list of target's resources
    resources_append(resources ${add_remark_language_BASE_DIR} ${add_remark_language_SOURCES})
    set_property(TARGET ${target} PROPERTY RESOURCES ${resources})
endfunction()


#
# add_remark_chapter(TargetName
#                    [BASE_DIR dir]
#                    MARKDOWN_SLIDES file.md [file2.md...]
#                    [RESOURCES resource...])
#
function(add_remark_chapter target)
    # parse arguments
    set(options)
    set(oneValueArgs BASE_DIR)
    set(multiValueArgs MARKDOWN_SLIDES RESOURCES)
    cmake_parse_arguments(add_remark_chapter "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # validate and process arguments
    validate_unparsed(add_remark_chapter)
    validate_arguments_exists(add_remark_chapter MARKDOWN_SLIDES)
    if(add_remark_chapter_BASE_DIR)
        file_list_add_base_dir_and_validate(add_remark_chapter_BASE_DIR ${CMAKE_CURRENT_LIST_DIR} ${add_remark_chapter_BASE_DIR})
    else()
        set(add_remark_chapter_BASE_DIR ${CMAKE_CURRENT_LIST_DIR})
    endif()
    file_list_add_base_dir_and_validate(add_remark_chapter_MARKDOWN_SLIDES ${add_remark_chapter_BASE_DIR} ${add_remark_chapter_MARKDOWN_SLIDES})
    file_list_add_base_dir_and_validate(add_remark_chapter_RESOURCES       ${add_remark_chapter_BASE_DIR} ${add_remark_chapter_RESOURCES})

    # add custom target and its properties
    add_custom_target(${target}
        DEPENDS
            ${add_remark_chapter_MARKDOWN_SLIDES}
            ${add_remark_chapter_RESOURCES}
        SOURCES
            ${add_remark_chapter_MARKDOWN_SLIDES}
            ${add_remark_chapter_RESOURCES}
    )

    # set the list of target's markdown slides
    set_property(TARGET ${target} PROPERTY MARKDOWN_SLIDES ${add_remark_chapter_MARKDOWN_SLIDES})

    # prepare and set the list of target's resources
    resources_append(resources ${add_remark_chapter_BASE_DIR} ${add_remark_chapter_RESOURCES})
    set_property(TARGET ${target} PROPERTY RESOURCES ${resources})
endfunction()


#
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
#
function(add_remark_slides target)
    # parse arguments
    set(options ALL HANDOUTS)
    set(oneValueArgs NAME TITLE STYLE HTML_TEMPLATE STYLE_TEMPLATE SCRIPT)
    set(multiValueArgs CHAPTERS MARKDOWN_SLIDES LANGUAGES RESOURCES)
    cmake_parse_arguments(add_remark_slides "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # validate arguments
    validate_unparsed(add_remark_slides)
    validate_arguments_exists(add_remark_slides NAME STYLE)
    validate_remark_taget(${add_remark_slides_STYLE} STYLE)
    if(NOT add_remark_slides_TITLE)
        set(add_remark_slides_TITLE ${add_remark_slides_NAME})
    endif()
    if(add_remark_slides_HTML_TEMPLATE)
        file_list_add_base_dir_and_validate(add_remark_slides_HTML_TEMPLATE ${CMAKE_CURRENT_LIST_DIR} ${add_remark_slides_HTML_TEMPLATE})
    else()
        # import from STYLE
        get_target_property(html_template ${add_remark_slides_STYLE} HTML_TEMPLATE)
        set(add_remark_slides_HTML_TEMPLATE ${html_template})
    endif()
    if(add_remark_slides_STYLE_TEMPLATE)
        file_list_add_base_dir_and_validate(add_remark_slides_STYLE_TEMPLATE ${CMAKE_CURRENT_LIST_DIR} ${add_remark_slides_STYLE_TEMPLATE})
    endif()
    if(NOT add_remark_slides_MARKDOWN_SLIDES AND NOT add_remark_slides_CHAPTERS)
        message(FATAL_ERROR "MARKDOWN_SLIDES or CHAPTERS not provided for '${target}'")
    endif()
    if(add_remark_slides_MARKDOWN_SLIDES)
        file_list_add_base_dir_and_validate(add_remark_slides_MARKDOWN_SLIDES ${CMAKE_CURRENT_LIST_DIR} ${add_remark_slides_MARKDOWN_SLIDES})
    endif()
    foreach(l ${add_remark_slides_LANGUAGES})
        validate_remark_taget(${l} LANGUAGE)
    endforeach()

    if(add_remark_slides_RESOURCES)
        file_list_add_base_dir_and_validate(add_remark_slides_RESOURCES ${CMAKE_CURRENT_LIST_DIR} ${add_remark_slides_RESOURCES})
    endif()
    if(add_remark_slides_ALL)
        set(all ALL)
    endif()

    set(dest_dir ${CMAKE_BINARY_DIR}/out/${add_remark_slides_NAME})

    # prepare the list of markdown files
    foreach(ch ${add_remark_slides_CHAPTERS})
        get_target_property(md ${ch} MARKDOWN_SLIDES)
        list(APPEND md_slides ${md})
    endforeach()
    list(APPEND md_slides ${add_remark_slides_MARKDOWN_SLIDES})

    # define custom command to generate slides
    add_custom_command(OUTPUT ${dest_dir}/${add_remark_slides_NAME}.html
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake
        COMMAND ${CMAKE_COMMAND} -E touch ${dest_dir}/${add_remark_slides_NAME}.html
        DEPENDS
            ${CMAKE_CURRENT_LIST_FILE}
            ${add_remark_slides_STYLE}
            ${add_remark_slides_HTML_TEMPLATE}
            ${add_remark_slides_STYLE_TEMPLATE}
            ${add_remark_slides_CHAPTERS}
            ${add_remark_slides_LANGUAGES}
            ${add_remark_slides_RESOURCES}
            ${md_slides}
        COMMENT "Generating '${add_remark_slides_TITLE}' slides"
    )

    # add custom target
    add_custom_target(${target} ${all}
        DEPENDS
            ${dest_dir}/${add_remark_slides_NAME}.html
        SOURCES
            ${add_remark_slides_HTML_TEMPLATE}
            ${add_remark_slides_STYLE_TEMPLATE}
            ${add_remark_slides_MARKDOWN_SLIDES}
            ${add_remark_slides_RESOURCES}
    )

    # prepare the list of target's resources
    get_target_property(resources ${add_remark_slides_STYLE} RESOURCES)
    foreach(ch ${add_remark_slides_CHAPTERS})
        get_target_property(res ${ch} RESOURCES)
        list(APPEND resources ${res})
    endforeach()
    foreach(l ${add_remark_slides_LANGUAGES})
        get_target_property(res ${l} RESOURCES)
        list(APPEND resources ${res})
    endforeach()
    resources_append(resources ${CMAKE_CURRENT_SOURCE_DIR} ${add_remark_slides_RESOURCES})

    get_target_property(style ${add_remark_slides_STYLE} MAIN_STYLE)

    # add quotes to all variables defined in the script
    quote(dest_dir ${dest_dir})
    quote(md_slides ${md_slides})
    quote(resources ${resources})
    quote(add_remark_slides_TITLE ${add_remark_slides_TITLE})
    quote(style ${style})
    if(add_remark_slides_STYLE_TEMPLATE)
        quote(add_remark_slides_STYLE_TEMPLATE ${add_remark_slides_STYLE_TEMPLATE})
    endif()
    quote(add_remark_slides_HTML_TEMPLATE ${add_remark_slides_HTML_TEMPLATE})

    # generate script
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "
set(dest_dir ${dest_dir})
set(resources ${resources})
set(md_slides ${md_slides})

# copy resources
foreach(res \${resources})
    if(IS_DIRECTORY \${res})
        set(src_dir \${res}/)
    else()
        set(src_file \${src_dir}\${res})
        get_filename_component(dst_dir \${dest_dir}/\${res} DIRECTORY)
        file(INSTALL \${src_file} DESTINATION \${dst_dir})
    endif()
endforeach()

# concatenate slides into one big file
file(WRITE slides.md)
foreach(md_file \${md_slides})
    file(READ \${md_file} md_content)
    file(APPEND slides.md \"\${md_content}\")
endforeach()

# set variables used in configure file
set(REMARK_TITLE ${add_remark_slides_TITLE})
set(REMARK_STYLE ${style})
set(REMARK_SCRIPT \"${script}\")
file(READ slides.md REMARK_CONTENT)
")

    if(add_remark_slides_LANGUAGES)
        file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "
set(REMARK_LANGUAGES \"")
        foreach(l ${add_remark_slides_LANGUAGES})
            get_target_property(f ${l} FILE)
            file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "<script src=\\\"${f}\\\"></script>
		")
        endforeach()
        file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "\")
")
    endif()

    if(add_remark_slides_STYLE_TEMPLATE)
        file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "
# generate style file
message(STATUS \"Generating '\${dest_dir}/style.css'\")
configure_file(${add_remark_slides_STYLE_TEMPLATE} \${dest_dir}/style.css @ONLY)
set(REMARK_STYLE style.css)
")
    endif()

    file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "
# generate output file with slides
message(STATUS \"Generating '\${dest_dir}/${add_remark_slides_NAME}.html'\")
configure_file(${add_remark_slides_HTML_TEMPLATE} \${dest_dir}/${add_remark_slides_NAME}.html @ONLY)
")
    if(add_remark_slides_HANDOUTS)
        file(APPEND ${CMAKE_CURRENT_BINARY_DIR}/gen_slides.cmake "
# generate handouts
message(STATUS \"Generating '\${dest_dir}/handouts.html'\")
string(REPLACE \"exclude: handouts\" \"exclude: true\" REMARK_CONTENT \"\${REMARK_CONTENT}\")
string(REPLACE \"count: false\" \"count: true\" REMARK_CONTENT \"\${REMARK_CONTENT}\")
string(REGEX REPLACE \"\\r?\\n--\\r?\\n\" \"\" REMARK_CONTENT \"\${REMARK_CONTENT}\")
configure_file(${add_remark_slides_HTML_TEMPLATE} \${dest_dir}/handouts.html @ONLY)
")
    endif()
endfunction()
