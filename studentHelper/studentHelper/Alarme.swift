//
//  Alarme.swift
//  studentHelper
//
//  Created by Humberto  Julião on 02/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import UIKit

class Alarme{
    var disciplina: String = ""
    var nomeAvaliacao: String = ""
    var dataEntrega:NSDate
    var status: String!
    var nota:Float!
    
    init(nome: String, materia: String, data: NSDate) {
        disciplina = materia
        nomeAvaliacao = nome
        dataEntrega = data
        status = "fazendo"
        nota = 99.0
    }
}
