//
//  EditarTarefaViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 04/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remover Teclado
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removerTeclado")
        view.addGestureRecognizer(tap)
        
        textTitulo.text = tarefasArray[indexSelected].nomeAvaliacao
        textMateria.text = tarefasArray[indexSelected].disciplina
        datePicker.date = tarefasArray[indexSelected].dataEntrega
        textNota.text = tarefasArray[indexSelected].nota.description
        
        datePicker.minimumDate = NSDate()
        
        if tarefasArray[indexSelected].status {
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
                let tarefa = Alarme(nome: textTitulo.text, materia: textMateria.text, data: datePicker.date)
                tarefa.nota = (textNota.text as NSString).floatValue
                if switchStatus.on {
                    tarefa.status = true
                }
                else{
                    tarefa.status = false
                }
                
                tarefasArray[indexSelected] = tarefa
                
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
        
    }
    
    func removerTeclado(){
        view.endEditing(true)
    }
}