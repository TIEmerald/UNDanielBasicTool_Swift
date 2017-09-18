//
//  UNDCurrencyFormatRelatedHelper.swift
//  Pods
//
//  Created by Erjian Ni on 17/9/17.
//
//

class UNDCurrencyFormatRelatedHelper: UNDBaseModel {
    
    public var usingLocaleIdentifier : String?
    
    public var usingCurrencyNumberFormatter : NumberFormatter{
        let returnFormatter = NumberFormatter()
        returnFormatter.numberStyle = .currency
        returnFormatter.locale = usingLocale
        returnFormatter.alwaysShowsDecimalSeparator = false
        returnFormatter.usesGroupingSeparator = true
        return returnFormatter
    }
    
    private var usingLocale : Locale{
        var returnLocale : Locale?
        if let unwrapedLocaleIdentifier = usingLocaleIdentifier {
            returnLocale = Locale(identifier: unwrapedLocaleIdentifier)
        }
        return returnLocale ?? Locale.current
    }

}
