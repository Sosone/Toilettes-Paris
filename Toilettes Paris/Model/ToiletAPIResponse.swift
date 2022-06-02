//
//  Toilet.swift
//  Toilettes Paris
//
//  Created by Anthony Laurent on 28/05/2022.
//

import Foundation

struct ToiletAPIResponse: Codable {
    let records: [Record]
}

struct Record: Codable {
    let fields: Field
}

struct Field: Codable {
    let horaire: String?
    let acces_pmr: String?
    let adresse: String?
    let geo_point_2d : [Double]?
}
