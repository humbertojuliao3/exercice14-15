//
//  CKModel.swift
//  studentHelper
//
//  Created by Sidney Silva on 6/14/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import CloudKit

class CKModel: NSObject {
    var record : CKRecordID?
    weak var database : CKDatabase!
    var titulo : String!
    var materia : String!
    var status : String!
    var nota : String!
    var data : String!
    
    init(record : CKRecord, database: CKDatabase){
        self.record = record.recordID
        self.database = database
        self.titulo = record.objectForKey("Titulo") as! String
        self.materia = record.objectForKey("Materia") as! String
        self.status = record.objectForKey("Status") as! String
        self.nota = record.objectForKey("Notas") as! String
        self.data = record.objectForKey("Data") as! String
    }
}
