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

let tuple1 = (materia: "Matematica", nome: "Prova 1", data: "20/06/2014 (18:30)")
let tuple2 = (materia: "Matematica", nome: "Prova 2", data: "25/06/2014 (21:00)")
let tuple3 = (materia: "Geografia", nome: "Trabalho de Mapas", data: "23/06/2014 (23:55)")
let tuple4 = (materia: "Geografia", nome: "Prova 1", data: "20/06/2014 (19:00)")
let tuple5 = (materia: "História", nome: "Prova Final", data: "21/06/2014 (20:05)")

var indexSelected: Int!

//var tarefasArray: [(materia: String, nome:String, data: String)] = [
//    tuple1,
//    tuple2,
//    tuple3,
//    tuple4,
//    tuple5
//]

class TarefasViewController: UITableViewController {
    //Tuplas para testes na Table View
    
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
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if sender!.identifier == "alterar" {
//            let view = segue.destinationViewController as! EditarTarefaViewController
//            view.tarefaTitulo
//        }
//    }
    
    
}



class TarefasCell: UITableViewCell {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelMateria: UILabel!
    @IBOutlet weak var labelData: UILabel!
    
}