//
//  String+ext.swift
//  DeliHood
//
//  Created by Vojta Fluger on 18.08.2025.
//

import Foundation

//Ngl, chatgpts work
extension String {
    func formattedPhone() -> String {
        let digits = self.filter { $0.isNumber || self.first == "+" }
        var result = ""
        
        if self.hasPrefix("+") {
            // International format +XXX XXX XXX XXX
            var index = digits.index(after: digits.startIndex)
            result.append(digits[digits.startIndex])
            var group = 0
            while index < digits.endIndex {
                if group == 0 || group % 3 == 0 { result.append(" ") }
                result.append(digits[index])
                index = digits.index(after: index)
                group += 1
            }
        } else {
            // Local format XXX XXX XXX
            var index = digits.startIndex
            var group = 0
            while index < digits.endIndex {
                if group != 0 && group % 3 == 0 { result.append(" ") }
                result.append(digits[index])
                index = digits.index(after: index)
                group += 1
            }
        }
        
        return result.trimmingCharacters(in: .whitespaces)
    }
}
