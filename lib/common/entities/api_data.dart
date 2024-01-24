// ignore_for_file: strict_raw_type

class ApiResponse<T> {
  ApiResponse({
    this.data = const [],
    this.pagination = const Pagination(),
  });

  ApiResponse.fromJson(Map<String, dynamic> json)
      : data = json['data'] as List<T>,
        pagination = json['pagination'] != null
            ? Pagination.fromJson(json['pagination'] as Map<String, dynamic>)
            : const Pagination();

  final List<T> data;
  final Pagination pagination;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
        'pagination': pagination,
      };

  static List<ApiResponse> listFromJson(List<Map<String, dynamic>> json) =>
      List<ApiResponse>.from(
        json.map<ApiResponse>(ApiResponse.fromJson),
      );

  ApiResponse copyWith({List<T>? data, Pagination? pagination}) =>
      ApiResponse<T>(
        data: data ?? this.data,
        pagination: pagination ?? this.pagination,
      );
}

class Pagination {
  // ignore: lines_longer_than_80_chars
  const Pagination({
    this.page = 1,
    this.pageSize = 25,
    this.pageCount = 1,
    this.total = 0,
  });

  Pagination.fromJson(Map<String, dynamic> json)
      : page = json['page'] as int,
        pageSize = json['pageSize'] as int,
        pageCount = json['pageCount'] as int,
        total = json['total'] as int;

  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Pagination copyWith({
    int? page,
    int? pageSize,
    int? pageCount,
    int? total,
  }) =>
      Pagination(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        pageCount: pageCount ?? this.pageCount,
        total: total ?? this.total,
      );
}
