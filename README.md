# By the way, why the hell Streams?

- A lot of Dart + Flutter libraries return streams that you and I can work with
- We can compose streams out of easily reusable functions
- Can be really easy to read streams and understand how they modify data
- Streams are all about time series of data - far easier to do some time-related stuff with streams

# HTML button handling Example

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/ca2b0b4c-13a2-4c70-a562-179c9af73276/Untitled.png)

```dart
import 'dart:html';

void main() {
  final ButtonElement button = querySelector('button') as ButtonElement;
  
  button.onClick
    .timeout(
      new Duration(seconds: 1), 
      onTimeout: (sink) => sink.addError('You lost!!!'),
    )
    .listen(
      (event) {}, 
      onError: (err) => print(err)
    );
}
```

# Word guessing game

```dart
import 'dart:html';

void main() {
  
  final ButtonElement button = querySelector('button') as ButtonElement;
  final InputElement input = querySelector('input') as InputElement;
  
  button.onClick 
    .take(4) // four seconds later
    .where((event) => input.value == 'banana')
    .listen(
      (event) => print('You got it'), 
      onDone: () => print('Nope, bad guesses.')
  );
}
```

# Input Validation using Stream

```dart
import 'dart:html';
import 'dart:async';

void main() {
  
  final InputElement input = querySelector('input') as InputElement; 
  final DivElement div = querySelector('div') as DivElement; 
    
//   div.innerHtml = "Enter a valid email";
  
  final validator = new StreamTransformer.fromHandlers(
    handleData: (inputValue, sink) {
      if((inputValue as String).contains('@')) {
         sink.add(inputValue);
      } else {
         sink.addError('Enter a valid email'); 
      }
    } 
  );
  
  final notGmailValidator = new StreamTransformer.fromHandlers(
    handleData: (inputValue, sink) {
      if((inputValue as String).contains('@gmail.com')) {
         sink.add(inputValue);
      } else {
         sink.addError('Enter a valid email'); 
      }
    } 
  );
  
    final notEmptyValidator = new StreamTransformer.fromHandlers(
    handleData: (inputValue, sink) {
      if((inputValue as String) != "") {
         sink.add(inputValue);
      } else {
         sink.addError('Enter a valid email'); 
      }
    } 
  );
  
  input.onInput 
    .map((dynamic event) => event.target.value)
    .transform(validator)
    .transform(notGmailValidator)
    .transform(notEmptyValidator)
    .listen(
      (inputValie) => div.innerHtml = '',
      onError: (err) => div.innerHtml = err
    );
  
}
```