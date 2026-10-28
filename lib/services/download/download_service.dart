import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:enseignement_vivant/constant/app_api_end_point.dart';
import 'package:enseignement_vivant/utils/error_log.dart';
import 'package:enseignement_vivant/widgers/custom_snack_bar/app_snack_bar.dart';

class DownloadedMediaModel {
  final String id;
  final String title;
  final String subtitle;
  final String categoryTag;
  final String imagePath;
  final String mediaType; // 'AUDIO', 'IMAGE', 'VIDEO'
  final String localFilePath;
  final String fileSize;
  final String downloadDate;
  final String? audioUrl;
  final String durationText;

  DownloadedMediaModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.categoryTag,
    required this.imagePath,
    required this.mediaType,
    required this.localFilePath,
    required this.fileSize,
    required this.downloadDate,
    this.audioUrl,
    required this.durationText,
  });

  factory DownloadedMediaModel.fromJson(Map<String, dynamic> json) {
    return DownloadedMediaModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      categoryTag: json['categoryTag'] ?? 'Audio',
      imagePath: json['imagePath'] ?? '',
      mediaType: json['mediaType'] ?? 'AUDIO',
      localFilePath: json['localFilePath'] ?? '',
      fileSize: json['fileSize'] ?? '',
      downloadDate: json['downloadDate'] ?? '',
      audioUrl: json['audioUrl'],
      durationText: json['durationText'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'categoryTag': categoryTag,
      'imagePath': imagePath,
      'mediaType': mediaType,
      'localFilePath': localFilePath,
      'fileSize': fileSize,
      'downloadDate': downloadDate,
      'audioUrl': audioUrl,
      'durationText': durationText,
    };
  }
}

class DownloadService extends GetxController {
  static DownloadService get instance {
    if (!Get.isRegistered<DownloadService>()) {
      Get.put(DownloadService(), permanent: true);
    }
    return Get.find<DownloadService>();
  }

  final GetStorage _box = GetStorage();
  final Dio _dio = Dio();
  static const String _storageKey = 'user_downloads_v1';

  final RxList<DownloadedMediaModel> downloadedItems = <DownloadedMediaModel>[].obs;
  final RxMap<String, double> downloadProgress = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDownloadedItems();
  }

  void loadDownloadedItems() {
    try {
      final List? rawList = _box.read(_storageKey);
      if (rawList != null) {
        final items = rawList
            .map((e) => DownloadedMediaModel.fromJson(Map<String, dynamic>.from(e)))
            .where((item) => File(item.localFilePath).existsSync())
            .toList();
        downloadedItems.assignAll(items);
      }
    } catch (e) {
      errorLog('DownloadService loadDownloadedItems Exception', e);
    }
  }

  bool isDownloaded(String id) {
    return downloadedItems.any((item) => item.id == id && File(item.localFilePath).existsSync());
  }

  bool isDownloading(String id) {
    return downloadProgress.containsKey(id);
  }

  Future<void> startDownload({
    required String id,
    required String title,
    required String subtitle,
    required String categoryTag,
    required String imagePath,
    required String downloadUrl,
    required String durationText,
    String mediaType = 'AUDIO',
  }) async {
    if (isDownloaded(id)) {
      AppSnackBar.instance.error("Already downloaded!");
      return;
    }

    if (isDownloading(id)) {
      AppSnackBar.instance.error("Download in progress...");
      return;
    }

    String targetUrl = downloadUrl.trim();
    if (targetUrl.isEmpty) {
      AppSnackBar.instance.error("Download URL not available");
      return;
    }

    if (!targetUrl.startsWith('http://') && !targetUrl.startsWith('https://')) {
      if (targetUrl.startsWith('/files/')) {
        targetUrl = "${AppApiEndPoint.instance.domain}$targetUrl";
      } else if (targetUrl.startsWith('/')) {
        targetUrl = "${AppApiEndPoint.instance.imageBaseUrl}$targetUrl";
      } else {
        targetUrl = "${AppApiEndPoint.instance.imageBaseUrl}/$targetUrl";
      }
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDocDir.path}/user_downloads');
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      String extension = 'mp3';
      if (mediaType == 'IMAGE') {
        extension = 'jpg';
      } else if (mediaType == 'VIDEO') {
        extension = 'mp4';
      } else if (targetUrl.endsWith('.wav')) {
        extension = 'wav';
      } else if (targetUrl.endsWith('.m4a')) {
        extension = 'm4a';
      }

      final savePath = '${downloadDir.path}/${id}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      downloadProgress[id] = 0.01;
      AppSnackBar.instance.success("Downloading '$title'...");

      await _dio.download(
        targetUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            downloadProgress[id] = (received / total).clamp(0.0, 1.0);
          }
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      final file = File(savePath);
      String fileSizeStr = '0 MB';
      if (await file.exists()) {
        final bytes = await file.length();
        fileSizeStr = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }

      final dateNow = DateTime.now();
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      final dateStr = "${months[(dateNow.month - 1).clamp(0, 11)]} ${dateNow.day}, ${dateNow.year}";

      final item = DownloadedMediaModel(
        id: id,
        title: title,
        subtitle: subtitle,
        categoryTag: categoryTag,
        imagePath: imagePath,
        mediaType: mediaType,
        localFilePath: savePath,
        fileSize: fileSizeStr,
        downloadDate: dateStr,
        audioUrl: targetUrl,
        durationText: durationText,
      );

      downloadedItems.add(item);
      await _saveToStorage();

      AppSnackBar.instance.success("Downloaded '$title' successfully!");
    } catch (e) {
      errorLog('Download Media Exception for $title', e);
      AppSnackBar.instance.error("Failed to download '$title'");
    } finally {
      downloadProgress.remove(id);
    }
  }

  Future<void> deleteDownloadedItem(DownloadedMediaModel item) async {
    try {
      final file = File(item.localFilePath);
      if (await file.exists()) {
        await file.delete();
      }
      downloadedItems.removeWhere((i) => i.id == item.id);
      await _saveToStorage();
      AppSnackBar.instance.success("Deleted '${item.title}'");
    } catch (e) {
      errorLog('deleteDownloadedItem Exception', e);
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final List<Map<String, dynamic>> jsonList = downloadedItems.map((e) => e.toJson()).toList();
      await _box.write(_storageKey, jsonList);
      await _box.save();
    } catch (e) {
      errorLog('_saveToStorage Exception', e);
    }
  }
}
