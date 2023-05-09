// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let codes = try? JSONDecoder().decode(Codes.self, from: jsonData)

import Foundation

// MARK: - Code
struct Code: Codable {
    let title, code: String?
    let classes: [Class]?
}

// MARK: - Class
struct Class: Codable {
    let classID: Int?
    let title, description, code: String?

    enum CodingKeys: String, CodingKey {
        case classID = "classId"
        case title, description, code
    }
}

typealias Codes = [Code]
