//
//  URLProtocolCustom.swift
//  datamobile
//
//  Created by yu qin on 2019/5/7.
//  Copyright © 2019 yu qin. All rights reserved.
//

import Foundation
import CoreFoundation
import MobileCoreServices
import Alamofire


class URLProtocolCustom: URLProtocol {

    
    static let kRequestKey = "RequestKey";

    
    override class func canInit(with request: URLRequest) -> Bool {
        
        
        var pathExtension = request.url?.pathExtension
        
        if (pathExtension?.count == 0) {
            pathExtension = request.url?.absoluteString.components(separatedBy: "&").first
            pathExtension = pathExtension?.components(separatedBy: ".").last
        }
        pathExtension = pathExtension?.lowercased()
        let source = ProtocolUtil.getSource()
        let isSource = source.contains(pathExtension ?? "")
        return URLProtocol.property(forKey: kRequestKey, in: request) == nil && isSource
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        
        let mutableReqeust = self.request as! NSMutableURLRequest
        //标记该请求已经处理
        URLProtocol.setProperty("1", forKey: URLProtocolCustom.kRequestKey, in: mutableReqeust)
        let pathExtension = ProtocolUtil.getPathExtension(with: self.request)
        let fileName = (self.request.url?.absoluteString.md5() ?? "") + "." + pathExtension
        let filePath = ProtocolUtil.createCacheFilePath(withFolderName: fileName)
        print("targetpath    \(filePath)")
        
        if !FileManager.default.fileExists(atPath: filePath) {
            self.downloadResourcesWithRequest(self.request)
            return;
        }

        let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
        self.sendResponseWithData(data, ProtocolUtil.getMimeType(withFilePath: filePath))
    }
    
    override func stopLoading() {
        
    }
    
    func sendResponseWithData(_ data: Data, _ mimeType: String) {
        
        let response = URLResponse.init(url: self.request.url!, mimeType: mimeType, expectedContentLength: -1, textEncodingName: nil)
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: URLCache.StoragePolicy.notAllowed)
        self.client?.urlProtocol(self, didLoad: data)
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    ////下载资源文件
    
    func downloadResourcesWithRequest(_ request: URLRequest) {
        
        //指定下载路径
        let destination:DownloadRequest.DownloadFileDestination = { _, response in
            let fileName = (self.request.url?.absoluteString.md5() ?? "") + "." + ProtocolUtil.getPathExtension(with: self.request)
            let filePath = ProtocolUtil.createCacheFilePath(withFolderName: fileName)
            let fileURL = URL.init(fileURLWithPath: filePath)
            return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
            }

        Alamofire.download(request, to: destination).downloadProgress { (Progress) in
            
            }.response { (response) in
                if let path = response.destinationURL?.path {
                    print("下载路径:\(path)")
                    let data = try! Data.init(contentsOf: URL.init(fileURLWithPath: path))
                    self.sendResponseWithData(data, ProtocolUtil.getMimeType(withFilePath: path))
                }
        }
    }
    
}
