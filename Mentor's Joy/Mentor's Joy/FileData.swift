//
//  FileData.swift
//  Mentor's Joy
//
//  Created by Ольга on 07.05.2023.
//

import Foundation


struct FileDatum: Codable {
    let techAssigmentId: Int?
    let sample: TemplateDatum?
}

typealias FileData = [FileDatum]
