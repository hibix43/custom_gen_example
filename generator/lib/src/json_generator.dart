import 'package:analyzer/dart/element/element.dart';
import 'package:annotation/annotations.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:generator/src/model_visitor.dart';
import 'package:source_gen/source_gen.dart';

// Generator のエントリーポイント
// dart run build_runner build が実行されたら、 build_runner はまず build.yaml をチェックする
// example files を全てチェックしてアノテーションがあれば、このクラスがそれを認識する
// そして override された関数を呼び出す
class JsonGenerator extends GeneratorForAnnotation<CustomAnnotation> {
  // この場合は Element はクラスになる。それ以外のパラメータは使用しない
  // 生成されたコードを示す String を返す
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);
  }
}
