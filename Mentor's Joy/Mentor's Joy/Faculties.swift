// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let faculties = try? JSONDecoder().decode(Faculties.self, from: jsonData)

import Foundation

// MARK: - Faculty
struct Faculty: Codable {
    let facultyID: Int?
    let title: String?
    let departments: [Depart]?

    enum CodingKeys: String, CodingKey {
        case facultyID = "facultyId"
        case title, departments
    }
}

// MARK: - Department
struct Depart: Codable {
    let departmentID: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case departmentID = "departmentId"
        case title
    }
}

typealias Faculties = [Faculty]
