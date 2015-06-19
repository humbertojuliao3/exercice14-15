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
import EventKit

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
    
    var alertaN:Alerta!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remover Teclado
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removerTeclado")
        view.addGestureRecognizer(tap)
        
        alertaN = arrayData[indexSelected]
        
        //if let s = alertaN{
            textTitulo.text = alertaN.nomeAvaliacao
            textMateria.text = alertaN.disciplina
            datePicker.date = alertaN.dataEntrega
            textNota.text = alertaN.nota.description
        //}
        
        datePicker.minimumDate = NSDate()
        
        if alertaN.status as Bool {
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
                
                //setting atributes
                alertaN.disciplina = textMateria.text
                alertaN.nomeAvaliacao = textTitulo.text
                alertaN.dataEntrega = datePicker.date
                
                if switchStatus.on {
                    alertaN.status = true
                    EventNotificationManager.singleton.apagarEvento(alertaN)
                    EventNotificationManager.singleton.novoEvento(alertaN)
                }
                else{
                    alertaN.status = false
                    EventNotificationManager.singleton.eventoConcluido(alertaN)
                }
                alertaN.nota = textNota.text.floatConverter
                
                if textNota.text == "" {
                    alertaN.nota = NSNumber(float: 99.9)
                }
                
                //saving...
                AlertaManager.sharedInstance.salvar()

                self.navigationController?.popToRootViewControllerAnimated(true)
                
                cloudKitHelper.updateTarefas(alertaN.nomeAvaliacao, materia: alertaN.disciplina, status: alertaN.status, nota: alertaN.nota, data: alertaN.dataEntrega)
                
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