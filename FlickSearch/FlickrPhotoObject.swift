//
//  FlickrPhotoObject.swift
//  FlickSearch
//
//  Created by Lloyd Kevin Urbino on 5/24/16.
//  Copyright © 2016 Lloyd Kevin Urbino. All rights reserved.
//

import UIKit

class FlickrPhotoObject: NSObject {
    var thumbnail:UIImage!
    var largeImage:UIImage!
    var imageUrl:NSURL!
    var photoName:String!
    var photoID:String!
    var farm:Int!
    var server:String!
    var secret:String!
    
    override init() {
        super.init()
    }
}
