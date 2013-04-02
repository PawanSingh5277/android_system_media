## -*- coding: utf-8 -*-
/*
 * Copyright (C) 2012 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * !! Do not include this file directly !!
 *
 * Include camera_metadata.h instead.
 */

/**
 * ! Do not edit this file directly !
 *
 * Generated automatically from camera_metadata_tags.mako
 */

/** TODO: Nearly every enum in this file needs a description */

/**
 * Top level hierarchy definitions for camera metadata. *_INFO sections are for
 * the static metadata that can be retrived without opening the camera device.
 * New sections must be added right before ANDROID_SECTION_COUNT to maintain
 * existing enumerations.
 */
typedef enum camera_metadata_section {
  % for i in find_all_sections(metadata):
    ${path_name(i) | csym},
  % endfor
    ANDROID_SECTION_COUNT,

    VENDOR_SECTION = 0x8000
} camera_metadata_section_t;

/**
 * Hierarchy positions in enum space. All vendor extension tags must be
 * defined with tag >= VENDOR_SECTION_START
 */
typedef enum camera_metadata_section_start {
  % for i in find_all_sections(metadata):
    ${path_name(i) + '.start' | csym,ljust(30)} = ${path_name(i) | csym,pad(64)} << 16,
  % endfor
    VENDOR_SECTION_START           = VENDOR_SECTION            << 16
} camera_metadata_section_start_t;

/**
 * Main enum for defining camera metadata tags.  New entries must always go
 * before the section _END tag to preserve existing enumeration values.  In
 * addition, the name and type of the tag needs to be added to
 * system/media/camera/src/camera_metadata_tag_info.c
 */
typedef enum camera_metadata_tag {
    % for sec in find_all_sections(metadata):
      % for idx,entry in enumerate(find_unique_entries(sec)):
        % if idx == 0:
    ${entry.name | csym,ljust(30)} = ${path_name(find_parent_section(entry)) | csym}_START,
        % else:
    ${entry.name | csym},
        % endif
      % endfor
    ${path_name(sec) | csym}_END,

    %endfor
} camera_metadata_tag_t;

/**
 * Enumeration definitions for the various entries that need them
 */

% for sec in find_all_sections(metadata):
  % for entry in find_unique_entries(sec):
    % if entry.enum:
// ${entry.name | csym}
typedef enum camera_metadata_enum_${csym(entry.name).lower()} {
      % for val in entry.enum.values:
        % if val.id is None:
    ${entry.name | csym}_${val.name},
        % else:
    ${'%s_%s'%(csym(entry.name), val.name) | pad(65)} = ${val.id},
        % endif
      % endfor
} camera_metadata_enum_${csym(entry.name).lower()}_t;

    % endif
  % endfor

%endfor
