import 'dart:html';
import 'dart:async';

void main() {
  final InputElement input = querySelector('input') as InputElement;
  final DivElement div = querySelector('div') as DivElement;

//   div.innerHtml = "Enter a valid email";

  final validator =
      new StreamTransformer.fromHandlers(handleData: (inputValue, sink) {
    if ((inputValue as String).contains('@')) {
      sink.add(inputValue);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final notGmailValidator =
      new StreamTransformer.fromHandlers(handleData: (inputValue, sink) {
    if ((inputValue as String).contains('@gmail.com')) {
      sink.add(inputValue);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final notEmptyValidator =
      new StreamTransformer.fromHandlers(handleData: (inputValue, sink) {
    if ((inputValue as String) != "") {
      sink.add(inputValue);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  input.onInput
      .map((dynamic event) => event.target.value)
      .transform(validator)
      .transform(notGmailValidator)
      .transform(notEmptyValidator)
      .listen((inputValie) => div.innerHtml = '',
          onError: (err) => div.innerHtml = err);
}
