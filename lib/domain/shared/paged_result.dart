class PagedResult<T> {
  final List<T> items;
  final bool hasMore;

  const PagedResult({required this.items, required this.hasMore});
}
