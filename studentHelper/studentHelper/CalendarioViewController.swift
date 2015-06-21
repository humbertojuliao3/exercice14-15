//
//  CalendarioViewController.swift
//  studentHelper
//
//  Created by Sidney Silva on 6/21/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import CoreData

var arrayOrdenado = [Alerta]()

class CalendarioViewController: UITableViewController {
    var labelEmpty: UILabel!
    
    lazy var moContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = false
        
        labelEmpty = UILabel()
        labelEmpty.text = "Nenhuma tarefa encontrada"
        labelEmpty.font = UIFont(name: "Helvetica Neue-Light", size: 16)
        labelEmpty.textColor = UIColor.darkGrayColor()
        labelEmpty.textAlignment = NSTextAlignment.Center
        labelEmpty.sizeToFit()
        labelEmpty.frame = CGRectMake((self.tableView.bounds.size.width - labelEmpty.bounds.size.width) / 2,
            (self.tableView.bounds.size.height - labelEmpty.bounds.size.height) / 2,
            labelEmpty.bounds.size.width,
            labelEmpty.bounds.size.height)
        self.tableView.insertSubview(labelEmpty, atIndex: 0)
        
        if !EventNotificationManager.singleton.verificaAutorizacao() {
            EventNotificationManager.singleton.store.requestAccessToEntityType(EKEntityTypeEvent, completion:
                {[weak self] (granted: Bool, error: NSError!) -> Void in })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var error: NSError?
        
        let request = NSFetchRequest(entityName: "Alerta")
        
        arrayOrdenado = AlertaManager.sharedInstance.alertaOrdenado()
        
        tableView.reloadData()
        
        println(arrayOrdenado)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: CalendarioCell = self.tableView.dequeueReusableCellWithIdentifier("CalendarioCell") as! CalendarioCell
        
        var alert:Alerta
        
        alert = arrayOrdenado[indexPath.row]
        
        var data = alert.dataEntrega
        var dataFormatada = NSDateFormatter()
        var horaFormatada = NSDateFormatter()
        
        dataFormatada.dateFormat = "dd/MM/yyyy"
        horaFormatada.dateFormat = "HH:mm"
        
        var dataString = dataFormatada.stringFromDate(data)
        var horaString = horaFormatada.stringFromDate(data)
        
        cell.labelTitulo.text = alert.nomeAvaliacao
        cell.labelMateria.text = alert.disciplina
        cell.labelData.text = "\(dataString) (\(horaString))"
        
        println(arrayOrdenado[indexPath.row])
        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  arrayOrdenado.count == 0{
            labelEmpty.hidden = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else{
            labelEmpty.hidden = true
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        
        return arrayOrdenado.count
    }


}

class CalendarioCell: UITableViewCell {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelMateria: UILabel!
    @IBOutlet weak var labelData: UILabel!
    
}
