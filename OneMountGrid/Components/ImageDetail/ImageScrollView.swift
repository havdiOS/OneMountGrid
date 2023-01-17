//
//  ImageScrollView.swift
//  Fima
//
//  Created by Ha Vu on 9/27/20.
//  Copyright © 2020 Fima. All rights reserved.
//

import UIKit

protocol ImageScrollViewDelegate: UIScrollViewDelegate {
    func imageScrollViewDidChangeOrientation(imageScrollView: ImageScrollView)
}

final class ImageScrollView: UIScrollView {
    enum ScaleMode: Int {
        case aspectFill
        case aspectFit
        case widthFill
        case heightFill
    }

    enum Offset: Int {
        case begining
        case center
    }

    static let kZoomInFactorFromMinWhenDoubleTap: CGFloat = 2

    var imageContentMode: ScaleMode = .widthFill
    var initialOffset: Offset = .begining

    private(set) var zoomView: UIImageView?

    weak var imageScrollViewDelegate: ImageScrollViewDelegate?

    var imageSize = CGSize.zero
    private var pointToCenterAfterResize = CGPoint.zero
    private var scaleToRestoreAfterResize: CGFloat = 1.0
    var maxScaleFromMinScale: CGFloat = 3.0

    override var frame: CGRect {
        willSet {
            if frame.equalTo(newValue) == false,
               newValue.equalTo(CGRect.zero) == false,
               imageSize.equalTo(CGSize.zero) == false
            {
                prepareToResize()
            }
        }

        didSet {
            if frame.equalTo(oldValue) == false,
               frame.equalTo(CGRect.zero) == false,
               imageSize.equalTo(CGSize.zero) == false
            {
                recoverFromResizing()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func initialize() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        bouncesZoom = true
        decelerationRate = UIScrollView.DecelerationRate.fast
        delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ImageScrollView.changeOrientationNotification),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }

    func adjustFrameToCenter() {
        guard let unwrappedZoomView = zoomView else {
            return
        }

        var frameToCenter = unwrappedZoomView.frame

        if frameToCenter.size.width < bounds.width {
            frameToCenter.origin.x = (bounds.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < bounds.height {
            frameToCenter.origin.y = (bounds.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        unwrappedZoomView.frame = frameToCenter
    }

    private func prepareToResize() {
        let boundsCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        pointToCenterAfterResize = convert(boundsCenter, to: zoomView)

        scaleToRestoreAfterResize = zoomScale

        if scaleToRestoreAfterResize <= minimumZoomScale + CGFloat(Float.ulpOfOne) {
            scaleToRestoreAfterResize = 0
        }
    }

    private func recoverFromResizing() {
        setMaxMinZoomScalesForCurrentBounds()

        let maxZoomScale = max(minimumZoomScale, scaleToRestoreAfterResize)
        zoomScale = min(maximumZoomScale, maxZoomScale)

        let boundsCenter = convert(pointToCenterAfterResize, to: zoomView)

        var offset = CGPoint(x: boundsCenter.x - bounds.size.width / 2.0, y: boundsCenter.y - bounds.size.height / 2.0)

        let maxOffset = maximumContentOffset()
        let minOffset = minimumContentOffset()

        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)

        realMaxOffset = min(maxOffset.y, offset.y)
        offset.y = max(minOffset.y, realMaxOffset)

        contentOffset = offset
    }

    private func maximumContentOffset() -> CGPoint {
        return CGPoint(x: contentSize.width - bounds.width, y: contentSize.height - bounds.height)
    }

    private func minimumContentOffset() -> CGPoint {
        return CGPoint.zero
    }

    func display(image: UIImage) {
        if let zoomView = zoomView {
            zoomView.removeFromSuperview()
        }

        zoomView = UIImageView(image: image)
        zoomView!.isUserInteractionEnabled = true
        addSubview(zoomView!)

        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(ImageScrollView.doubleTapGestureRecognizer(_:)))
        tapGesture.numberOfTapsRequired = 2
        zoomView!.addGestureRecognizer(tapGesture)

        configureImageForSize(image.size)
    }

    private func configureImageForSize(_ size: CGSize) {
        imageSize = size
        contentSize = imageSize
        setMaxMinZoomScalesForCurrentBounds()
        zoomScale = minimumZoomScale

        switch initialOffset {
        case .begining:
            contentOffset = CGPoint.zero
        case .center:
            let xOffset = contentSize.width < bounds.width ? 0 : (contentSize.width - bounds.width) / 2
            let yOffset = contentSize.height < bounds.height ? 0 : (contentSize.height - bounds.height) / 2

            switch imageContentMode {
            case .aspectFit:
                contentOffset = CGPoint.zero
            case .aspectFill:
                contentOffset = CGPoint(x: xOffset, y: yOffset)
            case .heightFill:
                contentOffset = CGPoint(x: xOffset, y: 0)
            case .widthFill:
                contentOffset = CGPoint(x: 0, y: yOffset)
            }
        }
    }

    private func setMaxMinZoomScalesForCurrentBounds() {
        let xScale = bounds.width / imageSize.width
        let yScale = bounds.height / imageSize.height
        var minScale: CGFloat = 1

        switch imageContentMode {
        case .aspectFill:
            minScale = max(xScale, yScale)
        case .aspectFit:
            minScale = min(xScale, yScale)
        case .widthFill:
            minScale = xScale
        case .heightFill:
            minScale = yScale
        }

        let maxScale = maxScaleFromMinScale * minScale

        if minScale > maxScale {
            minScale = maxScale
        }

        maximumZoomScale = maxScale
        minimumZoomScale = minScale * 0.999
    }

    @objc
    func doubleTapGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if zoomScale >= maximumZoomScale / 2.0 {
            setZoomScale(minimumZoomScale, animated: true)
        } else {
            let center = gestureRecognizer.location(in: gestureRecognizer.view)
            let zoomRect = zoomRectForScale(ImageScrollView.kZoomInFactorFromMinWhenDoubleTap * minimumZoomScale,
                                            center: center)
            zoom(to: zoomRect, animated: true)
        }
    }

    private func zoomRectForScale(_ scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func refresh() {
        if let image = zoomView?.image {
            display(image: image)
        }
    }

    @objc
    private func changeOrientationNotification() {
        DispatchQueue.main.async {
            self.configureImageForSize(self.imageSize)
            self.imageScrollViewDelegate?.imageScrollViewDidChangeOrientation(imageScrollView: self)
        }
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        imageScrollViewDelegate?.scrollViewWillEndDragging?(scrollView,
                                                            withVelocity: velocity,
                                                            targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        imageScrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        imageScrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, with: view)
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        imageScrollViewDelegate?.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
    }

    func scrollViewShouldScrollToTop(_: UIScrollView) -> Bool {
        return false
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        imageScrollViewDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }

    func viewForZooming(in _: UIScrollView) -> UIView? {
        return zoomView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustFrameToCenter()
        imageScrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }
}
