//
//  BigImageEntityHolder+CoreDataProperties.swift
//  HT13_PerformanceWithCoreData
//
//  Created by Maksym Korostelov on 3/12/20.
//  Copyright © 2020 Maksym Korostelov. All rights reserved.
//
//

import Foundation
import CoreData


extension BigImageEntityHolder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BigImageEntityHolder> {
        return NSFetchRequest<BigImageEntityHolder>(entityName: "BigImageEntityHolder")
    }

    @NSManaged public var bigImage: Data?

}
