import 'context.dart';
import 'parser.dart';
import 'result.dart';

class ChoiceParser<I, O> extends Parser<I, O> {
  final List<Parser<I, O>> children;
  ChoiceParser(
    this.children,
  ) {
    if (children.isEmpty) {
      throw ArgumentError('Choice parser cannot be empty.');
    }
  }

  @override
  Result<I, O> parseOn(Context<I> context) {
    Result<I, O>? result;
    for (var i = 0; i < children.length; i++) {
      result = children[i].parseOn(context);
      if (result.isSuccess) {
        return result;
      }
    }
    return result!;
  }

  @override
  Parser<I, O> or(Parser<I, O> other) => ChoiceParser([...children, other]);
}