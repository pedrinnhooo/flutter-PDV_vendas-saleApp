import 'dart:convert';
import 'dart:io';

import 'apigateway_event.dart';

typedef Handler = Future<Map<String, dynamic>> Function(
  Map<String, dynamic> event,
  Context context,
);

typedef ApiGatewayHandler = Future<ApiGatewayResponse> Function(
  ApiGatewayEvent event,
  Context context,
);

class NextInvocation {
  NextInvocation({
    this.httpClientResponse,
    this.inputData,
  });
  HttpClientResponse httpClientResponse;
  Map<String, dynamic> inputData;
}

class Context {
  Context(
    Map<String, String> environment,
    NextInvocation nextInvocation,
  ) {
    this.functionName = environment["AWS_LAMBDA_FUNCTION_NAME"] ?? '';
    this.functionVersion = environment["AWS_LAMBDA_FUNCTION_VERSION"] ?? '';
    this.logGroupName = environment["AWS_LAMBDA_LOG_GROUP_NAME"] ?? '';
    this.logStreamName = environment["AWS_LAMBDA_LOG_STREAM_NAME"] ?? '';
    this.memoryLimitInMB = environment["AWS_LAMBDA_FUNCTION_MEMORY_SIZE"] ?? '';
    this.awsRequestId = nextInvocation.httpClientResponse.headers
            .value('lambda-runtime-aws-request-id') ??
        '';
    this.invokedFunctionArn = nextInvocation.httpClientResponse.headers
            .value('lambda-runtime-invoked-function-arn') ??
        '';
    // final timeInterval = TimeInterval(responseHeaderFields["Lambda-Runtime-Deadline-Ms"] as! String)! / 1000
    // this.deadlineDate = Date(timeIntervalSince1970: timeInterval)
  }

  String functionName;
  String functionVersion;
  String logGroupName;
  String logStreamName;
  String memoryLimitInMB;
  String awsRequestId;
  String invokedFunctionArn;
  // DateTime deadlineDate;

  int getRemainingTimeInMillis() {
    // let remainingTimeInSeconds = deadlineDate.timeIntervalSinceNow
    // return Int(remainingTimeInSeconds * 1000)
    return 0;
  }
}

class Runtime {
  String awsLambdaRuntimeAPI;
  String handlerName;
  Map<String, Handler> handlers = {};
  Map<String, ApiGatewayHandler> apiGatewayHandlers = {};
  Map<String, String> environment = Platform.environment;

  Runtime() {
    if (environment["AWS_LAMBDA_RUNTIME_API"] == null) {
      throw Exception('Missing Environment Variables: AWS_LAMBDA_RUNTIME_API');
    }
    if (environment["_HANDLER"] == null) {
      throw Exception('Missing Environment Variables: _HANDLER');
    }
    final handler = environment["_HANDLER"];
    this.awsLambdaRuntimeAPI = environment["AWS_LAMBDA_RUNTIME_API"];

    if (!handler.contains(".")) {
      throw Exception('Invalid Handler Name');
    }

    this.handlerName = handler.split('.')[1];
  }

  Future<NextInvocation> getNextInvocation() async {
    final request = await HttpClient().getUrl(
      Uri.parse(
        'http://$awsLambdaRuntimeAPI/2018-06-01/runtime/invocation/next',
      ),
    );
    //print(request.method.toString());
    final response = await request.close();
    final inputData = await parseBody(response);
    return NextInvocation(httpClientResponse: response, inputData: inputData);
  }

  Future<HttpClientResponse> postInvocationResponse(
      String requestId, dynamic body) async {
    final request = await HttpClient().postUrl(
      Uri.parse(
        'http://$awsLambdaRuntimeAPI/2018-06-01/runtime/invocation/$requestId/response',
      ),
    );
    request.add(
      utf8.encode(
        json.encode(body),
      ),
    );
    final response = await request.close();
    return response;
  }

  Future<HttpClientResponse> postInvocationError(
      String requestId, dynamic error) async {
    final request = await HttpClient().postUrl(
      Uri.parse(
        'http://$awsLambdaRuntimeAPI/2018-06-01/runtime/invocation/$requestId/error',
      ),
    );
    request.add(utf8.encode(error.toString()));
    final response = await request.close();
    return response;
  }

  Future<Map<String, dynamic>> parseBody(HttpClientResponse response) async {
    final data = await response.transform(Utf8Decoder()).toList();
    //print(data);
    return json.decode(data.first) as Map<String, dynamic>;
  }

  void registerHandler(String name, Handler handlerFunction) {
    handlers[name] = handlerFunction;
  }

  void registerApiGatewayHandler(
      String name, ApiGatewayHandler apiGatewayHandler) {
    apiGatewayHandlers[name] = apiGatewayHandler;
    //print(apiGatewayHandlers.toString());
  }

  void start() async {
    Context context;
    NextInvocation nextInvocation;
    Map<String, dynamic> outputData;
    var counter = 0;

    do {
      try {
        nextInvocation = await getNextInvocation();
        //print(environment);
        context = Context(environment, nextInvocation);
        counter += 1;
        print("Invocation-Counter: $counter");
        //print("handlername: " + handlerName);
        print("InputData: " + nextInvocation.inputData.toString());

        /*final apiGatewayHandler = apiGatewayHandlers[handlerName];
        if (apiGatewayHandler != null) {
          print("apiGatewayHandler != null");
          ApiGatewayEvent zuma = ApiGatewayEvent();
          zuma.fromJson(nextInvocation.inputData);
          ApiGatewayResponse apiGatewayResponse = await apiGatewayHandler(
            zuma,
            context,
          );
          outputData = apiGatewayResponse.toJson();
        }*/
        final apiGatewayHandler = apiGatewayHandlers[handlerName];
        if (apiGatewayHandler != null) {
          print("apiGatewayHandler != null");
          ApiGatewayResponse apiGatewayResponse = await apiGatewayHandler(
            ApiGatewayEvent.fromJson(nextInvocation.inputData),
            context,
          );
          print("outputData");
          outputData = apiGatewayResponse.toJson();
        }


        final handler = handlers[handlerName];
        if (handler != null) {
          outputData = await handler(
            nextInvocation.inputData,
            context,
          );
        }

        if (handler == null && apiGatewayHandler == null) {
          throw Exception('Unknown Lambda Handler');
        }

        // TODO: if you need X-Ray
        // if let lambdaRuntimeTraceId = responseHeaderFields["Lambda-Runtime-Trace-Id"] as? String {
        //     setenv("_X_AMZN_TRACE_ID", lambdaRuntimeTraceId, 0)
        // }

        await postInvocationResponse(context.awsRequestId, outputData);
      } on Exception catch (error) {
        await postInvocationError(context.awsRequestId, error);
      }
    } while (true);
  }
}
