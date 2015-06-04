//
//  TarefasViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 03/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit

let tuple1 = (materia: "Matematica", nome: "Prova 1", data: "20/06/2014 (18:30)")
let tuple2 = (materia: "Matematica", nome: "Prova 2", data: "25/06/2014 (21:00)")
let tuple3 = (materia: "Geografia", nome: "Trabalho de Mapas", data: "23/06/2014 (23:55)")
let tuple4 = (materia: "Geografia", nome: "Prova 1", data: "20/06/2014 (19:00)")
let tuple5 = (materia: "História", nome: "Prova Final", data: "21/06/2014 (20:05)")

var tarefasArray: [(materia: String, nome:String, data: String)] = [
    tuple1,
    tuple2,
    tuple3,
    tuple4,
    tuple5
]

class TarefasViewController: UITableViewController {
    //Tuplas para testes na Table View
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = false
                
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
        
        println(tarefasArray)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TarefasCell = tableView.dequeueReusableCellWithIdentifier("TarefaCell", forIndexPath: indexPath) as! TarefasCell
        
        cell.labelTitulo.text = tarefasArray[indexPath.row].nome
        cell.labelMateria.text = tarefasArray[indexPath.row].materia
        cell.labelData.text = tarefasArray[indexPath.row].data
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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