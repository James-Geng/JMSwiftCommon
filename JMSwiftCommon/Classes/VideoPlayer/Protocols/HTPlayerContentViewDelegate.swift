//
//  HTPlayerContentViewDelegate.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import AVFoundation
import Foundation
import UIKit

protocol HTPlayerContentViewDelegate: AnyObject {
    
    func ht_didClickFailButton(in contentView: HTPlayerBaseContentView)

    func ht_didClickBackButton(in contentView: HTPlayerBaseContentView)

    func contentView(_ contentView: HTPlayerBaseContentView, didClickPlayButton isPlay: Bool)

    func contentView(_ contentView: HTPlayerBaseContentView, didClickFullButton isFull: Bool)

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeRate rate: Float)

    func contentView(_ contentView: HTPlayerBaseContentView, didChangeVideoGravity videoGravity: AVLayerVideoGravity)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchBegan slider: HTSlider)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderValueChanged slider: HTSlider)

    func contentView(_ contentView: HTPlayerBaseContentView, sliderTouchEnded slider: HTSlider)
    
    func ht_didClickPlayBackUpButton(in contentView: HTPlayerBaseContentView)
    
    func ht_didClickPlayAdvanceButton(in contentView: HTPlayerBaseContentView)
    
    func ht_didClickPlayLockButton(in contentView: HTPlayerBaseContentView, lock isLock:Bool)
    
    func ht_didClickPlayRemoveADButton(in contentView: HTPlayerBaseContentView)
    
    func ht_didClickPlayNextEpisodeButton(in contentView: HTPlayerBaseContentView)
    
    func ht_didClickPlaySelectEpisodeButton(in contentView: HTPlayerBaseContentView, button buttonView:UIButton, index indexForButton:Int)
    
    func ht_didClickSubTitleSettingButton(in contentView: HTPlayerBaseContentView,fullState isFullState:Bool, button buttonView:UIButton, index indexForButton:Int)
    
    func ht_didClickShareButton(in contentView: HTPlayerBaseContentView)
    
    func ht_contentView(_ contentView: HTPlayerBaseContentView, subTitleLoadComplete parsedPayload: NSDictionary?)
    
    func ht_didClickFastForward(_ contentView: HTPlayerBaseContentView, fastForwardTime timeSecond: Double)
}
