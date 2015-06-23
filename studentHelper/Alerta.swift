//
//  Alerta.swift
//  collegeHelper
//
//  Created by Humberto  Julião on 06/06/15.
//  Copyright (c) 2015 Humberto  Julião. All rights reserved.
//

import Foundation
import CoreData

class Alerta: NSManagedObject {

    @NSManaged var disciplina: String
    @NSManaged var nomeAvaliacao: String
    @NSManaged var dataEntrega: NSDate
    @NSManaged var status: NSNumber
    @NSManaged var nota: NSNumber
    @NSManaged var controle: NSNumber
}
