//
//  EditarTarefaViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 04/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditarTarefaViewController: UITableViewController {
    @IBOutlet weak var textTitulo: UITextField!
    @IBOutlet weak var textMateria: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchStatus: UISwitch!
    @IBOutlet weak var textNota: UITextField!
    
    var tarefaTitulo: String!
    var tarefaDisciplina: String!
    var tarefaData: NSDate!
    var indexTarefas: Int!
    
    var alertaN:Alerta?
    
    let moContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remover Teclado
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removerTeclado")
        view.addGestureRecognizer(tap)
        
        alertaN = arrayData[indexSelected]
        
        if let s=alertaN{
            textTitulo.text = s.nomeAvaliacao
            textMateria.text = s.disciplina
            datePicker.date = s.dataEntrega
            textNota.text = s.nota.description
        }
        
        datePicker.minimumDate = NSDate()
        
        if arrayData[indexSelected].status as Bool {
            switchStatus.setOn(true, animated: true)
        }
        else{
            switchStatus.setOn(false, animated: true)
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @IBAction func salvarAction(sender: AnyObject) {
        if !textTitulo.text.isEmpty{
            if !textMateria.text.isEmpty{
                
                if alertaN == nil{
                    //getting the description
                    let sDescription = NSEntityDescription.entityForName("Alerta", inManagedObjectContext: moContext!)
                
                    //creating the Maneged Object to put in the CoreData
                    alertaN = Alerta(entity:sDescription!, insertIntoManagedObjectContext: moContext)
                }
                
                //setting atributes
                alertaN?.disciplina = textMateria.text
                alertaN?.nomeAvaliacao = textTitulo.text
                alertaN?.dataEntrega = datePicker.date
                alertaN?.status = NSNumber(bool: false)
                alertaN?.nota = 99.9
                
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
                
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }
        
    }
    
    func removerTeclado(){
        view.endEditing(true)
    }
}

extension String {
    var floatConverter: Float {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        if let result = converter.numberFromString(self) {
            return result.floatValue
        } else {
            converter.decimalSeparator = ","
            if let result = converter.numberFromString(self) {
                return result.floatValue
            }
        }
        return 0
    }
}