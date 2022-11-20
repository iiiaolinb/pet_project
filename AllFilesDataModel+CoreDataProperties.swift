//
//  AllFilesDataModel+CoreDataProperties.swift
//  
//
//  Created by Егор Худяев on 02.08.2022.
//
//

import Foundation
import CoreData


extension AllFilesDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AllFilesDataModel> {
        return NSFetchRequest<AllFilesDataModel>(entityName: "AllFilesDataModel")
    }

    @NSManaged public var path: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var preview: String?

}

extension AllFilesDataModel: Identifiable {}
