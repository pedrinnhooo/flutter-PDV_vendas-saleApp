import 'dart:convert';

class ApiGatewayResponse {
  ApiGatewayResponse({
    this.body,
    this.isBase64Encoded,
    this.statusCode,
  });

  final String body;
  final bool isBase64Encoded;
  final int statusCode;

  Map<String, dynamic> toJson() => {
        'body': body,
        'isBase64Encoded': isBase64Encoded,
        'statusCode': statusCode,
      };
}

class ApiGatewayEvent {
  String resource;
  String path;
  String httpMethod;
  Headers headers;
  MultiValueHeaders multiValueHeaders;
  QueryStringParameters queryStringParameters;
  // MultiValueQueryStringParameters multiValueQueryStringParameters;
  PathParameters pathParameters;
  String stageVariables;
  RequestContext requestContext;
  dynamic body;
  bool isBase64Encoded;

  ApiGatewayEvent(
      {this.resource,
      this.path,
      this.httpMethod,
      this.headers,
      this.multiValueHeaders,
      this.queryStringParameters,
      // this.multiValueQueryStringParameters,
      this.pathParameters,
      this.stageVariables,
      this.requestContext,
      this.body,
      this.isBase64Encoded});

  ApiGatewayEvent.fromJson(Map<String, dynamic> json) {
    resource = json['resource'];
    path = json['path'];
    httpMethod = json['httpMethod'];
    headers =
        json['headers'] != null ? new Headers.fromJson(json['headers']) : null;
    multiValueHeaders = json['multiValueHeaders'] != null
        ? new MultiValueHeaders.fromJson(json['multiValueHeaders'])
        : null;
    queryStringParameters = json['queryStringParameters'] != null
        ? new QueryStringParameters.fromJson(json['queryStringParameters'])
        : null;
    // multiValueQueryStringParameters =
    //     json['multiValueQueryStringParameters'] != null
    //         ? new MultiValueQueryStringParameters.fromJson(
    //             json['multiValueQueryStringParameters'])
    //         : null;
    pathParameters = json['pathParameters'] != null
        ? new PathParameters.fromJson(json['pathParameters'])
        : null;
    stageVariables = json['stageVariables'];
    requestContext = json['requestContext'] != null
        ? new RequestContext.fromJson(json['requestContext'])
        : null;
    body = json['body'];
    isBase64Encoded = json['isBase64Encoded'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resource'] = this.resource;
    data['path'] = this.path;
    data['httpMethod'] = this.httpMethod;
    if (this.headers != null) {
      data['header'] = this.headers.toJson();
    }
    if (this.multiValueHeaders != null) {
      data['multiValueHeaders'] = this.multiValueHeaders.toJson();
    }
    if (this.queryStringParameters != null) {
      data['queryStringParameters'] = this.queryStringParameters.toJson();
    }
    // if (this.multiValueQueryStringParameters != null) {
    //   data['multiValueQueryStringParameters'] =
    //       this.multiValueQueryStringParameters.toJson();
    // }
    if (this.pathParameters != null) {
      data['pathParameters'] = this.pathParameters.toJson();
    }
    data['stageVariables'] = this.stageVariables;
    if (this.requestContext != null) {
      data['requestContext'] = this.requestContext.toJson();
    }
    data['body'] = this.body;
    data['isBase64Encoded'] = this.isBase64Encoded;
    return data;
  }
}

class Headers {
  String accept;
  String acceptEncoding;
  String cacheControl;
  String host;
  String postmanToken;
  String authorization;
  String userAgent;
  String xAmznTraceId;
  String xForwardedFor;
  String xForwardedPort;
  String xForwardedProto;

  Headers(
      {this.accept,
      this.acceptEncoding,
      this.cacheControl,
      this.host,
      this.authorization,
      this.postmanToken,
      this.userAgent,
      this.xAmznTraceId,
      this.xForwardedFor,
      this.xForwardedPort,
      this.xForwardedProto});

  Headers.fromJson(Map<String, dynamic> json) {
    print("Header.fromJson");
    print("1");
    accept = json['accept'];
    print("2");
    acceptEncoding = json['accept-encoding'];
    print("3");
    cacheControl = json['cache-control'];
    print("4");
    host = json['Host'];
    print("5");
    authorization = json['Authorization'];
    print("6");
    //postmanToken = json['postman-token'];
    userAgent = json['User-Agent'];
    print("7");
    xAmznTraceId = json['X-Amzn-Trace-Id'];
    print("8");
    xForwardedFor = json['X-Forwarded-For'];
    print("9");
    xForwardedPort = json['X-Forwarded-Port'];
    print("10");
    xForwardedProto = json['X-Forwarded-Proto'];
    print("11");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Accept'] = this.accept;
    data['accept-encoding'] = this.acceptEncoding;
    data['Cache-Control'] = this.cacheControl;
    data['Host'] = this.host;
    data['Authorization'] = this.authorization;
    //data['Postman-Token'] = this.postmanToken;
    data['User-Agent'] = this.userAgent;
    data['X-Amzn-Trace-Id'] = this.xAmznTraceId;
    data['X-Forwarded-For'] = this.xForwardedFor;
    data['X-Forwarded-Port'] = this.xForwardedPort;
    data['X-Forwarded-Proto'] = this.xForwardedProto;
    return data;
  }
}

class MultiValueHeaders {
  List<String> accept;
  List<String> acceptEncoding;
  List<String> cacheControl;
  List<String> host;
  List<String> postmanToken;
  List<String> userAgent;
  List<String> xAmznTraceId;
  List<String> xForwardedFor;
  List<String> xForwardedPort;
  List<String> xForwardedProto;

  MultiValueHeaders(
      {this.accept,
      this.acceptEncoding,
      this.cacheControl,
      this.host,
      this.postmanToken,
      this.userAgent,
      this.xAmznTraceId,
      this.xForwardedFor,
      this.xForwardedPort,
      this.xForwardedProto});

  MultiValueHeaders.fromJson(Map<String, dynamic> json) {
    print("MultiValueHeaders.fromJson");
    print("1");
    accept = json['accept'].cast<String>();
    print("2");
    acceptEncoding = json['accept-encoding'].cast<String>();
    print("3");
    cacheControl = json['cache-control'].cast<String>();
    print("4");
    host = json['Host'].cast<String>();
    print("5");
    //postmanToken = json['postman-token'].cast<String>();
    userAgent = json['User-Agent'].cast<String>();
    print("6");
    xAmznTraceId = json['X-Amzn-Trace-Id'].cast<String>();
    print("7");
    xForwardedFor = json['X-Forwarded-For'].cast<String>();
    print("8");
    xForwardedPort = json['X-Forwarded-Port'].cast<String>();
    print("9");
    xForwardedProto = json['X-Forwarded-Proto'].cast<String>();
    print("10");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Accept'] = this.accept;
    data['accept-encoding'] = this.acceptEncoding;
    data['Cache-Control'] = this.cacheControl;
    data['Host'] = this.host;
    //data['Postman-Token'] = this.postmanToken;
    data['User-Agent'] = this.userAgent;
    data['X-Amzn-Trace-Id'] = this.xAmznTraceId;
    data['X-Forwarded-For'] = this.xForwardedFor;
    data['X-Forwarded-Port'] = this.xForwardedPort;
    data['X-Forwarded-Proto'] = this.xForwardedProto;
    return data;
  }
}

class QueryStringParameters {
  Map<String, dynamic> queryStringParameters;

  QueryStringParameters({this.queryStringParameters});

  QueryStringParameters.fromJson(Map<String, dynamic> json) {
    queryStringParameters = json;
  }

  Map<String, dynamic> toJson() => queryStringParameters;
}

// class MultiValueQueryStringParameters {
//   List<String> q;

//   MultiValueQueryStringParameters({this.q});

//   MultiValueQueryStringParameters.fromJson(Map<String, dynamic> json) {
//     q = json['q'].cast<String>();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['q'] = this.q;
//     return data;
//   }
// }

class PathParameters {
  String path;

  PathParameters({this.path});

  PathParameters.fromJson(Map<String, dynamic> json) {
    path = json[0].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    return data;
  }
}

class RequestContext {
  String resourceId;
  String resourcePath;
  String httpMethod;
  String extendedRequestId;
  String requestTime;
  String path;
  String accountId;
  String protocol;
  String stage;
  String domainPrefix;
  int requestTimeEpoch;
  String requestId;
  Identity identity;
  String domainName;
  String apiId;

  RequestContext(
      {this.resourceId,
      this.resourcePath,
      this.httpMethod,
      this.extendedRequestId,
      this.requestTime,
      this.path,
      this.accountId,
      this.protocol,
      this.stage,
      this.domainPrefix,
      this.requestTimeEpoch,
      this.requestId,
      this.identity,
      this.domainName,
      this.apiId});

  RequestContext.fromJson(Map<String, dynamic> json) {
    resourceId = json['resourceId'];
    resourcePath = json['resourcePath'];
    httpMethod = json['httpMethod'];
    extendedRequestId = json['extendedRequestId'];
    requestTime = json['requestTime'];
    path = json['path'];
    accountId = json['accountId'];
    protocol = json['protocol'];
    stage = json['stage'];
    domainPrefix = json['domainPrefix'];
    requestTimeEpoch = json['requestTimeEpoch'];
    requestId = json['requestId'];
    identity = json['identity'] != null
        ? new Identity.fromJson(json['identity'])
        : null;
    domainName = json['domainName'];
    apiId = json['apiId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['resourceId'] = this.resourceId;
    data['resourcePath'] = this.resourcePath;
    data['httpMethod'] = this.httpMethod;
    data['extendedRequestId'] = this.extendedRequestId;
    data['requestTime'] = this.requestTime;
    data['path'] = this.path;
    data['accountId'] = this.accountId;
    data['protocol'] = this.protocol;
    data['stage'] = this.stage;
    data['domainPrefix'] = this.domainPrefix;
    data['requestTimeEpoch'] = this.requestTimeEpoch;
    data['requestId'] = this.requestId;
    if (this.identity != null) {
      data['identity'] = this.identity.toJson();
    }
    data['domainName'] = this.domainName;
    data['apiId'] = this.apiId;
    return data;
  }
}

class Identity {
  Null cognitoIdentityPoolId;
  Null accountId;
  Null cognitoIdentityId;
  Null caller;
  String sourceIp;
  Null principalOrgId;
  Null accessKey;
  Null cognitoAuthenticationType;
  Null cognitoAuthenticationProvider;
  Null userArn;
  String userAgent;
  Null user;

  Identity(
      {this.cognitoIdentityPoolId,
      this.accountId,
      this.cognitoIdentityId,
      this.caller,
      this.sourceIp,
      this.principalOrgId,
      this.accessKey,
      this.cognitoAuthenticationType,
      this.cognitoAuthenticationProvider,
      this.userArn,
      this.userAgent,
      this.user});

  Identity.fromJson(Map<String, dynamic> json) {
    cognitoIdentityPoolId = json['cognitoIdentityPoolId'];
    accountId = json['accountId'];
    cognitoIdentityId = json['cognitoIdentityId'];
    caller = json['caller'];
    sourceIp = json['sourceIp'];
    principalOrgId = json['principalOrgId'];
    accessKey = json['accessKey'];
    cognitoAuthenticationType = json['cognitoAuthenticationType'];
    cognitoAuthenticationProvider = json['cognitoAuthenticationProvider'];
    userArn = json['userArn'];
    userAgent = json['userAgent'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cognitoIdentityPoolId'] = this.cognitoIdentityPoolId;
    data['accountId'] = this.accountId;
    data['cognitoIdentityId'] = this.cognitoIdentityId;
    data['caller'] = this.caller;
    data['sourceIp'] = this.sourceIp;
    data['principalOrgId'] = this.principalOrgId;
    data['accessKey'] = this.accessKey;
    data['cognitoAuthenticationType'] = this.cognitoAuthenticationType;
    data['cognitoAuthenticationProvider'] = this.cognitoAuthenticationProvider;
    data['userArn'] = this.userArn;
    data['userAgent'] = this.userAgent;
    data['user'] = this.user;
    return data;
  }
}
