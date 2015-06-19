//
//  IcloudViewController.swift
//  studentHelper
//
//  Created by Sidney Silva on 6/17/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import UIKit

class IcloudViewController: UIViewController {
    
    var arrayData = [Alerta]()
    var arrayCloud = [Alerta]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveInICloud(sender: AnyObject) {
        arrayData = AlertaManager.sharedInstance.buscarAlertas()
        println(arrayData.count)
        println(arrayData[0].nomeAvaliacao)
        for (var i = 0; i < arrayData.count; i++) {
            cloudKitHelper.saveTarefas(arrayData[i].nomeAvaliacao, materia: arrayData[i].disciplina, status: arrayData[i].status, nota: arrayData[i].nota, data: arrayData[i].dataEntrega)
        }
    }
}
