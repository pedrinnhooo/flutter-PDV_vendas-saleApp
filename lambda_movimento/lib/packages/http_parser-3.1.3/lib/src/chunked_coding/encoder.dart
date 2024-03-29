// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

import '../../../../charcode-1.1.2/lib/ascii.dart';

/// The canonical instance of [ChunkedCodingEncoder].
const chunkedCodingEncoder = const ChunkedCodingEncoder._();

/// The chunk indicating that the chunked message has finished.
final _doneChunk = new Uint8List.fromList([$0, $cr, $lf, $cr, $lf]);

/// A converter that encodes byte arrays into chunks with size tags.
class ChunkedCodingEncoder extends Converter<List<int>, List<int>> {
  const ChunkedCodingEncoder._();

  List<int> convert(List<int> bytes) =>
      _convert(bytes, 0, bytes.length, isLast: true);

  ByteConversionSink startChunkedConversion(Sink<List<int>> sink) =>
      new _Sink(sink);
}

/// A conversion sink for the chunked transfer encoding.
class _Sink extends ByteConversionSinkBase {
  /// The underlying sink to which encoded byte arrays will be passed.
  final Sink<List<int>> _sink;

  _Sink(this._sink);

  void add(List<int> chunk) {
    _sink.add(_convert(chunk, 0, chunk.length));
  }

  void addSlice(List<int> chunk, int start, int end, bool isLast) {
    RangeError.checkValidRange(start, end, chunk.length);
    _sink.add(_convert(chunk, start, end, isLast: isLast));
    if (isLast) _sink.close();
  }

  void close() {
    _sink.add(_doneChunk);
    _sink.close();
  }
}

/// Returns a new list a chunked transfer encoding header followed by the slice
/// of [bytes] from [start] to [end].
///
/// If [isLast] is `true`, this adds the footer that indicates that the chunked
/// message is complete.
List<int> _convert(List<int> bytes, int start, int end, {bool isLast: false}) {
  if (end == start) return isLast ? _doneChunk : const [];

  var size = end - start;
  var sizeInHex = size.toRadixString(16);
  var footerSize = isLast ? _doneChunk.length : 0;

  // Add 4 for the CRLF sequences that follow the size header and the bytes.
  var list = new Uint8List(sizeInHex.length + 4 + size + footerSize);
  list.setRange(0, sizeInHex.length, sizeInHex.codeUnits);

  var cursor = sizeInHex.length;
  list[cursor++] = $cr;
  list[cursor++] = $lf;
  list.setRange(cursor, cursor + end - start, bytes, start);
  cursor += end - start;
  list[cursor++] = $cr;
  list[cursor++] = $lf;

  if (isLast) {
    list.setRange(list.length - footerSize, list.length, _doneChunk);
  }
  return list;
}
