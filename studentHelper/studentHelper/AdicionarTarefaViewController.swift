//
//  AdicionarTarefaViewController.swift
//  collegeHelper
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
                var statusString = ""
                var data = ""
                var alerta = AlertaManager.sharedInstance.novoAlerta()
                alerta.nomeAvaliacao = textTitulo.text
                alerta.disciplina = textMateria.text
                alerta.dataEntrega = datePicker.date
                alerta.nota = 99.9
                alerta.status = true as NSNumber
                if alerta.status == 0 {
                    statusString = "Não realizado"
                }else{
                    statusString = "Realizado"
                }
                var dataString = "\(alerta.dataEntrega)"
                AlertaManager.sharedInstance.salvar()
                
                // Cria Evento
                if EventNotificationManager.singleton.verificaAutorizacao() {
                    EventNotificationManager.singleton.novoCalendario()
                    EventNotificationManager.singleton.novoEvento(alerta)
                }
                
                //preparaNotificacao(tarefa)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
            }
        }        
    }


    
    func removerTeclado() {
        view.endEditing(true)
    }
}