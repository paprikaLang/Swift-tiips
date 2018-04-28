

import Foundation
import UIKit

struct Account {
    var type: Int
    var alias: String
    var createdAt: Date
    //y一个int比特数
    let INT_BIT = (Int)(CHAR_BIT) * MemoryLayout<Int>.size
    //按位旋转,降低碰撞概率
    func bitRotate(value: Int, bits: Int) -> Int {
        return (value << bits) | (value >> (INT_BIT - bits))
    }
    
}
extension Account: Hashable {
    var hashValue: Int {
        return bitRotate(value: type.hashValue, bits: 10) ^ alias.hashValue ^ createdAt.hashValue
    }
}

extension Account: Equatable {
    static func ==(lhs: Account,rhs: Account) -> Bool {
        return lhs.type == rhs.type &&
               lhs.alias == rhs.alias &&
               lhs.createdAt == rhs.createdAt
    }
}
var data: [Account: Int]?



extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var tmp: Set<Iterator.Element> = []
        return filter {
            if tmp.contains($0) {
                return false
            }else {
                tmp.insert($0)
                return true
            }
        }
    }
}

[1,2,3,1,6,4,6].unique()






