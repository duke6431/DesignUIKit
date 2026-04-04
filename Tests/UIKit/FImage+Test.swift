import XCTest
import UIKit
@testable import DesignUIKit

@MainActor
final class FImageTest: XCTestCase {
    func testReload_whenLocalImageWithoutURL_invokesCompletionImmediately() {
        let sut = FImage()
        let expectedImage = makeImage(size: .init(width: 16, height: 8))
        var completionCalled = false

        sut.reload(image: expectedImage) { view, image in
            completionCalled = true
            XCTAssertTrue(view === sut)
            XCTAssertEqual(image.size, expectedImage.size)
        }

        XCTAssertTrue(completionCalled)
    }

    func testReload_whenNoImageAndNoURL_doesNotInvokeCompletion() {
        let sut = FImage()
        var completionCalled = false

        sut.reload { _, _ in
            completionCalled = true
        }

        XCTAssertFalse(completionCalled)
    }

    func testReload_whenUsingFileURL_invokesCompletionWithLoadedImage() throws {
        let sut = FImage()
        let inputImage = makeImage(size: .init(width: 21, height: 7))
        let fileURL = try writeImageToTemporaryFile(inputImage)
        defer { try? FileManager.default.removeItem(at: fileURL) }

        let didLoad = expectation(description: "Image load completion")
        sut.reload(url: fileURL) { view, image in
            XCTAssertTrue(view === sut)
            XCTAssertGreaterThan(image.size.width, 0)
            XCTAssertGreaterThan(image.size.height, 0)
            let expectedRatio = inputImage.size.width / inputImage.size.height
            let loadedRatio = image.size.width / image.size.height
            XCTAssertEqual(loadedRatio, expectedRatio, accuracy: 0.001)
            didLoad.fulfill()
        }

        wait(for: [didLoad], timeout: 3)
    }
}

private extension FImageTest {
    func makeImage(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.red.setFill()
            context.fill(.init(origin: .zero, size: size))
        }
    }

    func writeImageToTemporaryFile(_ image: UIImage) throws -> URL {
        guard let data = image.pngData() else {
            throw NSError(domain: "FImageTest", code: 1)
        }
        let fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("png")
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }
}
