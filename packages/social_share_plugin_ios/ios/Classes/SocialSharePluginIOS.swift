import FBSDKCoreKit
import FBSDKShareKit
import Flutter
import Photos
import UIKit
import MobileCoreServices
import Photos

public class SocialSharePluginIOS: NSObject, FlutterPlugin, SharingDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String: Any]) {
    _channel.invokeMethod("onSuccess", arguments: nil)
    guard let result = _result else {
      return
    }
    result(true)
  }

  public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
    _channel.invokeMethod("onError", arguments: nil)
    guard let result = _result else {
      return
    }
    result(false)
  }

  public func sharerDidCancel(_ sharer: Sharing) {
    _channel.invokeMethod("onCancel", arguments: nil)
    guard let result = _result else {
      return
    }
    result(false)
  }

  var _result: FlutterResult?
  var _channel: FlutterMethodChannel
  var _dic: UIDocumentInteractionController?

  init(fromChannel channel: FlutterMethodChannel) {
    _channel = channel
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "social_share_plugin_ios", binaryMessenger: registrar.messenger())
    let instance = SocialSharePluginIOS(fromChannel: channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]
  ) -> Bool {
    let launchOptionsForFacebook = launchOptions as? [UIApplication.LaunchOptionsKey: Any]
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions:
        launchOptionsForFacebook
    )
    return true
  }

  public func application(
    _ application: UIApplication, open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return ApplicationDelegate.shared.application(
      application, open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation])
  }

  public func application(
    _ application: UIApplication, open url: URL, sourceApplication: String, annotation: Any
  ) -> Bool {
    return ApplicationDelegate.shared.application(
      application, open: url, sourceApplication: sourceApplication, annotation: annotation)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformName": result("iOS")
    case "shareToFeedInstagram":
      guard let args = call.arguments else {
        result(false)
        break
      }
      if let myArgs = args as? [String: Any],
        let path = myArgs["path"] as? String
      {
        let instagramURL = URL(string: "instagram://app")
        if let instagramURL = instagramURL {
          if UIApplication.shared.canOpenURL(instagramURL) {
            instagramShare(path)
            //                        result(nil)
          } else {
            let instagramLink = "itms-apps://itunes.apple.com/us/app/apple-store/id389801252"
            if #available(iOS 10.0, *) {
              if let url = URL(string: instagramLink) {
                UIApplication.shared.open(url, options: [:]) { _ in
                }
              }
            } else {
              if let url = URL(string: instagramLink) {
                UIApplication.shared.openURL(url)
              }
            }
            result(false)
          }
        }
      } else {
        result(false)
      }
    case "shareToFeedFacebook":
      guard let args = call.arguments else {
        result(false)
        break
      }
      if let myArgs = args as? [String: Any],
        let path = myArgs["path"] as? String
      {
        let fbURL = URL(string: "fbapi://")
        if let fbURL = fbURL {
          if UIApplication.shared.canOpenURL(fbURL) {
            facebookShare(path)
            //                        result(nil)
          } else {
            let fbLink = "itms-apps://itunes.apple.com/us/app/apple-store/id284882215"
            if #available(iOS 10.0, *) {
              if let url = URL(string: fbLink) {
                UIApplication.shared.open(url, options: [:]) { _ in
                }
              }
            } else {
              if let url = URL(string: fbLink) {
                UIApplication.shared.openURL(url)
              }
            }
            result(false)
          }
        }
      } else {
        result(false)
      }
    case "shareToFeedFacebookVideo":
      guard let args = call.arguments else {
        result(false)
        break
      }
      if let myArgs = args as? [String: Any],
        let path = myArgs["path"] as? String
      {
        let fbURL = URL(string: "fbapi://")
        if let fbURL = fbURL {
          if UIApplication.shared.canOpenURL(fbURL) {
            facebookShareVideo(path)
            // facebookShareVideoWithPicker("")
            //                        result(nil)
          } else {
            let fbLink = "itms-apps://itunes.apple.com/us/app/apple-store/id284882215"
            if #available(iOS 10.0, *) {
              if let url = URL(string: fbLink) {
                UIApplication.shared.open(url, options: [:]) { _ in
                }
              }
            } else {
              if let url = URL(string: fbLink) {
                UIApplication.shared.openURL(url)
              }
            }
            result(false)
          }
        }
      } else {
        result(false)
      }
    case "shareToFeedFacebookLink":
      guard let args = call.arguments else {
        result(false)
        break
      }
      if let myArgs = args as? [String: Any],
        let quote = myArgs["quote"] as? String,
        let url = myArgs["url"] as? String
      {
        let fbURL = URL(string: "fbapi://")
        if let fbURL = fbURL {
          if UIApplication.shared.canOpenURL(fbURL) {
            facebookShareLink(quote, url: url)
            //                        result(nil)
          } else {
            let fbLink = "itms-apps://itunes.apple.com/us/app/apple-store/id284882215"
            if #available(iOS 10.0, *) {
              if let url = URL(string: fbLink) {
                UIApplication.shared.open(url, options: [:]) { _ in
                }
              }
            } else {
              if let url = URL(string: fbLink) {
                UIApplication.shared.openURL(url)
              }
            }
            result(false)
          }
        }
      } else {
        result(false)
      }
    case "shareToTwitterLink":
      guard let args = call.arguments else {
        result(false)
        break
      }
      if let myArgs = args as? [String: Any],
        let text = myArgs["text"] as? String,
        let url = myArgs["url"] as? String
      {
        if let twitterURL = URL(string: "twitter://") {
          if UIApplication.shared.canOpenURL(twitterURL) {
            twitterShare(text, url: url)
          } else {
            let twitterLink = "itms-apps://itunes.apple.com/us/app/apple-store/id333903271"
            if #available(iOS 10.0, *) {
              if let url = URL(string: twitterLink) {
                UIApplication.shared.open(url, options: [:]) { _ in
                }
              }
            } else {
              if let url = URL(string: twitterLink) {
                UIApplication.shared.openURL(url)
              }
            }
            result(false)
          }
        }
      } else {
        result(false)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func instagramShare(_ imagePath: String?) {
    guard let path = imagePath else {
      self._channel.invokeMethod("onCancel", arguments: nil)
      return
    }

    if #available(iOS 13.0, *) {
      if let image = UIImage(contentsOfFile: path) {
        var placeholder: PHObjectPlaceholder?
        do {
          try PHPhotoLibrary.shared().performChangesAndWait {
            let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
            placeholder = request.placeholderForCreatedAsset
          }

          if let placeholder = placeholder {
            let instagramURL = URL(
              string: "instagram://library?LocalIdentifier=\(placeholder.localIdentifier)")
            if let url = instagramURL {
              UIApplication.shared.open(url, options: [:]) { opened in
                if opened {
                  self._channel.invokeMethod("onSuccess", arguments: nil)
                  guard let result = self._result else {
                    return
                  }
                  result(true)
                } else {
                  self._channel.invokeMethod("onError", arguments: nil)
                  guard let result = self._result else {
                    return
                  }
                  result(false)
                }
              }
            }
          } else {
            print("Error moving image to the library")
            self._channel.invokeMethod("onError", arguments: nil)
            guard let result = self._result else {
              return
            }
            result(false)
          }
        } catch {
          print("Error moving image to the library: \(error)")
          self._channel.invokeMethod("onError", arguments: nil)
          guard let result = self._result else {
            return
          }
          result(false)
        }

      }
    } else {
      do {
        try FileManager.default.moveItem(atPath: imagePath ?? "", toPath: "\(imagePath ?? "").ig")
      } catch {}
      let path = URL(string: "file://\(imagePath ?? "").ig")
      if let path = path {
        _dic = UIDocumentInteractionController(url: path)
        _dic?.uti = "com.instagram.photo"
        if let view = UIApplication.shared.delegate?.window??.rootViewController?.view {
          if !(_dic?.presentOpenInMenu(from: CGRect.zero, in: view, animated: true) ?? false) {
            print("Error sharing to instagram")
              guard let result = self._result else {
                return
              }
              result(false)
          }
        }
      }
    }
  }

  func facebookShare(_ imagePath: String?) {
    print("test masuk")
    // NSURL* path = [[NSURL alloc] initWithString:call.arguments[@"path"]];
    if let image = UIImage(contentsOfFile: imagePath ?? "") {
      let photo = SharePhoto(image: image, isUserGenerated: true)
      let content = SharePhotoContent()
      content.photos = [photo]
      let controller = UIApplication.shared.delegate?.window??.rootViewController
      ShareDialog.show(viewController: controller, content: content, delegate: self)
    }
  }

  func facebookShareVideoWithPicker(_ videoPath: String) {
    let videoPicker = UIImagePickerController()
    videoPicker.delegate = self
    videoPicker.modalPresentationStyle = .currentContext
    videoPicker.mediaTypes = [kUTTypeMovie as String, kUTTypeAVIMovie as String, kUTTypeVideo as String, kUTTypeMPEG4 as String]
    videoPicker.videoQuality = .typeHigh
    
    var controller = UIApplication.shared.delegate?.window??.rootViewController
    while let presentedViewController = controller?.presentedViewController {
        controller = presentedViewController
    }
    controller?.showDetailViewController(videoPicker, sender: nil)
  }

  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      picker.dismiss(animated: true, completion: nil)
      if let videoAsset = info[.phAsset] as? PHAsset {
        print("videoAsset: \(videoAsset)")
        let video = ShareVideo(videoAsset: videoAsset)
        let content = ShareVideoContent()
        content.video = video
        
        let controller = UIApplication.shared.delegate?.window??.rootViewController
        ShareDialog.show(viewController: controller, content: content, delegate: self)
      }

      // if let videoURL = info[.referenceURL] as? URL {
      //   print("Video URL: \(videoURL)")
      //   checkAssetExistsInLibrary(assetURL: videoURL) { asset in
      //       if let asset = asset {
      //           // The asset exists in the user's photo library
      //           print("Asset exists: \(asset)")
      //       } else {
      //           // The asset doesn't exist in the user's photo library
      //           print("Asset doesn't exist")
      //       }
      //   }
      //   let video = ShareVideo(videoURL: videoURL)
      //   let content = ShareVideoContent()
      //   content.video = video
        
      //   let controller = UIApplication.shared.delegate?.window??.rootViewController
      //   ShareDialog.show(viewController: controller, content: content, delegate: self)
      // }
  }

  func facebookShareVideo(_ videoPath: String?) {
    print("test masuk")
    
    if let videoPath = videoPath {
      print("videoPath : \(videoPath)")

      let videoUrl = URL(fileURLWithPath: videoPath)
      print("videoUrl:\(videoUrl)")
      guard FileManager.default.fileExists(atPath: videoUrl.path) else {
        print("Video file not found")
        return
      }

      saveVideoToPhotoLibrary(at: videoUrl) { (asset) in
        DispatchQueue.main.async {
          if let savedAsset = asset {
              print("Video saved to photo library with local identifier: \(savedAsset)")
              print("Video saved to photo library with local identifier: \(savedAsset.localIdentifier)")
              let video = ShareVideo(videoAsset: savedAsset)
              let content = ShareVideoContent()
              content.video = video

              let controller = UIApplication.shared.delegate?.window??.rootViewController
              ShareDialog.show(viewController: controller, content: content, delegate: self)

              ///delete the asset video that already in saved

//              PHPhotoLibrary.shared().performChanges({
//                  PHAssetChangeRequest.deleteAssets([savedAsset] as NSArray)
//              }) { success, error in
//                  if success {
//                      print("Asset deleted successfully")
//                  } else {
//                      print("Error deleting asset: \(error?.localizedDescription ?? "Unknown error")")
//                  }
//              }
          } else {
              print("Failed to save video to photo library")
          }
        }
      }
    }
  }

  func facebookShareLink(
    _ quote: String,
    url: String
  ) {
    let content = ShareLinkContent()
    content.contentURL = URL(string: url)
    content.quote = quote
    let controller = UIApplication.shared.delegate?.window??.rootViewController
    ShareDialog.show(viewController: controller, content: content, delegate: self)
  }

  func twitterShare(
    _ text: String,
    url: String
  ) {
    let shareString = "https://twitter.com/intent/tweet?text=\(text)&url=\(url)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    if let shareUrl = URL(string: shareString) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(shareUrl, options: [:]) { success in
          if success {
            self._channel.invokeMethod("onSuccess", arguments: nil)
            guard let result = self._result else {
              return
            }
            result(true)
          } else {
            self._channel.invokeMethod("onCancel", arguments: nil)
            guard let result = self._result else {
              return
            }
            result(false)
          }
        }
      } else {
        UIApplication.shared.openURL(shareUrl)
        _channel.invokeMethod("onSuccess", arguments: nil)
        guard let result = _result else {
          return
        }
        result(true)
      }
    }
  }

  func getDataFromVideoFile(at filePath: String) -> Data? {
      let fileURL = URL(fileURLWithPath: filePath)
      do {
          let data = try Data(contentsOf: fileURL)
          return data
      } catch {
          print("Error reading data from file: \(error)")
          return nil
      }
  }

  func saveVideoToPhotoLibrary(at fileURL: URL, completion: @escaping (PHAsset?) -> Void) {
    PHPhotoLibrary.shared().performChanges({
        // Create a PHAssetCreationRequest for the video
        let request = PHAssetCreationRequest.forAsset()
        // Add the temporary file to the request
        request.addResource(with: .video, fileURL: fileURL, options: nil)
    }) { success, error in
        if success {
            print("Video saved to photo library")
            // Retrieve the PHAsset for the saved video
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
            if let asset = fetchResult.firstObject {
              // Return the PHAsset for the saved video
              completion(asset)
              return
            } else {
              // If no asset is found, return nil
              completion(nil)
              return
            }
            // Optionally, you can delete the temporary file after saving
            try? FileManager.default.removeItem(at: fileURL)
        } else {
            print("Error saving video to photo library: \(error?.localizedDescription ?? "Unknown error")")
            completion(nil)
            return
        }
    }
  }

  func checkAssetExistsInLibrary(assetURL: URL, completion: @escaping (PHAsset?) -> Void) {
    let fetchOptions = PHFetchOptions()
    fetchOptions.includeAssetSourceTypes = .typeUserLibrary
    
    let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: fetchOptions)
    
    if let asset = fetchResult.firstObject {
        completion(asset)
    } else {
        completion(nil)
    }
  }

  //  func checkImageExistsInLibrary(imagePath: String, completion: @escaping (PHAsset?) -> Void) {
  //    let fetchOptions = PHFetchOptions()
  //    fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
  
  //    let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
  
  //    for index in 0..<fetchResult.count {
  //      let asset = fetchResult.object(at: index)
  
  //      //      print("\(asset)")
  
  //      if #available(iOS 13, *) {
  //        PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) {
  //          imageData, dataUTI, _, info in
  //          if let imageData = imageData, let imageURL = URL(string: imagePath) {
  //            print("\(imageData) \(imageURL) \(String(describing:dataUTI))")
  //            if let imageDataURL = try? Data(contentsOf: imageURL) {
  
  //              if imageData == imageDataURL {
  //                completion(asset)
  //                return
  //              }
  //            }
  //          }
  
  //          if index == fetchResult.count - 1 {
  //            completion(nil)
  //          }
  //        }
  //      } else {
  //        // Fallback on earlier versions
  //      }
  //    }
  //  }
}
