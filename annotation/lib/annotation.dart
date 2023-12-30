// 外部から annotation パッケージとしてアクセスできるようにする
// src以下のファイルを個々にimportするのではなく、
// このファイルをimportすることで、src以下のファイルを一括で利用できるようにする

library annotation;

export 'src/custom_annotation.dart';
