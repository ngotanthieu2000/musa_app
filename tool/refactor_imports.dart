import 'dart:io';
import 'dart:core';

/// Script hỗ trợ refactor imports từ tương đối dài thành sử dụng barrel files
/// 
/// Cách chạy: dart run tool/refactor_imports.dart
/// 
/// Lưu ý: Script này là hỗ trợ cơ bản, bạn nên kiểm tra cẩn thận kết quả
/// và có thể cần điều chỉnh thủ công một số trường hợp đặc biệt.
void main() async {
  final rootDir = Directory('lib');
  
  print('Bắt đầu refactor imports...');
  
  await processDirectory(rootDir);
  
  print('Hoàn thành refactor!');
  print('Khuyến nghị: Kiểm tra lại code tổng thể.');
}

Future<void> processDirectory(Directory dir) async {
  final entities = dir.listSync(recursive: false);
  
  for (final entity in entities) {
    if (entity is File && entity.path.endsWith('.dart')) {
      await processFile(entity);
    } else if (entity is Directory) {
      await processDirectory(entity);
    }
  }
}

Future<void> processFile(File file) async {
  try {
    final content = await file.readAsString();
    final lines = content.split('\n');
    bool hasChanges = false;
    
    final updatedLines = <String>[];
    final imports = <String>[];
    bool inImportSection = false;
    
    // Thu thập tất cả imports
    for (final line in lines) {
      if (line.trim().startsWith('import ')) {
        inImportSection = true;
        imports.add(line);
      } else {
        if (inImportSection && line.trim().isEmpty) {
          inImportSection = false;
        }
        updatedLines.add(line);
      }
    }
    
    // Xác định các import có thể chuyển sang barrel files
    final optimizedImports = optimizeImports(imports, file.path);
    
    // Chèn imports tối ưu vào đầu file
    final result = insertOptimizedImports(updatedLines, optimizedImports);
    
    if (imports.join('\n') != optimizedImports.join('\n')) {
      await file.writeAsString(result.join('\n'));
      print('Cập nhật file: ${file.path}');
    }
  } catch (e) {
    print('Lỗi khi xử lý file ${file.path}: $e');
  }
}

List<String> optimizeImports(List<String> imports, String filePath) {
  // Nhóm các imports theo package/thư mục gốc
  final Map<String, List<String>> importGroups = {};
  final List<String> packageImports = [];
  final List<String> dartImports = [];
  
  for (final importLine in imports) {
    if (importLine.contains("import 'dart:")) {
      dartImports.add(importLine);
    } else if (importLine.contains("import 'package:")) {
      packageImports.add(importLine);
    } else if (importLine.contains("import '../") || importLine.contains("import './")) {
      final regExp = RegExp(r"import ['\"]([\.\/]+[^'\"]+)['\"]");
      final match = regExp.firstMatch(importLine);
      
      if (match != null) {
        final relPath = match.group(1)!;
        // Xác định thư mục chung nhất
        final commonDir = getCommonDirectory(relPath);
        
        if (commonDir != null) {
          if (!importGroups.containsKey(commonDir)) {
            importGroups[commonDir] = [];
          }
          importGroups[commonDir]!.add(importLine);
        } else {
          // Không tìm thấy thư mục chung, giữ nguyên import
          packageImports.add(importLine);
        }
      }
    } else {
      packageImports.add(importLine);
    }
  }
  
  // Tạo danh sách imports tối ưu
  final optimizedImports = <String>[];
  optimizedImports.addAll(dartImports);
  if (dartImports.isNotEmpty && packageImports.isNotEmpty) {
    optimizedImports.add('');
  }
  optimizedImports.addAll(packageImports);
  
  // Thêm các imports tối ưu từ những thư mục cùng chung
  for (final commonDir in importGroups.keys) {
    if (importGroups[commonDir]!.length > 2) {
      // Nếu có nhiều hơn 2 import từ cùng một thư mục, sử dụng barrel file
      optimizedImports.add("import '$commonDir/index.dart';");
    } else {
      // Giữ nguyên imports nếu chỉ có 1-2 import
      optimizedImports.addAll(importGroups[commonDir]!);
    }
  }
  
  return optimizedImports;
}

String? getCommonDirectory(String path) {
  final parts = path.split('/');
  if (parts.length < 2) return null;
  
  // Phân tích đường dẫn để tìm thư mục chung nhất
  // Ví dụ: '../../../core/widgets/app_bar.dart' => core
  // Ví dụ: '../../domain/entities/profile.dart' => domain
  
  if (path.contains('../../../core/')) {
    return '../../../core';
  } else if (path.contains('../../domain/')) {
    return '../../domain';
  } else if (path.contains('../../data/')) {
    return '../../data';
  } else if (path.contains('../bloc/') || path.contains('../widgets/') || path.contains('../pages/')) {
    return '..';
  }
  
  return null;
}

List<String> insertOptimizedImports(List<String> lines, List<String> optimizedImports) {
  final result = <String>[];
  bool importSectionAdded = false;
  
  for (int i = 0; i < lines.length; i++) {
    if (!importSectionAdded && i > 0 && lines[i - 1].startsWith('//') && !lines[i].startsWith('import')) {
      // Chèn imports sau các comment ban đầu
      result.addAll(optimizedImports);
      result.add('');
      importSectionAdded = true;
    }
    result.add(lines[i]);
  }
  
  if (!importSectionAdded) {
    // Nếu không tìm thấy vị trí chèn, đặt imports ở đầu file
    return [...optimizedImports, '', ...lines];
  }
  
  return result;
} 