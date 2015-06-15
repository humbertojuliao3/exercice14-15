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
    
//    lazy var moContext:NSManagedObjectContext = {
//        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        var c = appDelegate.managedObjectContext
//        return c!
//        }()
    
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
                var notaString = "\(alerta.nota)"
                alerta.status = true as NSNumber
                if alerta.status == 0 {
                    statusString = "Não realizado"
                }else{
                    statusString = "Realizado"
                }
                var dataString = "\(alerta.dataEntrega)"
                AlertaManager.sharedInstance.salvar()
                
                println("Data: \(dataString)")
                println("Nota: \(notaString)")
                
                self.navigationController?.popViewControllerAnimated(true)
                
                //preparaNotificacao(tarefa)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
                cloudKitHelper.saveTarefas(alerta.nomeAvaliacao, materia: alerta.disciplina, status: statusString, nota: notaString, data: dataString)
                
            }
        }        
    }
    
//    func preparaNotificacao(tarefa: Alarme){
//        var notificacao = UILocalNotification()
//        notificacao.fireDate = NSDate(timeIntervalSinceNow: 5)
//        notificacao.alertTitle = "Atenção, data de tarefas chegando"
//        notificacao.alertBody = "Fique atento, pois faltas xx dias para \(tarefa.nomeAvaliacao) - \(tarefa.disciplina)"
//        notificacao.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.sharedApplication().scheduleLocalNotification(notificacao)
//        
//        
//    }
    
    func removerTeclado(){
        view.endEditing(true)
    }
}