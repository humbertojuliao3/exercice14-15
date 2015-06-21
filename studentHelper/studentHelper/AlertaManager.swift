//
//  AlertaManager.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 10/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class AlertaManager {
    static let sharedInstance:AlertaManager = AlertaManager()
    static let entityName:String = "Alerta"
    lazy var managedContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()
    
    private init(){}
    
    func novoAlerta() -> Alerta {
        return NSEntityDescription.insertNewObjectForEntityForName(AlertaManager.entityName, inManagedObjectContext: managedContext) as! Alerta
    }
    
    func salvar() {
        var error:NSError?
        managedContext.save(&error)
        
        if let e = error {
            println("Could not save. Error: \(error), \(error!.userInfo)")
        }
    }
    
    func apagarAlerta(alerta:Alerta) {
        var error: NSError?
        managedContext.deleteObject(alerta)
        
        if let e = error {
            println("Could not delete. Error: \(error), \(error!.userInfo)")
        }
    }
    
    func buscarAlertas() -> Array<Alerta> {
        let fetchRequest = NSFetchRequest(entityName: AlertaManager.entityName)
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Alerta] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Alerta>()
    }
    
    func alertaOrdenado() -> Array<Alerta> {
        let fetchRequest = NSFetchRequest(entityName: AlertaManager.entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dataEntrega", ascending: true)]
        var error:NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Alerta] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        NSFetchRequest(entityName: "FetchRequest")
        
        return Array<Alerta>()
    }
}