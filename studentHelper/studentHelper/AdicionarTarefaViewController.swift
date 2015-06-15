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
import EventKit

class AdicionarTarefaViewController: UITableViewController {
    @IBOutlet weak var textTitulo: UITextField!
    @IBOutlet weak var textMateria: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var eventStore = EKEventStore()
    
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
                
                var alerta = AlertaManager.sharedInstance.novoAlerta()
                alerta.nomeAvaliacao = textTitulo.text
                alerta.disciplina = textMateria.text
                alerta.dataEntrega = datePicker.date
                alerta.nota = 99.9
                alerta.status = true as NSNumber
                AlertaManager.sharedInstance.salvar()
        
                switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
                case .Authorized:
                    insereEventoiCalendar(alerta)
                case .Denied:
                    println("Sem Acesso")
                case .NotDetermined:
                    // 3
                    eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
                        {[weak self] (granted: Bool, error: NSError!) -> Void in
                            if granted {
                                self!.insereEventoiCalendar(alerta)
                            }
                            else {
                                println("Access denied")
                            }
                        })
                default:
                    println("Case Default")
                }
                
                //preparaNotificacao(tarefa)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
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

    func insereEventoiCalendar(alerta: Alerta) {
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent)
            as! [EKCalendar]
    
        for calendar in calendars {
            if calendar.title == "ioscreator" {
                let startDate = alerta.dataEntrega
                let endDate = startDate.dateByAddingTimeInterval(60 * 90)
            
                var event = EKEvent(eventStore: eventStore)
                event.calendar = calendar
            
                event.title = alerta.nomeAvaliacao + " - " + alerta.disciplina
                event.startDate = startDate
                event.endDate = endDate
            
                var error: NSError?
                let result = eventStore.saveEvent(event, span: EKSpanThisEvent, error: &error)
            
                if result == false {
                    if let theError = error {
                        println("An error occured \(theError)")
                    }
                }
            }
        }
    }

    
    func removerTeclado() {
        view.endEditing(true)
    }
}