// ignore_for_file: depend_on_referenced_packages

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

// コード生成のためにコンストラクタやフィールドなどにアクセスするためのクラス
// SimpleElementVisitor は以下のようなメソッドを持つ
// - visitFieldElement method
// - visitConstructorElement method
// - visitFunctionElement method
class ModelVisitor extends SimpleElementVisitor<void> {
  String className = '';
  Map<String, dynamic> fields = {};

  @override
  void visitConstructorElement(ConstructorElement element) {
    final String returnType = element.returnType.toString();
    // ex.ClassName* -> ClassName
    className = returnType.replaceAll("*", '');
  }

  @override
  void visitFieldElement(FieldElement element) {
    final elementType = element.type.toString().replaceAll("*", '');
    // {name: String, price: double}
    fields[element.name] = elementType;
  }
}
