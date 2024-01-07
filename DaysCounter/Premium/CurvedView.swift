import UIKit

final class CurvedView: UIView {
    var primaryColor: UIColor?
    var secondaryColor: UIColor?
    
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
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - 0.1*rect.height))
        path.addCurve(to:
            CGPoint(x: rect.maxX, y: rect.maxY - 0.1*rect.height),
                      controlPoint1: CGPoint(x: rect.minX + 0.25*rect.width, y: rect.maxY),
                      controlPoint2: CGPoint(x: rect.maxX - 0.25*rect.width, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addClip()
        
        let cgColors = [primaryColor?.cgColor, secondaryColor?.cgColor]
        guard let gradient = CGGradient(colorsSpace: nil, colors: cgColors as CFArray, locations: nil)
            else { return }

        context.drawLinearGradient(gradient, start: CGPoint(x: rect.minX + rect.width/2, y: rect.minY), end: CGPoint(x: rect.minX + rect.width/2, y: rect.maxY), options: [])
    }
}
