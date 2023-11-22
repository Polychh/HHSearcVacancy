//
//  HHError.swift
//  HHSearch
//
//  Created by Polina on 17.11.2023.
//

import Foundation

enum HHError: String, Error{
    case invalidNameVacancy = "This nameVacancy created an invalid request. Please try again"
    case unableToComplete = "Unable to complete request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again"
    case invalidData = "The data received from the server can not be decoded. Please try again"
    case invalidDataFromServer = " The The data received from the server was invalid. Please try again"
    case invalidImageURL = "Can not convert String for Image"
}
