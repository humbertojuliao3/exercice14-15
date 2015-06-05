//
//  TarefasViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 03/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit

var tarefasArray: [Alarme] = []
var indexSelected: Int!

class TarefasViewController: UITableViewController{
    
    var filteredTarefas = [Alarme]()
    
    var labelEmpty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        labelEmpty.frame = CGRectMake((size.width - labelEmpty.bounds.size.width) / 2,
            (size.height - labelEmpty.bounds.size.height) / 2,
            labelEmpty.bounds.size.width,
            labelEmpty.bounds.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        tableView.reloadData()
        
        println(tarefasArray)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TarefasCell = tableView.dequeueReusableCellWithIdentifier("TarefaCell", forIndexPath: indexPath) as! TarefasCell
        
        var data = tarefasArray[indexPath.row].dataEntrega
        var dataFormatada = NSDateFormatter()
        var horaFormatada = NSDateFormatter()
        
        dataFormatada.dateFormat = "dd/MM/yyyy"
        horaFormatada.dateFormat = "HH:mm"
        
        var dataString = dataFormatada.stringFromDate(data)
        var horaString = horaFormatada.stringFromDate(data)
        
        
        cell.labelTitulo.text = tarefasArray[indexPath.row].nomeAvaliacao
        cell.labelMateria.text = tarefasArray[indexPath.row].disciplina
        cell.labelData.text = "\(dataString) (\(horaString))"
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  tarefasArray.count == 0{
            labelEmpty.hidden = false
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        else{
            labelEmpty.hidden = true
            tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        }
        
        return tarefasArray.count
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            tarefasArray.removeAtIndex(indexPath.row)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexSelected = indexPath.row
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