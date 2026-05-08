import Foundation

extension String {
    /// Returns the localized version of the string using the Localizable.strings file.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    /// Returns a localized string with arguments.
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
