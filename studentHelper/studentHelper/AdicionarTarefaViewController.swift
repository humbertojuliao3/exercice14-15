//
//  AdicionarTarefaViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 03/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit

class AdicionarTarefaViewController: UITableViewController {
    @IBOutlet weak var textTitulo: UITextField!
    @IBOutlet weak var textMateria: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remover Teclado
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removerTeclado")
        view.addGestureRecognizer(tap)
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @IBAction func adicionarTarefa(sender: AnyObject) {
        
        if !textTitulo.text.isEmpty{
            if !textMateria.text.isEmpty{
                tarefasArray.append(materia: "Inglês", nome: "Prova Final", data: "03/06/2015 (20:24)")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }        
    }
    
    
    
    
    
    func removerTeclado(){
        view.endEditing(true)
    }
}