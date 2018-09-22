/*
Language: CMake
Description: CMake is an open-source cross-platform system for build automation.
Author: Mateusz Pusz <mateusz.pusz@train-it.eu>
Website: https://train-it.eu
*/
hljs.registerLanguage('cmake',
    function(hljs) {
        var VARIABLE = {
                className: 'variable',
                begin: '\\${', end: '}'
        },
        VERSION = {
            className: 'number',
            begin: '\\b\\d+(\\.\\d+)+',
            relevance:0
        },
        FUNCTION_TITLE = hljs.IDENT_RE + '\\s*\\(',
        FUNCTION = {
            className: 'function',
            begin: FUNCTION_TITLE, returnBegin: true,
            end: '\\)', returnEnd: true,
            illegal: /[^\w\s\*&]/,
            contains: [
                {
                    begin: FUNCTION_TITLE, returnBegin: true,
                    contains: [hljs.TITLE_MODE],
                    relevance: 0
                },
                {
                    className: 'params',
                    begin: /\(/,
                    end: /\)/, returnEnd: true,
                    keywords: {
                        tag: 'PRIVATE PUBLIC INTERFACE ALIAS VERSION REQUIRED MODULE CONFIG TARGET TARGETS EXPORT ' +
                        'LIBRARY ARCHIVE RUNTIME INCLUDES FILE FILES NAMESPACE DIRECTORY COMPATIBILITY EXISTS ' +
                        'DESTINATION NOT NAME COMMAND STREQUAL IF BUILD_INTERFACE INSTALL_INTERFACE'
                    },
                    relevance: 0,
                    contains: [
                        VARIABLE,
                        VERSION,
                        hljs.QUOTE_STRING_MODE,
                        hljs.NUMBER_MODE,
                        hljs.HASH_COMMENT_MODE
                    ]
                }
            ]
        };

        return {
            aliases: ['cmake.in'],
            case_insensitive: false,
            keywords: {
                title:
                'add_compile_options add_custom_command add_custom_target add_definitions ' +
                'add_dependencies add_executable add_library add_subdirectory add_test ' +
                'aux_source_directory break build_command cmake_host_system_information ' +
                'cmake_minimum_required cmake_parse_arguments cmake_policy configure_file ' +
                'continue create_test_sourcelist define_property else elseif enable_language ' +
                'enable_testing endforeach endfunction endif endmacro endwhile execute_process ' +
                'export file find_file find_library find_package find_path find_program ' +
                'fltk_wrap_ui foreach function get_cmake_property get_directory_property ' +
                'get_filename_component get_property get_source_file_property get_target_property ' +
                'get_test_property if include include_directories include_external_msproject ' +
                'include_guard include_regular_expression install link_directories list load_cache ' +
                'macro mark_as_advanced math message option project qt_wrap_cpp qt_wrap_ui ' +
                'remove_definitions return separate_arguments set set_directory_properties ' +
                'set_property set_source_files_properties set_target_properties set_tests_properties ' +
                'site_name source_group string target_compile_features target_include_directories ' +
                'target_compile_definitions target_compile_features target_compile_options ' +
                'target_include_directories target_link_libraries target_sources try_compile try_run ' +
                'unset variable_watch while ' +
                'build_name exec_program export_library_dependencies install_files install_programs ' +
                'install_targets link_libraries load_command make_directory output_required_files ' +
                'remove subdir_depends subdirs use_mangled_mesa utility_source variable_requires ' +
                'write_file'
            },
            contains: [
                FUNCTION,
                hljs.HASH_COMMENT_MODE
            ]
        };
    }
);
