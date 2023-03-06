
extension SecretsRepository {
  func create<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .adding)
    for property in properties {
      try self.create(property.property)
    }
  }
  
  func update<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .updating)
    for property in properties {
      if property.shouldDelete {
        try self.delete(property.property)
      } else {
        try self.update(property.property)
      }
    }
  }
  
  func delete<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .deleting)
    for property in properties {
      try self.delete(property.property)
    }
  }
  
  func fetch<SecretModelType : SecretModel>(_ query: SecretModelType.QueryBuilder.QueryType) async throws -> SecretModelType? {
    let properties = try await withThrowingTaskGroup(of: (String, [AnySecretProperty]).self, returning: [String: [AnySecretProperty]].self) { taskGroup in
      let queries = SecretModelType.QueryBuilder.queries(from: query)
      for (id, query) in queries {
        
        
        taskGroup.addTask {
          return try (id, self.query(query))
        }
      }
      
      return try await taskGroup.reduce(into: [String : [AnySecretProperty]]()) { result, pair in
        result[pair.0] = pair.1
      }
    }
    return try SecretModelType.QueryBuilder.model(from: properties)
  }
  
  func fetch<SecretModelType : SecretModel> () async throws -> SecretModelType? where SecretModelType.QueryBuilder.QueryType == Void {
    try await self.fetch(())
  }
}