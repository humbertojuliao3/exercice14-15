//
//  EventNotificationManager.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 16/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class EventNotificationManager: NSObject {
    
    static let singleton = EventNotificationManager()
    
    var store: EKEventStore;
    
    private override init(){
        
        store = EKEventStore()
        
    }
    
    func novoCalendario(){
        let arrayCalendarios = store.calendarsForEntityType(EKEntityTypeEvent) as! Array<EKCalendar>
        var isCriado = false
        
        for i in arrayCalendarios{
            //Alterar nome do calendario quando o nome do app mudar
            if i.title == "calendario" {
                isCriado = true
                break
            }
        }
        
        if !isCriado{
            //Calendario ainda não foi criado
            let calendario = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: store)
                
            //Alterar nome do calendario quando o nome do app mudar
                
            calendario.title = "calendario"
            calendario.CGColor = UIColor(red: 237/265, green: 37/265, blue: 75/265, alpha: 1).CGColor
                
                
            for source in store.sources(){
                if (source.sourceType.value == EKSourceTypeLocal.value){
                    calendario.source = source as! EKSource
                }
            }
                
            var error : NSError?;
            store.saveCalendar(calendario, commit: true, error: &error);
                
            if let e = error {
                println("Could not save the calendar. Error: \(error), \(error!.userInfo)")
            }
            else{
                println("Calendario ainda nao criado")
            }
        }
        else{
            println("Calendario ja criado")
        }
        
    }
    
    func novoEvento (alerta: Alerta) {
        let arrayCalendarios = store.calendarsForEntityType(EKEntityTypeEvent) as! Array<EKCalendar>
        for i in arrayCalendarios{
            
            //Alterar nome do calendario quando o nome do app mudar
            if i.title == "calendario" {
                
    
                for (var dia:Double = 7 ; dia >= 0; dia--){
                    
                    var event = EKEvent(eventStore: store)
                    event.calendar = i
                    
                    if dia != 0{
                        let diaString = String(format: "%g", dia)
                        event.title = alerta.nomeAvaliacao + " - " + alerta.disciplina + " (Faltam \(diaString) dia(s))"
                        event.notes = "Programe-se! \nFaltam \(diaString) dia(s)"
                        event.startDate = alerta.dataEntrega.dateByAddingTimeInterval( -dia * 60 * 60 * 24)
                        event.endDate = event.startDate.dateByAddingTimeInterval(1 * 60 * 60)
                        event.addAlarm(EKAlarm(relativeOffset: -30))
                    }
                    else{
                        event.title = alerta.nomeAvaliacao + " - " + alerta.disciplina
                        event.notes = "É hoje! \nHoje você tem \(event.title) "
                        event.startDate = alerta.dataEntrega
                        let dataFinal = alerta.dataEntrega.dateByAddingTimeInterval(1 * 60 * 60)
                        event.endDate = dataFinal
                        event.addAlarm(EKAlarm(relativeOffset: -60*60))
                    }
                
                    // Salvar evento no calendario
                    var error: NSError?
                    let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
                
                
                    if result == false {
                        if let e = error {
                            println("Could not save the event on calendar. Error: \(e)")
                        }
                    }
                }
                
            }
        }
    }
    
    
    func verificaAutorizacao() -> Bool{
        switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) {
            case .Authorized:
                return true;
            case .Denied:
                return false;
            case .NotDetermined:
                return false;
            default:
                return false;
        }
    }
}