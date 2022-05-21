//
//  PhotoRequest.swift
//  ExPagination
//
//  Created by 김종권 on 2022/05/21.
//

import Foundation

struct PhotoRequest: Codable {
  let page: Int
  let perPage: Int = 10
  
  enum CodingKeys: String, CodingKey {
    case page
    case perPage = "per_page"
  }
}

extension Encodable {
  func toDictionary() -> [String: Any] {
    do {
      let jsonEncoder = JSONEncoder()
      let encodedData = try jsonEncoder.encode(self)
      
      let dictionaryData = try JSONSerialization.jsonObject(
        with: encodedData,
        options: .allowFragments
      ) as? [String: Any]
      return dictionaryData ?? [:]
    } catch {
      return [:]
    }
  }
}
