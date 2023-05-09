//
//  SignInError.swift
//  Mentor's Joy
//
//  Created by Ольга on 02.05.2023.
//

import Foundation

struct SignInError: Codable {
    // MARK: - SignInError
    let path, error, message: String
    let status: Int
}
