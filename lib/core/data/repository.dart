abstract interface class Repository<T, ID, DTO> {
  Future<T?> findOne(ID id);
  Future<List<T>> findAll();
}
