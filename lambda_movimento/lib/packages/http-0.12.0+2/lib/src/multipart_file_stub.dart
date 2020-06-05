// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import '../../../http_parser-3.1.3/lib/http_parser.dart';

import 'multipart_file.dart';

Future<MultipartFile> multipartFileFromPath(String field, String filePath,
        {String filename, MediaType contentType}) =>
    throw UnsupportedError(
        'MultipartFile is only supported where dart:io is available.');
