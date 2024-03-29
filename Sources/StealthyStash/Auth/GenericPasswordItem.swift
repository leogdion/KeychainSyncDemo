import Security
import Foundation

public struct GenericPasswordItem : Identifiable, Hashable, SecretProperty{
  public func otherProperties() -> SecretDictionary {
    [
          kSecAttrGeneric as String: self.gerneic,
          kSecAttrDescription as String : description?.nilTrimmed(),
          kSecAttrComment as String : comment?.nilTrimmed(),
          kSecAttrType as String : type,
          kSecAttrLabel as String : label
    ]
  }
  
  
  public init(builder: SecretPropertyBuilder) throws {
    self.init(
      account: builder.account,
      data: builder.data,
      service: builder.service,
      accessGroup: builder.accessGroup,
      createdAt: builder.createdAt,
      modifiedAt: builder.modifiedAt,
      description: builder.description,
      type: builder.type,
      label: builder.label,
      isSynchronizable: builder.isSynchronizable
    )
  }
  
  public static var propertyType: SecretPropertyType {
    return .generic
  }
  
  public init(account: String, data: Data, service: String? = nil, accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, comment: String? = nil, type: Int? = nil, label: String? = nil, gerneic: Data? = nil, isSynchronizable: Bool? = nil) {
    //assert(service != nil)
    self.account = account
    self.data = data
    self.service = service
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.gerneic = gerneic
    self.isSynchronizable = isSynchronizable
  }
  
  public var id: String {
    
    [self.account,
    self.service].compactMap{$0}.joined()
  }
  
  
  public func uniqueAttributes() -> SecretDictionary {
    return [
      kSecAttrAccount as String : self.account,
      kSecAttrService as String: self.service,
      kSecAttrAccessGroup as String : self.accessGroup,
      kSecAttrSynchronizable as String: self.isSynchronizable,
    ]
  }
  
  
  public let account : String
  public let data : Data
  public let service : String?
  public let accessGroup : String?
  public let createdAt : Date?
  public let modifiedAt : Date?
  public let description: String?
  public let comment : String?
  public let type : Int?
  public let label : String?
  public let gerneic : Data?
  public let isSynchronizable : Bool?
}

extension GenericPasswordItem {
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
}

extension GenericPasswordItem {
  public init(dictionary : [String : Any]) throws {
    let account : String = try dictionary.require(kSecAttrAccount)
    let data : Data = try dictionary.require(kSecValueData)
    let accessGroup : String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt : Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt : Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type : Int? = try dictionary.requireOptionalCF(kSecAttrType)
    let label : String? = try dictionary.requireOptionalCF(kSecAttrLabel)
    let service : String = try dictionary.require(kSecAttrService)
    let generic : Data? = try dictionary.requireOptional(kSecAttrGeneric)
    let isSynchronizable : Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      service: service,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      gerneic: generic,
      isSynchronizable: isSynchronizable
    )
  }
}
