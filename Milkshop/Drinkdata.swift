//
//  Drinkdata.swift
//  Milkshop
//
//  Created by 劉家瑋 on 2020/7/25.
//  Copyright © 2020 劉瑄. All rights reserved.
//

import Foundation


   
struct DrinkData:Decodable {
    var image: String
    var name: String
    var price: Int
    var cal: String
}

struct Order {
    var documentId:String
    var datalist:String
    var countlist:String
    var pricelist:String
}

struct Cart:Equatable {
     var documentId:String
     var namelist:String
     var pricelist:Int
     var countlist:Int
     var callist:String
     var sugarlist:String
     var detaillist:String
     var temperaturelist:String
}

struct Orderdetail {
    var namelist:String
    var pricelist:Int
    var countlist:Int
    var callist:String
    var sugarlist:String
    var detaillist:String
    var temperaturelist:String
}

