//
//  ToDoRecord.swift
//  Now>Later>Never
//
//  Created by Denis Goloborodko on 3.01.21.
//

import Foundation

enum Category: String, AllCasesRawRepresentable {
    case Personal
    case Work
    case Education
}

enum ListType: String, AllCasesRawRepresentable {
    case Today
    case Later
    case Never
    case Done
}

struct Task {
    var title: String
    var category: Category
    var date: Date
    var done: Bool
}

// MARK: - Protocol and Extension for AllCasesRawRepresentable
protocol AllCasesRawRepresentable: CaseIterable, RawRepresentable {
    static func rawValues<T>() -> [T] where T == RawValue
}
    
extension AllCasesRawRepresentable {
    static func rawValues<T>() -> [T] where T == RawValue {
        var rawValues: [T] = []
        
        for eachCase in Self.allCases {
            rawValues.append(eachCase.rawValue)
        }
        return rawValues
    }
}
