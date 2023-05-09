// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let templateData = try? JSONDecoder().decode(TemplateData.self, from: jsonData)

import Foundation

// MARK: - TemplateDatum
struct TemplateDatum: Codable {
    let sampleID: Int?
    let user: User?
    let teacher, headTeacher: HeadTeacher?
    let department: Department?
    let year: Int?
    let programName, programShortName, programNameEnglish, description: String?
    let byDocument: String?
    let clazz: Clazz?

    enum CodingKeys: String, CodingKey {
        case sampleID = "sampleId"
        case user, teacher, headTeacher, department, year, programName, programShortName, programNameEnglish, description, byDocument, clazz
    }
}

// MARK: - Clazz
struct Clazz: Codable {
    let classID: Int?
    let title, description, code: String?

    enum CodingKeys: String, CodingKey {
        case classID = "classId"
        case title, description, code
    }
}

// MARK: - Department
struct Department: Codable {
    let departmentID: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case departmentID = "departmentId"
        case title
    }
}

// MARK: - HeadTeacher
struct HeadTeacher: Codable {
    let personID: Int?
    let firstname, surname, lastname, status: String?

    enum CodingKeys: String, CodingKey {
        case personID = "personId"
        case firstname, surname, lastname, status
    }
}

// MARK: - User
struct User: Codable {
    let userID: Int?
    let person: HeadTeacher?
    let email, username: String?
    let roles: [Role]?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case person, email, username, roles
    }
}

// MARK: - Role
struct Role: Codable {
    let id: Int?
    let name: String?
}

typealias TemplateData = [TemplateDatum]
