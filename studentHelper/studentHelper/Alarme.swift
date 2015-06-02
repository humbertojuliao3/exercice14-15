//
//  Alarme.swift
//  studentHelper
//
//  Created by Humberto  Julião on 02/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import UIKit

class Alarme: NSObject {
    var disciplina:NSString = ""
    var nomeAvaliacao:NSString = ""
    var dataEntrega:NSDate
    var status:NSString
    var nota:Float
    
    override init() {
        disciplina = ""  // Em outros construtores, apenas modifica-se disciplina, nomeAvaliacao e dataEntrega, mantendo status e nota como aqui está.
        nomeAvaliacao = ""
        dataEntrega = NSDate()
        status = "fazendo"
        nota = 99.0
    }
}
