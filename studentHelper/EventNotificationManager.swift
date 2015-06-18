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
            if i.title == "studentHelper" {
                isCriado = true
                break
            }
        }
        
        if !isCriado{
            //Calendario ainda não foi criado
            let calendario = EKCalendar(forEntityType: EKEntityTypeEvent, eventStore: store)
                
            //Alterar nome do calendario quando o nome do app mudar
                
            calendario.title = "studentHelper"
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
            if i.title == "studentHelper" {
                
    
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
    
    func apagarEvento(alerta: Alerta) {
        let firstDate :NSDate = alerta.dataEntrega.dateByAddingTimeInterval(-7 * 60 * 60 * 24)
        let cal = NSMutableArray()
        let calendars = store.calendarsForEntityType(EKEntityTypeEvent) as! Array<EKCalendar>
        
        
        for calendar in calendars {
            
            if calendar.title == "studentHelper" {
                cal.addObject(calendar)
                break
            }
        }
        
        let pred = store.predicateForEventsWithStartDate(firstDate, endDate: alerta.dataEntrega.dateByAddingTimeInterval(60 * 60 * 24), calendars: cal as [AnyObject]);
        
        let eventos = NSMutableArray(array: store.eventsMatchingPredicate(pred))
        var contDias = 7
        
        for e in eventos {
            let evento = e as! EKEvent
            var error:NSError?
            
            if evento.title == alerta.nomeAvaliacao + " - " + alerta.disciplina + " (Faltam \(contDias) dia(s))" {
            
                store.removeEvent(evento, span: EKSpanThisEvent, error: &error);
                if(error != nil){
                    println("Could not save the event on calendar. Error: \(e)")
                }
                
                contDias--
                
            }
                
            else if evento.title == alerta.nomeAvaliacao + " - " + alerta.disciplina {
                store.removeEvent(evento, span: EKSpanThisEvent, error: &error);
                if(error != nil){
                    println("Could not save the event on calendar. Error: \(e)")
                }
            }
        }
        
    }
    
    func eventoConcluido(alerta: Alerta) {
        let firstDate :NSDate = alerta.dataEntrega.dateByAddingTimeInterval(-7 * 60 * 60 * 24)
        let cal = NSMutableArray()
        let calendars = store.calendarsForEntityType(EKEntityTypeEvent) as! Array<EKCalendar>
        
        
        for calendar in calendars {
            
            if calendar.title == "studentHelper" {
                cal.addObject(calendar)
                break
            }
        }
        
        let pred = store.predicateForEventsWithStartDate(firstDate, endDate: alerta.dataEntrega.dateByAddingTimeInterval(-60 * 60 * 24), calendars: cal as [AnyObject]);
        
        let eventos = NSMutableArray(array: store.eventsMatchingPredicate(pred))
        var contDias = 7
        
        for e in eventos {
            let evento = e as! EKEvent
            var error:NSError?
            
            if evento.title == alerta.nomeAvaliacao + " - " + alerta.disciplina + " (Faltam \(contDias) dia(s))" {
                
                store.removeEvent(evento, span: EKSpanThisEvent, error: &error);
                if(error != nil){
                    println("Could not save the event on calendar. Error: \(e)")
                }
                
                contDias--
                
            }
                
            else if evento.title == alerta.nomeAvaliacao + " - " + alerta.disciplina {
                store.removeEvent(evento, span: EKSpanThisEvent, error: &error);
                if(error != nil){
                    println("Could not save the event on calendar. Error: \(e)")
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