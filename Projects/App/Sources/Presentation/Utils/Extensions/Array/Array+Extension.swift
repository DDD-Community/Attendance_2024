//
//  Array+Extension.swift
//  DDDAttendance
//
//  Created by 고병학 on 6/22/24.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else {
            return nil
        }
        return self[index]
    }
}
