//
//  AnimationContext.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 2/1/19.
//

import Foundation
import CoreGraphics
import QuartzCore

/// A completion block for animations. `true` is passed in if the animation completed playing.
public typealias LottieCompletionBlock = (Bool) -> Void

public struct AnimationContext {

  public init(playFrom: CGFloat,
              playTo: CGFloat,
              closure: LottieCompletionBlock?) {
    self.playTo = playTo
    self.playFrom = playFrom
    self.closure = AnimationCompletionDelegate(completionBlock: closure)
  }

  public var playFrom: CGFloat
  public var playTo: CGFloat
  public var closure: AnimationCompletionDelegate

}

public class AnimationCompletionDelegate: NSObject, CAAnimationDelegate {
  
  public init(completionBlock: LottieCompletionBlock?) {
    self.completionBlock = completionBlock
    super.init()
  }
  
  public var animationLayer: AnimationContainer?
  public var animationKey: String?
  var ignoreDelegate: Bool = false
  let completionBlock: LottieCompletionBlock?
  
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard ignoreDelegate == false else { return }
    if let animationLayer = animationLayer, let key = animationKey {
      animationLayer.removeAnimation(forKey: key)
      if flag {
        animationLayer.currentFrame = (anim as! CABasicAnimation).toValue as! CGFloat
      }
    }
    if let completionBlock = completionBlock {
      completionBlock(flag)
    }
  }
  
}
