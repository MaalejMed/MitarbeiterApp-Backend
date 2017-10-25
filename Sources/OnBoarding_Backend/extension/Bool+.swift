import Foundation

extension Bool {
    init?(_ intValue: Int)
    {
        switch intValue
        {
        case 0:
            self.init(false)
        case 1:
            self.init(true)
        default:
            return nil
        }
    }
}
