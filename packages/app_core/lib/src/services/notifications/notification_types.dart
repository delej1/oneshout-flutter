part of 'notifications_service.dart';

//NOTIFACTION PLATFORM DETAILS

///Android Notifcation details when importance is set.
AndroidNotificationDetails _getAndroidNotificationChannel(
  NotificationChannel channel,
) {
  switch (channel) {
    case NotificationChannel.normal:
      return const AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        channelDescription: 'big text channel description',
      );
    case NotificationChannel.important:
      return const AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        channelDescription: 'This channel is used for important notifications.',
      );
  }
}

///Details of a person e.g. someone who sent a message.
///
///[icon] expects a url to the Person's image.
Future<Person> makePerson({
  String? name,
  String? key,
  String? uri,
  String? icon,
  bool bot = false,
  bool useBase64Image = true,
}) async {
  // Get person icon image
  final personIcon = icon == null
      ? null
      : BitmapFilePathAndroidIcon(
          await _downloadAndSaveFile(icon, 'largeIcon_$name'),
        );

  return Person(
    name: name,
    key: key,
    uri: uri,
    bot: bot,
    icon: personIcon,
  );
}

//DOWNLOADS
Future<String> _downloadAndSaveFile(String url, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  try {
    await Dio().download(url, filePath);
    return filePath;
  } catch (e) {
    return '';
  }
}

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

 // Future<String> _base64encodedImage(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   final base64Data = base64Encode(response.bodyBytes);
  //   return base64Data;
  // }
