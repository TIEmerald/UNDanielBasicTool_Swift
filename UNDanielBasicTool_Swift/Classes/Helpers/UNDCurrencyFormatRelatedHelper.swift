//
//  UNDCurrencyFormatRelatedHelper.swift
//  Pods
//
//  Created by Erjian Ni on 17/9/17.
//
//

class UNDCurrencyFormatRelatedHelper: UNDBaseModel {
    
    //// MARK : - Properties
    public var usingLocaleIdentifier : String?
    
    public var usingCurrencyNumberFormatter : NumberFormatter{
        let returnFormatter = NumberFormatter()
        returnFormatter.numberStyle = .currency
        returnFormatter.locale = usingLocale
        returnFormatter.alwaysShowsDecimalSeparator = false
        returnFormatter.usesGroupingSeparator = true
        return returnFormatter
    }
    
    
    //// MARK : Private
    private var usingLocale : Locale{
        var returnLocale : Locale?
        if let unwrapedLocaleIdentifier = usingLocaleIdentifier {
            returnLocale = Locale(identifier: unwrapedLocaleIdentifier)
        }
        return returnLocale ?? Locale.current
    }
    
    //// MARK : - General Methods
    public func logCurrentLocaleInformation() -> String{
        let checkingLocale = usingLocale
        let checkingCurrencyNumberFormatter = usingCurrencyNumberFormatter
        let logMessage = "Locale Identifier : \(checkingLocale.identifier) \n Locale Language Code : \(String(describing: checkingLocale.languageCode)) \n Currency Symbol : \(String(describing: checkingLocale.currencySymbol)) \n Currency Code : \(String(describing: checkingLocale.currencyCode)) \n Grouping Seperator : \(String(describing: checkingLocale.groupingSeparator)) \n Decimal Seperator : \(String(describing: checkingLocale.decimalSeparator)) \n Maximu Fraction Digits : \(checkingCurrencyNumberFormatter.maximumFractionDigits) \n Maximum Integer Digits : \(checkingCurrencyNumberFormatter.maximumIntegerDigits) \n Group Size : \(checkingCurrencyNumberFormatter.groupingSize)"
        self.performConsoleLog(logMessage);
        return logMessage
    }

    //// If the currency value you passed in is empty, we will treat it as 0.
    public func formatCurrencyStringFromValue(_ currencyValue: NSNumber?) -> String {
        return usingCurrencyNumberFormatter.string(from: currencyValue ?? NSNumber.init(value: 0))!
    }
}
