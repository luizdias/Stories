import UIKit

extension UIColor {
    static let mainTextColor = UIColor.rgb(r: 255, g: 255, b: 255)
    static let highlightColor = UIColor.rgb(r: 50, g: 199, b: 242)
    static let wattpadDefaultColor = UIColor.rgb(r: 236, g: 93, b: 44)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
