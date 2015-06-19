//
//  CloudKitHelper.swift
//  studentHelper
//
//  Created by Sidney Silva on 6/11/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}



class CloudKitHelper {
    var container: CKContainer
    var publicDB: CKDatabase
    let privateDB: CKDatabase
    var delegate : CloudKitDelegate?
    var tarefas = [CKModel]()
    var provas = [CKModel]()
    var recordID : CKRecordID?
    
    class func sharedInstance() -> CloudKitHelper {
        return cloudKitHelper
    }
    
    init() {
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    func saveOrUpdateTarefas (titulo : NSString, materia : NSString, status: NSNumber, nota: NSNumber, data: NSDate){
        let tarefaRecord = CKRecord(recordType: "Tarefas")
        tarefaRecord.setValue(titulo, forKey: "Titulo")
        tarefaRecord.setValue(materia, forKey: "Materia")
        tarefaRecord.setValue(status, forKey: "Status")
        tarefaRecord.setValue(nota, forKey: "Nota")
        tarefaRecord.setValue(data, forKey: "Data")
        publicDB.saveRecord(tarefaRecord, completionHandler: {(record, error) -> Void in
            println("OKay")
        })
    }
    
    func saveProvas (provas : NSString){
        let provasRecord = CKRecord(recordType: "Provas")
        provasRecord.setValue(provas, forKey: "Titulo")
        provasRecord.setValue(provas, forKey: "Materia")
        provasRecord.setValue(provas, forKey: "Status")
        provasRecord.setValue(provas, forKey: "Nota")
        provasRecord.setValue(provas, forKey: "Data")
        publicDB.saveRecord(provasRecord, completionHandler: {(record, error) -> Void in
            println("OKay")
        })
    }
    
    func updateTarefas(titulo : NSString, materia : NSString, status: NSNumber, nota: NSNumber, data: NSDate){
        var recordId:CKRecordID = CKRecordID(recordName: "Tarefas")
        publicDB.fetchRecordWithID(recordId, completionHandler: { record, error in
            if let fetchError = error {
                println("An error occurred in \(fetchError)")
            } else {
                let provasRecord = CKRecord(recordType: "Provas")
                provasRecord.setValue(self.provas, forKey: "Titulo")
                provasRecord.setValue(self.provas, forKey: "Materia")
                provasRecord.setValue(self.provas, forKey: "Status")
                provasRecord.setValue(self.provas, forKey: "Nota")
                provasRecord.setValue(self.provas, forKey: "Data")
            } 
        })
    }
    
    func fetchTarefas(insertRecord: CKRecord?){
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        
        let query = CKQuery(recordType: "Tarefas", predicate: predicate)
        query.sortDescriptors = [sort]
        
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            if error != nil{
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.errorUpdating(error)
                    return
                }
            } else {
                self.tarefas.removeAll()
                for record in results{
                    let tarefa = CKModel(record: record as! CKRecord, database: self.publicDB)
                    self.tarefas.append(tarefa)
                }
                
                if let tmp = insertRecord {
                    let tarefa = CKModel(record: insertRecord! as CKRecord, database: self.publicDB)
                    self.tarefas.insert(tarefa, atIndex: 0)
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.modelUpdated()
                    return
                }
                
            }
        }
        
    }
    
}

let cloudKitHelper = CloudKitHelper()
