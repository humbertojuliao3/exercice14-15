//
//  DesempenhoViewController.swift
//  studentHelper
//
//  Created by Gabriel Alberto de Jesus Preto on 08/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import UIKit
import Social

class DesempenhoViewController: UITableViewController {
    @IBOutlet weak var buttonShare: UIBarButtonItem!
    @IBOutlet weak var pieGraphView: PieGraphViewController!
    @IBOutlet weak var labelPercentage: UILabel!
    
    var notasArray: Array<Alerta> = [Alerta]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        notasArray.removeAll(keepCapacity: false)
        
        for (var i = 0; i < arrayData.count; i++){
            if arrayData[i].nota.doubleValue != NSNumber(float: 99.9) {
                notasArray.append(arrayData[i])
            }
        }
        //ordena o algoritmo por ordem da materia
        notasArray.sort({ $0.disciplina < $1.disciplina })
        
        tableView.reloadData()
        
        //Grafico de atividades concluidas
        
        
        var contTarefaOk = 0
        for tarefa in arrayData {
            if tarefa.status == false {
                contTarefaOk++
            }
        }
        var percentage = (Double(contTarefaOk * 100)) / Double(arrayData.count)
            
        pieGraphView.piePercentage = percentage
        
        if percentage.isNaN {
            labelPercentage.text = "0%"
        }
        else{
            labelPercentage.text = String(format: "%.1f", Float(percentage)) + "%"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: DesempenhoCell = tableView.dequeueReusableCellWithIdentifier("DesempenhoCell", forIndexPath: indexPath) as! DesempenhoCell
        
        
        cell.labelTitulo.text = notasArray[indexPath.row].nomeAvaliacao
        cell.labelMateria.text = notasArray[indexPath.row].disciplina
        cell.labelNota.text = notasArray[indexPath.row].nota.description
        
        
        cell.viewNota.layer.borderColor = UIColor.whiteColor().CGColor
        cell.viewNota.layer.borderWidth = 0.1
        cell.viewNota.layer.cornerRadius = 35
        cell.viewNota.clipsToBounds = true
        
        var nota = notasArray[indexPath.row].nota.doubleValue
        
        if nota  <= 4.9 {
            cell.viewNota.backgroundColor = UIColor(red:222/265, green:70/265, blue:99/265, alpha: 1)
        }
        else if nota >= 5.0 && nota <= 7.4 {
            cell.viewNota.backgroundColor = UIColor(red: 251/265, green: 191/265, blue: 85/265, alpha: 1)
        }
        else if nota >= 7.5 {
            cell.viewNota.backgroundColor = UIColor(red: 82/265, green: 207/265, blue: 196/265, alpha: 1)
        }
        else{
            cell.viewNota.backgroundColor = UIColor.lightGrayColor()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        println(notasArray.count)
        
        return notasArray.count
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        
        
        
        
        if notasArray.count > 0 {
        
            let alerta: UIAlertController = UIAlertController (title: "Compartilhar minhas Notas", message: "Selecione uma opção para compartilhar o seu desempenho", preferredStyle: .ActionSheet)
        
            let facebookAction: UIAlertAction = UIAlertAction (title: "Facebook", style: .Default) { action -> Void in
                
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    
                    var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                    var notasTexto = ""
                    
                    for(var i = 0; i < self.notasArray.count; i++){
                        notasTexto += self.notasArray[i].disciplina + " - " + self.notasArray[i].nomeAvaliacao + " - " + self.notasArray[i].nota.description + "\n"
                    }
                    
                    fbShare.setInitialText("Olá, estou usando o APP para controle de notas escolares. \n Segue abaixo meu desempenho: \n \n" + notasTexto)
                    fbShare.addImage(UIImage(named: "logoShare"))
                    
                    self.presentViewController(fbShare, animated: true, completion: nil)
                    
                }
                else {
                    var alert = UIAlertController(title: "Autenticação de Conta", message: "Por favor, faça o seu login do facebook em Ajustes > Facebook", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            
            }
        
            alerta.addAction(facebookAction)
        
            let twitterAction: UIAlertAction = UIAlertAction(title: "Twitter", style: .Default) { action -> Void in
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
                    
                    var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                    var notasTexto = ""
                    
                    for(var i = 0; i < self.notasArray.count; i++){
                        notasTexto += self.notasArray[i].disciplina + " - " + self.notasArray[i].nomeAvaliacao + " - " + self.notasArray[i].nota.description + "\n"
                    }
                    
                    tweetShare.setInitialText("Olá, estou usando o APP para controle de notas escolares. \n Segue abaixo meu desempenho: \n \n" + notasTexto)
                    tweetShare.addImage(UIImage(named: "logoShare"))
                    
                    self.presentViewController(tweetShare, animated: true, completion: nil)
                    
                } else {
                    
                    var alert = UIAlertController(title: "Autenticação de conta", message: "Por favor, faça o seu login do Twitter em Ajustes > Twitter", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        
            alerta.addAction(twitterAction)
        
            let cancelarAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .Cancel) { action -> Void in}
            alerta.addAction(cancelarAction)
            
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.Pad {
                alerta.modalPresentationStyle = UIModalPresentationStyle.Popover
                
                let popover = alerta.popoverPresentationController
                
                let itemView: UIView = buttonShare.valueForKey("view") as! UIView
            
                popover!.sourceView = itemView
                popover!.sourceRect = itemView.bounds
            }
            
            self.presentViewController(alerta, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if notasArray.count == 0 {
            return "NENHUMA NOTA CADASTRADA"
        }
        else {
            return "NOTAS"
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 94
    }

}

class DesempenhoCell: UITableViewCell {
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelMateria: UILabel!
    @IBOutlet weak var labelNota: UILabel!
    @IBOutlet weak var viewNota: UIView!
}
