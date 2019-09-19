//
//  UserObject.swift
//  Treasunnaire
//
//  Created by Bill Tanthowi Jauhari on 19/09/19.
//  Copyright © 2019 Batavia Hack Town. All rights reserved.
//

import UIKit
import CoreData

class UserObject: NSManagedObject {
    @NSManaged var fullname: String
    @NSManaged var email: String
    @NSManaged var password: String
}
