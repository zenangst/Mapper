//
//  Mapper.swift
//  Mapper
//
//  Created by Christoffer Winterkvist on 01/03/15.
//
//

import Foundation

extension NSObject {
    
    private func propertyNames() -> NSArray {
        var propertyCount: UInt32 = 0
        var propertyList = class_copyPropertyList(self.classForCoder, &propertyCount)
        var properties: Array<AnyObject> = []
        var i: UInt32
        
        for (i = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            properties.append(propertyName as! String)
        }
        
        return properties
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        var propertyCount: UInt32 = 0
        var propertyList = class_copyPropertyList(self.classForCoder, &propertyCount)
        var properties: NSMutableDictionary = NSMutableDictionary.new()
        var i: UInt32
        
        for (i = 0; i < propertyCount; i++) {
            let property: objc_property_t = propertyList[Int(i)]
            let propertyName = NSString(UTF8String: property_getName(property))
            let propertyAttribute = NSString(UTF8String: property_getAttributes(property))
            let propertyKey = propertyName as String!
            let propertyValue :AnyObject = self.valueForKey(propertyKey)!
            
            properties[propertyKey] = propertyValue
        }
        
        return properties.copy() as! NSDictionary
    }
    
    func fill(dictionary: NSDictionary) {
        let propertyNames: NSArray = self.propertyNames()
        
        for (key, value) in dictionary {
            if (propertyNames.containsObject(key)) {
                self.setValue(value, forKey: key as! String)
            }
        }
    }
}