// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userData = try? JSONDecoder().decode(UserData.self, from: jsonData)

import Foundation

// MARK: - UserData
struct UserData: Codable {
    let id: Int?
    let username, email: String?
    let roles: [String]?
    let tokenType, accessToken: String?
    let path, error, message: String?
    let status: Int?
}
