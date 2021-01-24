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
}

// MARK: - Protocol and Extension for AllCasesRawRepresentable
protocol AllCasesRawRepresentable: CaseIterable, RawRepresentable {
    static var rawValues: [String] { get }
}
    
extension AllCasesRawRepresentable {
    static var rawValues: [String] {
    
        var rawValues: [String] = []
        
        for eachCase in self.allCases {
            rawValues.append(eachCase.rawValue as? String ?? "")
        }
        
        return rawValues
    }
}
