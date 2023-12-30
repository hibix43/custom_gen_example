/// build.yaml の builder_factories に指定するトップレベルの関数
/// build_runner は build.yaml をチェックして、この関数を呼び出す
library generators;

import 'package:build/build.dart';
import 'package:generators/src/json_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateJsonMethods(BuilderOptions options) {
  // part of ファイル用にコンテンツを生成する Builder
  // 複数の SharedPartBuilder が矛盾しないで part of ファイルを生成するために
  // 生成されるファイルには partId が付与される
  return SharedPartBuilder(
    // 作成した Generator を指定する
    [JsonGenerator()],
    // partId のパラメータ
    // 他の SharedPartBuilder と矛盾しないようにする
    'json_generator',
  );
}
