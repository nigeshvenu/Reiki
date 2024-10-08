//
//  CurrentLineView.swift
//  KVKCalendar
//
//  Created by Sergei Kviatkovskii on 22.08.2020.
//

#if os(iOS)

import UIKit

final class CurrentLineView: UIView {
    
    struct Parameters {
        var style: Style
    }
    
    private var parameters: Parameters

    private let timeLabel: TimelineLabel = {
        let label = TimelineLabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        label.hashTime = Date().kvkMinute
        return label
    }()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    private let lineView = UIView()
    private let dotView = UIView()
    
    var valueHash: Int?
        
    var date: Date = Date() {
        didSet {
            if isHidden {
                isHidden = false
            }
            timeLabel.text = formatter.string(from: date)
            timeLabel.hashTime = date.kvkMinute
        }
    }
    
    init(parameters: Parameters, frame: CGRect) {
        self.parameters = parameters
        super.init(frame: frame)
        isUserInteractionEnabled = false
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CurrentLineView: CalendarSettingProtocol {
    
    var style: Style {
        get {
            parameters.style
        }
        set {
            parameters.style = newValue
        }
    }
    
    func setUI(reload: Bool = false) {
        subviews.forEach({ $0.removeFromSuperview() })
        
        lineView.backgroundColor = style.timeline.currentLineHourColor
        dotView.backgroundColor = style.timeline.currentLineHourColor
        
        formatter.dateFormat = style.timeSystem.format
        formatter.timeZone = style.timezone
        formatter.locale = style.locale
        
        timeLabel.textColor = style.timeline.currentLineHourColor
        timeLabel.font = style.timeline.currentLineHourFont

        let widthOffset: CGFloat
#if targetEnvironment(macCatalyst)
        widthOffset = 20
#else
        widthOffset = 5
#endif

        timeLabel.frame = CGRect(x: 0, y: 0,
                                 width: style.timeline.currentLineHourWidth - widthOffset,
                                 height: frame.height)
        dotView.frame = CGRect(x: style.timeline.allLeftOffset - (style.timeline.currentLineHourDotSize.width * 0.5) - frame.origin.x,
                               y: (frame.height * 0.5) - 2,
                               width: style.timeline.currentLineHourDotSize.width,
                               height: style.timeline.currentLineHourDotSize.height)
        lineView.frame = CGRect(x: dotView.frame.origin.x,
                                y: frame.height * 0.5,
                                width: frame.width - frame.origin.x,
                                height: style.timeline.currentLineHourHeight)
        [timeLabel, lineView, dotView].forEach({ addSubview($0) })
        dotView.setRoundCorners(radius: style.timeline.currentLineHourDotCornersRadius)
        isHidden = true
    }
    
    func updateStyle(_ style: Style, force: Bool) {
        self.style = style
        setUI(reload: force)
        date = Date()
    }
    
    func reloadFrame(_ frame: CGRect) {
        self.frame.size.width = frame.width
        self.frame.origin.x = frame.origin.x
    }
}

#endif
