//
//  SQLBrowser.swift
//  SQLBrowser
//
//  Created by Jianguo Wu on 2018/2/10.
//  Copyright © 2018年 Jianguo Wu. All rights reserved.
//

import Foundation

//protocol SQLBrowser {
//
//    static func connect(path: String)
//
//}


class SQLiteDatabase {
    
    enum ColumnType {
        case Null
        case Integer
        case Real
        case Text
        case Blob
    }

    struct ColumnDescription {
        let name: String
        let type: ColumnType
    }
    
    struct ColumnValue {
        
        let column: ColumnDescription
        
        let value: Any?
    }
    
    class Table {
        
        var columns = [ColumnDescription]()
        
        var name: String!
        
    }
    
    
    init(path: String) {
        
    }
    
    deinit {
        
    }
    
    var tables = [Table]()
    
    func select(columns: [ColumnDescription], from: Table) -> [[ColumnValue]] {
        return []
    }
    
}
