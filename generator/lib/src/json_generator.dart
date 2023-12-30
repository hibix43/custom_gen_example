import 'package:analyzer/dart/element/element.dart';
import 'package:annotation/annotation.dart';
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
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final visitor = ModelVisitor();
    element.visitChildren(visitor);

    final buffer = StringBuffer();

    String generatedFromJson = generateFromJsonMethod(visitor);
    buffer.writeln(generatedFromJson);

    String generatedToJson = generateToJsonMethod(visitor);
    buffer.writeln(generatedToJson);

    String generatedCopyWith = generateCopyWithMethod(visitor);
    buffer.writeln(generatedCopyWith);

    return buffer.toString();
  }

  /// Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  ///  name: json['name'],
  /// price: json['price'],
  /// );
  String generateFromJsonMethod(ModelVisitor visitor) {
    // className を取得する
    String className = visitor.className;

    // 生成するコードを StringBuffer に格納する
    final buffer = StringBuffer();

    // コードの先頭にコメントを追加する
    buffer.writeln('// From Json Method');
    // シグネチャを追加する
    buffer.writeln(
        '$className _\$${className}FromJson(Map<String, dynamic> json) => ');
    // コンストラクタを始める
    buffer.writeln('$className(');
    // フィールドを追加する
    for (var i = 0; i < visitor.fields.length; i++) {
      String filedName = visitor.fields.keys.elementAt(i);
      String mapValue = 'json[\'$filedName\']';

      buffer.writeln('${visitor.fields.keys.elementAt(i)}: $mapValue,');
    }
    // コンストラクタを閉じる
    buffer.writeln(');');
    return buffer.toString();
  }

  /// Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  /// 'name': instance.name,
  /// 'price': instance.price,
  /// };
  String generateToJsonMethod(ModelVisitor visitor) {
    // className を取得する
    String className = visitor.className;

    // 生成するコードを StringBuffer に格納する
    final buffer = StringBuffer();

    // コードの先頭にコメントを追加する
    buffer.writeln('// To Json Method');
    // シグネチャを追加する
    buffer.writeln(
        'Map<String, dynamic> _\$${className}ToJson($className instance) => ');
    // コンストラクタを始める
    buffer.writeln('<String, dynamic>{');
    // フィールドを追加する
    for (var i = 0; i < visitor.fields.length; i++) {
      String filedName = visitor.fields.keys.elementAt(i);

      buffer.writeln("'$filedName': instance.$filedName,");
    }
    // コンストラクタを閉じる
    buffer.writeln('};');
    return buffer.toString();
  }

  /// Extension $ProductExtension on Product {
  /// Product copyWith({
  /// String? name,
  /// double? price,
  /// }) {
  ///  return Product(
  ///    name: name ?? this.name,
  ///    price: price ?? this.price,
  ///   );
  /// }
  String generateCopyWithMethod(ModelVisitor visitor) {
    // className を取得する
    String className = visitor.className;

    // 生成するコードを StringBuffer に格納する
    final buffer = StringBuffer();

    // コードの先頭にコメントを追加する
    buffer.writeln(
        '// Extension for a $className class to provide copyWith method');
    // シグネチャを追加する
    buffer.writeln('extension \$${className}Extension on $className {');
    // メソッドを始める
    buffer.writeln('$className copyWith({');
    // 引数を追加する
    for (var i = 0; i < visitor.fields.length; i++) {
      String dataType =
          visitor.fields.values.elementAt(i).toString().replaceAll('?', '');
      String filedName = visitor.fields.keys.elementAt(i);
      buffer.writeln('$dataType? $filedName,');
    }
    buffer.writeln('}) {');
    buffer.writeln('return $className(');
    // フィールドを追加する
    for (var i = 0; i < visitor.fields.length; i++) {
      String filedName = visitor.fields.keys.elementAt(i);

      buffer.writeln('$filedName: $filedName ?? this.$filedName,');
    }
    buffer.writeln(');');
    buffer.writeln('}');
    // メソッドを閉じる
    buffer.writeln('}');
    return buffer.toString();
  }
}
