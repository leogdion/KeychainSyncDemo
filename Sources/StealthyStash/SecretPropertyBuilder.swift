import Foundation


public struct SecretPropertyBuilder {
  public let secClass : SecretPropertyType
  public init(secClass : SecretPropertyType, source: AnySecretProperty? = nil, account: String = "", data: Data = .init(), accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, type: Int? = nil, label: String? = nil, service: String? = nil, server: String? = nil, `protocol`: ServerProtocol? = nil, authenticationType: AuthenticationType? = nil, port: Int? = nil, path: String? = nil, isSynchronizable: Bool? = nil) {
    self.secClass = secClass
    self.source = source
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.typeValue = type ?? 0
    self.hasType = type != nil
    self.labelValue = label ?? ""
    self.hasLabel = label != nil
    self.service = service
    self.server = server
    self.`protocol` = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizableValue = isSynchronizable ?? false
    self.isSynchronizableSet = isSynchronizable != nil
  }
  
  public var source : AnySecretProperty?
  public var account : String
  public var data : Data
  public var accessGroup : String?
  public var createdAt : Date?
  public var modifiedAt : Date?
  public var description: String?
  public var typeValue : Int
  public var hasType : Bool
  public var labelValue : String
  public var hasLabel : Bool
  public var service : String?
  public var server : String?
  public var `protocol` : ServerProtocol?
  public var authenticationType : AuthenticationType?
  public var port: Int?
  public var path: String?
  public var isSynchronizableValue : Bool
  public var isSynchronizableSet : Bool
}

extension SecretPropertyBuilder {
  public var dataString : String {
    get {
      return String(data: self.data, encoding: .utf8) ?? ""
    }
    set {
      self.data = newValue.data(using: .utf8) ?? .init()
    }
  }
  
  public var url : URL? {
    var components = URLComponents()
    components.scheme = self.protocol?.rawValue
    components.host = self.server
    components.path = self.path ?? ""
    components.port = self.port
    return components.url
  }
  
  public var descriptionText : String {
    get {
      return self.description ?? ""
    }
    set {
      self.description = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }
  
  public var accessGroupText : String {
    get {
      return self.accessGroup ?? ""
    }
    set {
      self.accessGroup = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }
  
  public var label : String? {
    return hasLabel ? labelValue : nil
  }
  
  public var type : Int? {
    return hasType ? typeValue : nil
  }
  
  public var isSynchronizable : Bool? {
    return isSynchronizableSet ? isSynchronizableValue : nil
  }
  
  public var isModified : Bool {
    guard let source else {
      return true
    }
    return [
      self.account != source.account,
      self.isSynchronizable != source.isSynchronizable,
      self.type != source.type,
      self.accessGroup != source.accessGroup,
      self.authenticationType != source.accessGroup,
      self.server != source.server,
      self.protocol != source.protocol,
      self.port != source.port,
      self.path != source.path
    ].first {!$0} ?? true
  }
  
  public func saved () throws -> SecretPropertyBuilder {
    return try .init(
      secClass: self.secClass,
      source: .init(builder: self),
      account : self.account,
      data : self.data,
      accessGroup : self.accessGroup,
      createdAt : self.createdAt,
      modifiedAt : self.modifiedAt,
      description : self.description,
      type : self.type,
      label : self.label,
      service: self.service,
      server : self.server,
      protocol : self.protocol,
      authenticationType : self.authenticationType,
      port : self.port,
      path : self.path,
      isSynchronizable : self.isSynchronizable
    )
  }
}

public extension SecretPropertyBuilder {
  init (item: AnySecretProperty) {

    assert(item.propertyType == .internet || item.service != nil)
    self.init(
      secClass: item.propertyType,
      source: item,
      account : item.account,
      data : item.data,
      accessGroup : item.accessGroup,
      createdAt : item.createdAt,
      modifiedAt : item.modifiedAt,
      description : item.description,
      type : item.type,
      label : item.label,
      service: item.service,
      server : item.server,
      protocol : item.protocol,
      port : item.port,
      path : item.path,
      isSynchronizable : item.isSynchronizable
    )
  }
}

extension InternetPasswordItem {
  public init(builder: SecretPropertyBuilder) {
    self.init(
      account: builder.account,
      data: builder.data,
      accessGroup: builder.accessGroup,
      createdAt: builder.createdAt,
      modifiedAt: builder.modifiedAt,
      description: builder.description,
      type: builder.type,
      label: builder.label,
      server: builder.server,
      protocol: builder.protocol,
      port: builder.port,
      path: builder.path,
      isSynchronizable: builder.isSynchronizable
    )
  }
}
