#!/bin/bash
if [[ $1 == "aot" ]]; then
    cp main.dart runtime.dart apigateway_event.dart ./dart_aot
    cd ./dart_aot
    echo 'compiling...'
    dart2aot main.dart main.dart.aot
    echo 'set bootstrap executable...'
    chmod +x bootstrap
    echo 'zipping...'
    zip -r dart_aot.zip bin/ bootstrap main.dart.aot
    echo 'moving to ../'
    mv dart_aot.zip ../
    echo 'cleaning up...'
    rm main.dart* runtime.dart apigateway_event.dart
    echo 'Ready to upload dart_aot.zip to AWS!'
fi


# TODO: WIP
if [[ $1 == "vm" ]]; then
    cp main.dart runtime.dart apigateway_event.dart ./dart_vm
    cd ./dart_vm
    echo 'set bootstrap executable...'
    chmod +x bootstrap
    echo 'zipping...'
    zip -r dart_vm.zip bin/ bootstrap *.dart
    echo 'moving to ../'
    mv dart_vm.zip ../
    echo 'cleaning up...'
    rm *.dart
    echo 'Ready to upload dart_aot.zip to AWS!'
fi