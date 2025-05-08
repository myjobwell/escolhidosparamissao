import 'dart:io';

void main() async {
  final List<String> paths = [
    'android/app/src/main/res/mipmap-hdpi/launcher_icon.png',
    'android/app/src/main/res/mipmap-mdpi/launcher_icon.png',
    'android/app/src/main/res/mipmap-xhdpi/launcher_icon.png',
    'android/app/src/main/res/mipmap-xxhdpi/launcher_icon.png',
    'android/app/src/main/res/mipmap-xxxhdpi/launcher_icon.png',
  ];

  print('🔍 Limpando ícones antigos...');
  for (final path in paths) {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('🗑️ Apagado: $path');
    } else {
      print('❌ Não encontrado (ignorado): $path');
    }
  }

  print('\n🚀 Gerando novos ícones com flutter_launcher_icons...');
  final result = await Process.run('dart', ['run', 'flutter_launcher_icons']);

  print('\n📦 Resultado do comando:');
  print(result.stdout);
  if (result.stderr.toString().isNotEmpty) {
    print('⚠️ Erros:\n${result.stderr}');
  }

  print('\n✅ Processo concluído.');
}
