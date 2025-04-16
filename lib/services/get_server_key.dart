import 'package:googleapis_auth/auth_io.dart';
class GetServerKey{
  Future<String> getServerKeyToken()async{
    final scopes=[
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging'
    ];
    final client=await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
        {
          "type": "service_account",
          "project_id": "flutter-ecom-d6c45",
          "private_key_id": "fbfe9028b5f4ce479620f7e92ddcf99f510a6ea2",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPAbmQfa8ERdLz\nz0CRcOSLM4bZaDwixcXmpczYt31ypj3uFhlpuXSmt04l8zd/tOdY7Xksmzr94kPw\nouyg1m+gH/wOmi0Vqgk9xMhSfd/T4xoO5ZevrDjMsi+wR+wJkFV9VmhpdunEQQsb\n6aYqOBduK36+WiexWuqXowEYl6GaD0BZ/XyBPEOCrKsQu31BdYiZIZRV+jKdTDdY\nQ3Ml0aN+xoP02oqiwsGMO/TlcXvVHGJebkO4l0c8Xjpz5EVZqH2XA/BgRtxxjqh4\nr/7698Klb/MPbsCVcHpV8kMGZxEu7ZHzBDnC2y9J55uebc2tL27MarKXILEyNIEj\n9TOf0kbXAgMBAAECggEABfa7dS2E/P85lSGbvBtZa9mketLIcyRpT6+BWwSdfhyX\nYyqxOVaikdA57z9cq90deMMask2XyDG15sX8dQou6OX5Zot/KgUeKaPnzr/NBept\nWUMfEoYVLglVW2N73UisIqWT8eaybgXrsoNFClyKvEQcU8XLWyfOsDPkUUrCpdDZ\nif/N6zOtAFzVZ5CEwRYQs/AP8+HN0M61tWAqdhlpZBs4kAtq9D16iEeAkWxyTkAe\nEuPaYTEkHU5iWMoVBbjLMMxzSsep3ZLzLz4eGx4TOwqPnZ4lZYxz7fZ7NxxMXjcJ\nAUNGa5XzRWgiHnhdgAQqx9WuYBMKWwv2BHgu33mnWQKBgQD+QjB9mAFIwy9zyHph\nUj1jserZmWqAUQiv0Jx/9BUTW3UlUlNFhKPgMHJJII81BN5i+J0qMZ1Kmx7tnTjM\nxlKPEX+tgFF/uhrb8rNy5zoCZ6jEFfvyMsuizOxXcoQwovgClQ8ajbPUtOGVAf2N\n1iP9oD5OJZlwkjNrc1588FbxnwKBgQDQbK9vgDhA9npi+1xAOu2L032g8SyxHePR\nKywhkcacfMag8O1I/ND2diChIriUdseE73XJYFFwX45W8Xwb9Md4Q7KXnKxQ2QV2\n8UaELmZmX2ePfMhDnR2OoOX6p+yMHZCLtNt4qLe7UKWbapJyvdSEP8+7Q+bIRFwA\nAWXeqXHPyQKBgHMC48ZcFPCiAfwAyoLtXYGUQGSPxiInBaPp3HDwqvvnmfT46Vv/\n5NULdRbpGH5mJmZkiUtFyB2wT2wyezf92eiHhNapvbPmLjIh9dRbDd16oFeaji3/\nliedRKdF0M/jWAZrALsFMDxeWdA6Z0Ragks+yhA1Z9QI/iNzu2EOonWHAoGBAMLL\nQW/Bc1HrytilukNhj9AmOnznyvBCUkCUy+sX9nsc9vtGEU8s0hP2tWpELCS9mp24\nu+oYtiSDemHx0h/Ct4bEJq8iQ75QBpZyy4gQYa3+LqjhY74lopFB+Y850I/ntceM\noa50aTuNFSpbAUJx/qQXi4um25OCqEVtCQuAbBlZAoGABSsG0b8Su6lSw+ad1cJl\nNl4k+4gtcXz61pK/2yjga3oxxc/yjz3sKLIfY0XjxUmdsrMMSFqw1CNieQiPOw0N\nPyCRsPGGOiHxP8eQ2VAEZYycvXgfOX8Fas+q4tKYdJChA/qtk5y61HIzs2dBNzVL\n+XE2a7Tt1kimtQ3G6ZtfA/k=\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-fbsvc@flutter-ecom-d6c45.iam.gserviceaccount.com",
          "client_id": "115207456957396619490",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40flutter-ecom-d6c45.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }

    ),scopes);
    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
}