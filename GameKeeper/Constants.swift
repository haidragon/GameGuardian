//********************************************************************
//  Constants.swift
//  GameKeeper
//  Created by Phil on 4/20/17
//
//  Description: Hold constants for use around app.
//********************************************************************

import UIKit

enum Tone: Int{
    case dark
    case light
}
// Global for tone
var TONE: Tone = .light
let SHOW_ADS = true

// SIZING
var SCREEN_WIDTH: CGFloat{
    return UIScreen.main.bounds.width
}
var SCREEN_HEIGHT: CGFloat{
    return UIScreen.main.bounds.height
}

// Red: 0, Green: 180, Blue: 230
let COLOR_BLUE = UIColor(colorLiteralRed: 0.0, green: 0.71, blue: 0.90, alpha: 1.0)
let COLOR_BLUE_FADED = UIColor(colorLiteralRed: 0.0, green: 0.71, blue: 0.90, alpha: 0.4)

let FONT_MAIN = "Marker Felt"
