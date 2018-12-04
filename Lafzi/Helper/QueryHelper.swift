//
//  FilterHelper.swift
//  Lafzi
//
//  Created by Alfat Saputra Harun on 02/12/18.
//  Copyright © 2018 Alfat Saputra Harun. All rights reserved.
//

import Foundation

class QueryHelper {
    private init(){}
    
    static func normalizeQuery(src: String, isVocal: Bool = true) -> String {
        var source =  toUpperCaseRemoveWhiteSpace(src: src)
        source = oToAAndEToI(src: source)
        source = removeDuplicateNear(src: source)
        source = useX(src: source)
        return restOfTransform(src: source, isVocal: isVocal)
    }
    
    private static func toUpperCaseRemoveWhiteSpace(src: String ) -> String {
        var source = src.uppercased()
        var regex = try! NSRegularExpression(pattern: "\\s+")
        var range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: " ")
        
        regex = try! NSRegularExpression(pattern: "\\-")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: " ")
        
        regex = try! NSRegularExpression(pattern: "[^A-Z`’'\\-\\s]")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "")
        
        return source
    }
    
    private static func oToAAndEToI(src: String) -> String {
        return src
            .replacingOccurrences(of: "O", with: "A")
            .replacingOccurrences(of: "E", with: "I")
    }
    
    private static func removeDuplicateNear(src: String) -> String {
        var regex = try! NSRegularExpression(pattern: "(B|C|D|F|G|H|J|K|L|M|N|P|Q|R|S|T|V|W|X|Y|Z)\\s?\\1+")
        var range = NSMakeRange(0, src.count)
        var source = regex.stringByReplacingMatches(in: src, options: [], range: range, withTemplate: "$1")
        
        regex = try! NSRegularExpression(pattern: "(KH|CH|SH|TS|SY|DH|TH|ZH|DZ|GH)\\s?\\1+")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "$1")
        
        regex = try! NSRegularExpression(pattern: "(A|I|U|E|O)\\1+")
        range = NSMakeRange(0, source.count)
        return regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "$1")
    }
    
    private static func useX(src: String) -> String {
        var source = src.replacingOccurrences(of: "AI", with: "AY")
        source = source.replacingOccurrences(of: "AU", with: "AW")

        var regex = try! NSRegularExpression(pattern: "^(A|I|U)")
        var range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "X$1")
        
        regex = try! NSRegularExpression(pattern: "\\s(A|I|U)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "X$1")
        
        regex = try! NSRegularExpression(pattern: "I(A|U)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "IX$1")
        
        regex = try! NSRegularExpression(pattern: "U(A|I)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "UX$1")
        
        regex = try! NSRegularExpression(pattern: "(A|I|U)NG\\s?(D|F|J|K|P|Q|S|T|V|Z)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "$1N$2")
        
        regex = try! NSRegularExpression(pattern: "N\\s?B")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "MB")
        
        source = source.replacingOccurrences(of: "DUNYA", with: "DUN_YA")
        source = source.replacingOccurrences(of: "BUNYAN", with: "BUN_YAN")
        source = source.replacingOccurrences(of: "QINWAN", with: "KIN_WAN")
        source = source.replacingOccurrences(of: "KINWAN", with: "KIN_WAN")
        source = source.replacingOccurrences(of: "SINWAN", with: "SIN_WAN")
        source = source.replacingOccurrences(of: "SHINWAN", with: "SIN_WAN")
        
        regex = try! NSRegularExpression(pattern: "N\\s?(N|M|L|R|Y|W)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "$1")
        
        source = source.replacingOccurrences(of: "DUN_YA", with: "DUNYA")
        source = source.replacingOccurrences(of: "BUN_YAN", with: "BUNYAN")
        source = source.replacingOccurrences(of: "KIN_WAN", with: "KINWAN")
        return source.replacingOccurrences(of: "SIN_WAN", with: "SINWAN")
    }
    
    private static func restOfTransform(src: String, isVocal: Bool) -> String {
        var regex = try! NSRegularExpression(pattern: "KH|CH")
        var range = NSMakeRange(0, src.count)
        var source = regex.stringByReplacingMatches(in: src, options: [], range: range, withTemplate: "H")
        
        regex = try! NSRegularExpression(pattern: "SH|TS|SY")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "S")
        
        regex = try! NSRegularExpression(pattern: "DH")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "D")
        
        regex = try! NSRegularExpression(pattern: "ZH|DZ")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "Z")
        
        regex = try! NSRegularExpression(pattern: "TH")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "T")
        
        regex = try! NSRegularExpression(pattern: "NG(A|I|U)")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "X$1")
        
        regex = try! NSRegularExpression(pattern: "GH")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "G")
        
        regex = try! NSRegularExpression(pattern: "'|`|’")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "X")
        
        regex = try! NSRegularExpression(pattern: "Q|K")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "K")
        
        regex = try! NSRegularExpression(pattern: "F|V|P")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "F")
        
        regex = try! NSRegularExpression(pattern: "J|Z")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "Z")
        
        regex = try! NSRegularExpression(pattern: "\\s")
        range = NSMakeRange(0, source.count)
        source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "")
        
        if !isVocal {
            regex = try! NSRegularExpression(pattern: "A|I|U")
            range = NSMakeRange(0, source.count)
            source = regex.stringByReplacingMatches(in: source, options: [], range: range, withTemplate: "")
        }
        return source
    }
}
