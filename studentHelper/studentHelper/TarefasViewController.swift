//
//  TarefasViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 03/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import CoreData

var indexSelected: Int!
var arrayData = [Alerta]()

class TarefasViewController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var labelEmpty: UILabel!
    var filteredAlertas = [Alerta]()
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        // Filter the array using the filter method
        self.filteredAlertas = arrayData.filter({( sAlerta: Alerta) -> Bool in
            let categoryMatch = (scope == "All") || (sAlerta == scope)
            let stringMatch = sAlerta.nomeAvaliacao.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    lazy var moContext:NSManagedObjectContext = {
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var c = appDelegate.managedObjectContext
        return c!
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.searchDisplayController
        tableView.allowsMultipleSelection = false
        
        labelEmpty = UILabel()
        labelEmpty.text = "Nenhuma tarefa encontrada"
        labelEmpty.font = UIFont(name: "Helvetica Neue Light", size: 16)
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
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        labelEmpty.frame = CGRectMake((size.width - labelEmpty.bounds.size.width) / 2,
            (size.height - labelEmpty.bounds.size.height) / 2,
            labelEmpty.bounds.size.width,
            labelEmpty.bounds.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var error: NSError?
        
        let request = NSFetchRequest(entityName: "Alerta")
        
        arrayData = AlertaManager.sharedInstance.buscarAlertas()
        
        tableView.reloadData()
        
        println(arrayData)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TarefasCell = self.tableView.dequeueReusableCellWithIdentifier("TarefaCell") as! TarefasCell
        
        var alert:Alerta
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            alert = filteredAlertas[indexPath.row]
            cell.labelTitulo.text = alert.nomeAvaliacao
            cell.labelMateria.hidden = true
            cell.labelData.hidden = true
            
        } else {
            alert = arrayData[indexPath.row]
            
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
        }
        

        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            if  arrayData.count == 0{
                labelEmpty.hidden = false
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            }
            else{
                labelEmpty.hidden = true
                tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            }
            return self.filteredAlertas.count
        } else {
            if  arrayData.count == 0{
                labelEmpty.hidden = false
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            }
            else{
                labelEmpty.hidden = true
                tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            }
        
            return arrayData.count
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //delete comming soon...
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // remove object
            EventNotificationManager.singleton.apagarEvento(arrayData[indexPath.row])
            AlertaManager.sharedInstance.apagarAlerta(arrayData[indexPath.row])
            AlertaManager.sharedInstance.salvar()
            arrayData = AlertaManager.sharedInstance.buscarAlertas()
            
            
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            let alert:Alerta = self.filteredAlertas[indexPath.row]
            var valor:Int=0
            for var i = 0; i < arrayData.count; i=i+1{
                if arrayData[i] == alert{
                    valor=i
                break
                }
            }
            indexSelected = valor
            
        } else {
            indexSelected = indexPath.row
        }
    }
    
    @IBAction func editarItemAction(sender: AnyObject) {
        if editing {
            super.setEditing(false, animated: false)
        }
        else {
            super.setEditing(true, animated: true)
        }
    }
}



class TarefasCell: UITableViewCell {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelMateria: UILabel!
    @IBOutlet weak var labelData: UILabel!
    
}