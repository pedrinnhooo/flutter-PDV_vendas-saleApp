// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../../string_scanner-1.0.5/lib/string_scanner.dart';

import 'case_insensitive_map.dart';
import 'scan.dart';
import 'utils.dart';

/// A single challenge in a WWW-Authenticate header, parsed as per [RFC 2617][].
///
/// [RFC 2617]: http://tools.ietf.org/html/rfc2617
///
/// Each WWW-Authenticate header contains one or more challenges, representing
/// valid ways to authenticate with the server.
class AuthenticationChallenge {
  /// The scheme describing the type of authentication that's required, for
  /// example "basic" or "digest".
  ///
  /// This is normalized to always be lower-case.
  final String scheme;

  /// The parameters describing how to authenticate.
  ///
  /// The semantics of these parameters are scheme-specific. The keys of this
  /// map are case-insensitive.
  final Map<String, String> parameters;

  /// Parses a WWW-Authenticate header, which should contain one or more
  /// challenges.
  ///
  /// Throws a [FormatException] if the header is invalid.
  static List<AuthenticationChallenge> parseHeader(String header) {
    return wrapFormatException("authentication header", header, () {
      var scanner = new StringScanner(header);
      scanner.scan(whitespace);
      var challenges = parseList(scanner, () {
        var scheme = _scanScheme(scanner, whitespaceName: '" " or "="');

        // Manually parse the inner list. We need to do some lookahead to
        // disambiguate between an auth param and another challenge.
        var params = <String, String>{};

        // Consume initial empty values.
        while (scanner.scan(",")) {
          scanner.scan(whitespace);
        }

        _scanAuthParam(scanner, params);

        var beforeComma = scanner.position;
        while (scanner.scan(",")) {
          scanner.scan(whitespace);

          // Empty elements are allowed, but excluded from the results.
          if (scanner.matches(",") || scanner.isDone) continue;

          scanner.expect(token, name: "a token");
          var name = scanner.lastMatch[0];
          scanner.scan(whitespace);

          // If there's no "=", then this is another challenge rather than a
          // parameter for the current challenge.
          if (!scanner.scan('=')) {
            scanner.position = beforeComma;
            break;
          }

          scanner.scan(whitespace);

          if (scanner.scan(token)) {
            params[name] = scanner.lastMatch[0];
          } else {
            params[name] =
                expectQuotedString(scanner, name: "a token or a quoted string");
          }

          scanner.scan(whitespace);
          beforeComma = scanner.position;
        }

        return new AuthenticationChallenge(scheme, params);
      });

      scanner.expectDone();
      return challenges;
    });
  }

  /// Parses a single WWW-Authenticate challenge value.
  ///
  /// Throws a [FormatException] if the challenge is invalid.
  factory AuthenticationChallenge.parse(String challenge) {
    return wrapFormatException("authentication challenge", challenge, () {
      var scanner = new StringScanner(challenge);
      scanner.scan(whitespace);
      var scheme = _scanScheme(scanner);

      var params = <String, String>{};
      parseList(scanner, () => _scanAuthParam(scanner, params));

      scanner.expectDone();
      return new AuthenticationChallenge(scheme, params);
    });
  }

  /// Scans a single scheme name and asserts that it's followed by a space.
  ///
  /// If [whitespaceName] is passed, it's used as the name for exceptions thrown
  /// due to invalid trailing whitespace.
  static String _scanScheme(StringScanner scanner, {String whitespaceName}) {
    scanner.expect(token, name: "a token");
    var scheme = scanner.lastMatch[0].toLowerCase();

    scanner.scan(whitespace);

    // The spec specifically requires a space between the scheme and its
    // params.
    if (scanner.lastMatch == null || !scanner.lastMatch[0].contains(" ")) {
      scanner.expect(" ", name: whitespaceName);
    }

    return scheme;
  }

  /// Scans a single authentication parameter and stores its result in [params].
  static void _scanAuthParam(StringScanner scanner, Map params) {
    scanner.expect(token, name: "a token");
    var name = scanner.lastMatch[0];
    scanner.scan(whitespace);
    scanner.expect('=');
    scanner.scan(whitespace);

    if (scanner.scan(token)) {
      params[name] = scanner.lastMatch[0];
    } else {
      params[name] =
          expectQuotedString(scanner, name: "a token or a quoted string");
    }

    scanner.scan(whitespace);
  }

  /// Creates a new challenge value with [scheme] and [parameters].
  AuthenticationChallenge(this.scheme, Map<String, String> parameters)
      : parameters =
            new UnmodifiableMapView(new CaseInsensitiveMap.from(parameters));
}
