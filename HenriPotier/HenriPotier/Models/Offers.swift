//
//  Offers.swift
//  HenriPotier
//
//  Created by Lefdili Alaoui Ayoub on 23/4/2022.
//

import Foundation

struct CommercialOffers: Codable {
    let offers: [Offer]
}

struct Offer: Codable {
    let type: String
    let sliceValue: Int?
    let value: Int
}



