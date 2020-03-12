//
//  BigJsonKeyValue+CoreDataProperties.swift
//  HT13_PerformanceWithCoreData
//
//  Created by Maksym Korostelov on 3/12/20.
//  Copyright © 2020 Maksym Korostelov. All rights reserved.
//
//

import Foundation
import CoreData


extension BigJsonKeyValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigJsonKeyValue> {
        return NSFetchRequest<BigJsonKeyValue>(entityName: "BigJsonKeyValue")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?

}
