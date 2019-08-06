//
//  KiStarRateView.swift
//  LinkTower
//
//  Created by Hanson on 2018/6/10.
//  Copyright © 2018年 Hanson. All rights reserved.
//

import UIKit

public enum StarRatingType {
    case rate
    case half
    case fill

    static func type(by type: String) -> StarRatingType {
        switch type {
        case "rate":
            return .rate
        case "half":
            return .half
        case "fill":
            return .fill
        default:
            return .rate
        }
    }
}

public protocol StarRatingDelegate: class {
    func StarRatingValueChanged(view: StarRatingView, value: CGFloat)
}

public struct StarRatingAttribute {
    var type: StarRatingType = .rate
    var point: CGFloat = 16
    var spacing: CGFloat = 4
    var emptyColor: UIColor = .lightGray
    var fillColor: UIColor = .darkGray

    public init() {}

    public init(type: StarRatingType, point: CGFloat, spacing: CGFloat, emptyColor: UIColor, fillColor: UIColor) {
        self.type = type
        self.point = point
        self.spacing = spacing
        self.emptyColor = emptyColor
        self.fillColor = fillColor
    }
}

@IBDesignable
public class StarRatingView: UIView {
    public weak var delegate: StarRatingDelegate?

    public var type: StarRatingType = .rate {
        didSet {
            updateLocation(CGPoint(x: self.currentWidth, y: 0))
            setNeedsDisplay()
        }
    }
    @IBInspectable
    internal var typeString: String = "rate" {
        didSet {
            self.type = StarRatingType.type(by: typeString)
        }
    }
    @IBInspectable
    public var current: CGFloat = 0 {
        didSet {
            self.currentWidth = rateToWidth(self.current)
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var max: Int = 0 {
        didSet {
            self.maxWidth = rateToWidth(CGFloat(self.max))
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable
    public var spacing: CGFloat = 0 {
        didSet {
            if self.spacing < 0 {
                self.spacing = 0
            }

            self.currentWidth = rateToWidth(self.current)
            self.maxWidth = rateToWidth(CGFloat(self.max))
            self.emptyStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.emptyColor)
            self.fillStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.fillColor)
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable
    public var point: CGFloat = 0 {
        didSet {
            self.currentWidth = rateToWidth(self.current)
            self.maxWidth = rateToWidth(CGFloat(self.max))
            self.emptyStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.emptyColor)
            self.fillStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.fillColor)
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }
    @IBInspectable
    public var emptyColor: UIColor = UIColor.lightGray {
        didSet {
            self.emptyStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.emptyColor)
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var fillColor: UIColor = UIColor.black {
        didSet {
            self.fillStar = makeStarImage(pt: self.point, spacing: self.spacing, color: self.fillColor)
            setNeedsDisplay()
        }
    }

    private var currentWidth: CGFloat = 0
    private var maxWidth: CGFloat = 0
    private var emptyStar: UIImage?
    private var fillStar: UIImage?

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func configure(_ attribute: StarRatingAttribute, current: CGFloat = 0, max: Int = 0) {
        self.type = attribute.type
        self.point = attribute.point
        self.spacing = attribute.spacing
        self.emptyColor = attribute.emptyColor
        self.fillColor = attribute.fillColor

        self.current = current
        self.max = max

        self.backgroundColor = .clear
        self.frame.size = self.intrinsicContentSize
    }

    private func rateToWidth(_ rate: CGFloat) -> CGFloat {
        var width = self.point * CGFloat(rate)
        width = width + CGFloat(ceil(rate) - 1) * self.spacing

        return width
    }

    private func makeStar(_ size: CGFloat, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        currentContext.setFillColor(color.cgColor)
        currentContext.setStrokeColor(color.cgColor)
        // 设置起点（重复点）
        currentContext.move(to: getVerTex(0, size: size, isOutside: true))
        for index in 0 ..< 5 {
            // 外接圆顶点
            currentContext.addLine(to: getVerTex(index, size: size, isOutside: true))
            // 内接圆顶点
            currentContext.addLine(to: getVerTex(index, size: size, isOutside: false))
        }

        currentContext.closePath()
        currentContext.fillPath()
        let star = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return star
    }
    
    /// 计算顶点坐标
    ///
    /// - Parameters:
    ///   - index: 第几个顶点（外接圆和内接圆分开计算）
    ///   - size: 外接圆直径（星星大小）
    ///   - isOutside: true -> 计算外接圆的顶点 , false -> 计算内接圆顶点
    /// - Returns: 返回顶点坐标
    private func getVerTex(_ index: Int, size: CGFloat, isOutside: Bool) -> CGPoint {
        let starSize: Double = Double(size)
        let xCenter: Double = starSize * 0.5
        let yCenter: Double = starSize * 0.5
        let R: Double = starSize * 0.5 // 外接圆半径
        let r: Double = R * 0.5  // 内接圆半径
        let rotaAngle: Double = 0 // 旋转角度

        // 外接圆第一个顶点角度：18 内接圆第一个顶点：54  之后每个点之间距离是72度
        let angle = (isOutside ? 18 : 54) - rotaAngle // 顶点角度
        let radius = (isOutside ? R : r)
        let radian = (angle + Double(index) * 72.0) / 180.0 * .pi // 角度转弧度
        let verTexX = cos(radian) * radius // 顶点横坐标
        let verTexY = -sin(radian) * radius // 顶点纵坐标
        return CGPoint(x: verTexX + xCenter, y: verTexY + yCenter)
    }

    private func makeStarImage(pt size: CGFloat, spacing: CGFloat, color: UIColor) -> UIImage? {
        guard let starOrigin = self.makeStar(size, color: color) else { return nil }

        var size = starOrigin.size
        size.width = size.width + self.spacing
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        starOrigin.draw(at: CGPoint(x: 0, y: 0))
        let starImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return starImage
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let emptyStar = self.emptyStar else { return }
        emptyStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.maxWidth, height: emptyStar.size.height))

        if self.current > 0 {
            guard let fillStar = self.fillStar else { return }
            fillStar.drawAsPattern(in: CGRect(x: 0, y: 0, width: self.currentWidth, height: fillStar.size.height))
        }
    }

    private func updateLocation(_ location: CGPoint) {
        switch self.type {
        case .rate:
            var width = location.x < 0 ? 0 : location.x
            width = width > self.maxWidth ? self.maxWidth : width
            self.currentWidth = width

            var count: CGFloat = 0
            while width > 0 {
                if width >= self.point {
                    count = count + 1
                    width = width - (self.point + self.spacing)
                }
                else {
                    count = count + (width / self.point)
                    width = width - (self.point + self.spacing)
                }
            }

            self.current = count
            delegate?.StarRatingValueChanged(view: self, value: count)
            break

        case .half:
            var width = location.x < 0 ? 0 : location.x
            width = width > self.maxWidth ? self.maxWidth : width

            var count: CGFloat = 0
            while width > 0 {
                if width >= self.point {
                    count = count + 1
                    width = width - (self.point + self.spacing)
                }
                else {
                    count = count + (width / self.point)
                    width = width - (self.point + self.spacing)
                }
            }

            self.current = floor(count)
            let remainder = count - self.current
            if remainder >= 0.5 {
                self.current += 1
            }
            else if remainder > 0 {
                self.current += 0.5
            }

            self.currentWidth = rateToWidth(self.current)
            delegate?.StarRatingValueChanged(view: self, value: self.current)
            break

        case .fill:
            var width = location.x < 0 ? 0 : location.x
            width = width > self.maxWidth ? self.maxWidth : width

            var count: CGFloat = 0
            while width > 0 {
                if width >= self.point {
                    count = count + 1
                    width = width - (self.point + self.spacing)
                }
                else {
                    count = count + (width / self.point)
                    width = width - (self.point + self.spacing)
                }
            }

            self.current = ceil(count)
            self.currentWidth = rateToWidth(self.current)
            delegate?.StarRatingValueChanged(view: self, value: self.current)
            break
        }
    }

    public override var intrinsicContentSize: CGSize {
        let count = CGFloat(self.max)
        var width = self.point * count
        width = width + CGFloat(count - 1) * self.spacing
        return CGSize(width: width, height: self.point)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        if let location = touches.first?.location(in: self) {
            updateLocation(location)
            setNeedsDisplay()
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        if let location = touches.first?.location(in: self) {
            updateLocation(location)
            setNeedsDisplay()
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        if let location = touches.first?.location(in: self) {
            updateLocation(location)
            setNeedsDisplay()
        }
    }
}
