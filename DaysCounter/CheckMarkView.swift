import UIKit

final class CheckMarkView: UIView {
    public var color: UIColor = UIColor.green
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        backgroundColor = .clear
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.clear(rect)
        
        let shadow = UIColor.black
        let shadowOffset = CGSize(width: 0.1, height: -0.1)
        let shadowBlurRadius: CGFloat = 2.5
        
        let group = CGRect(x: bounds.minX + 3, y: bounds.minY + 3, width: bounds.width - 6, height: bounds.height - 6)
        
        let ovalPath = UIBezierPath(ovalIn: group)
        context.saveGState()
        context.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
        color.setFill()
        ovalPath.fill()
        context.restoreGState()
        
        UIColor.white.setStroke()
        ovalPath.lineWidth = 0.5
        ovalPath.stroke()
        
        let checkMarkPath = UIBezierPath()
        checkMarkPath.move(to: CGPoint(x: group.minX + 0.27083 * group.width, y: group.minY + 0.54167 * group.height))
        checkMarkPath.addLine(to: CGPoint(x: group.minX + 0.41667 * group.width, y: group.minY + 0.68750 * group.height))
        checkMarkPath.addLine(to: CGPoint(x: group.minX + 0.75000 * group.width, y: group.minY + 0.35417 * group.height))
        checkMarkPath.lineCapStyle = .square
        checkMarkPath.lineWidth = 1.3
        checkMarkPath.stroke()
    }
}
