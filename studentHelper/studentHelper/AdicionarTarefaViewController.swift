//
//  AdicionarTarefaViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 03/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdicionarTarefaViewController: UITableViewController {
    @IBOutlet weak var textTitulo: UITextField!
    @IBOutlet weak var textMateria: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let moContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remover Teclado
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removerTeclado")
        view.addGestureRecognizer(tap)
        
        datePicker.minimumDate = NSDate()
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @IBAction func adicionarTarefa(sender: AnyObject) {
        if !textTitulo.text.isEmpty{
            if !textMateria.text.isEmpty{
                
                //getting the description
                let sDescription = NSEntityDescription.entityForName("Alerta", inManagedObjectContext: moContext!)
                
                //creating the Maneged Object to put in the CoreData
                let alertaN = Alerta(entity:sDescription!, insertIntoManagedObjectContext: moContext)
                
                //setting atributes
                alertaN.disciplina = textMateria.text
                alertaN.nomeAvaliacao = textTitulo.text
                alertaN.dataEntrega = datePicker.date
                alertaN.status = NSNumber(bool: false)
                alertaN.nota = 99.9
                
                //treating errors
                var error: NSError?
                
                //saving...
                moContext?.save(&error)
                
                //save complete.
                
                if let err=error {
                    let a = UIAlertView(title: "Error", message: err.localizedFailureReason, delegate: nil, cancelButtonTitle: "OK")
                    a.show()
                }else{
                    let a = UIAlertView(title: "Sucesso!", message: "Seu alarme foi salvo", delegate: nil, cancelButtonTitle: "OK")
                    a.show()
                }

                preparaAlarme()

                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }        
    }
    
    func preparaAlarme(){
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            
            
            println("This is run on the background queue")
            if NSDate() == self.datePicker.date {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println("This is run on the main queue, after the previous code in outer block")
                })
            }
        })
    }
    
    func removerTeclado(){
        view.endEditing(true)
    }
}