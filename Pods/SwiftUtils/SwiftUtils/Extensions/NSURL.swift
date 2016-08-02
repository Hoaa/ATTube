//
//  NSURL.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import Foundation

public enum HTTPStatus: Int {
    // Informational 1xx
    case Continue = 100
    case SwitchingProtocols = 101
    case Processing = 102
    case Checkpoint = 103

    // Successful 2xx
    case Success = 200
    case Created = 201
    case Accepted = 202
    case NonAuthoritativeInformation = 203
    case NoContent = 204
    case ResetContent = 205
    case PartialContent = 206
    case MultiStatus = 207
    case AlreadyReported = 208
    case ImUsed = 226

    // Redirection 3xx
    case MultipleChoices = 300
    case MovedPermanently = 301
    case Found = 302
    case SeeOther = 303
    case NotModified = 304
    case UseProxy = 305
    case SwitchProxy = 306
    case TemporaryRedirect = 307
    case ResumeIncomplete = 308

    // Client Error 4xx
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURITooLong = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case ImATeapot = 418
    case AuthenticationTimeout = 419
    case EnhanceYourCalm = 420
    case MisdirectedRequest = 421
    case UnprocessableEntity = 422
    case Locked = 423
    case FailedDependency = 424
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests = 429
    case RequestHeaderFieldsTooLarge = 431
    case LoginTimeout = 440
    case NoResponse = 444
    case RetryWith = 449
    case BlockedByWindowsParentalControls = 450
    case WrongExchangeServer = 451
    case RequestHeaderTooLarge = 494
    case CertError = 495
    case NoCert = 496
    case HTTPtoHTTPS = 497
    case TokenExpiredOrInvalid = 498
    case CientClosedRequest = 499

    // Server Error 5xx
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case VariantAlsoNegotiates = 506
    case InsufficientStorage = 507
    case LoopDetected = 508
    case BandwidthLimitExceeded = 509
    case NotExtended = 510
    case NetworkAuthenticationRequired = 511
    case NetworkReadTimeout = 598
    case NetworkConnectTimeout = 599

    public init?(code: Int) {
        self.init(rawValue: code)
    }

    public var code: Int {
        return rawValue
    }
}

extension HTTPStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .Continue: // 100
            return "The server has received the request headers, and the client should proceed to send the request body."
        case .SwitchingProtocols: // 101
            return "The requester has asked the server to switch protocols."
        case .Processing:
            return "Server has received and is processing the request."
        case .Checkpoint: // 103
            return "Used in the resumable requests proposal to resume aborted PUT or POST requests."
        case .Success: // 200
            return "The request is OK."
        case .Created: // 201
            return "The request has been fulfilled, and a new resource is created ."
        case .Accepted: // 202
            return "The request has been accepted for processing, but the processing has not been completed."
        case .NonAuthoritativeInformation: // 203
            return "The request has been successfully processed, but is returning information that may be from another source."
        case .NoContent: // 204
            return "The request has been successfully processed, but is not returning any content."
        case .ResetContent: // 205
            return "The request has been successfully processed, but is not returning any content, and requires that the requester reset the document view."
        case .PartialContent: // 206
            return "The server is delivering only part of the resource due to a range header sent by the client."
        case .MultiStatus: // 207
            return "XML, can contain multiple separate responses."
        case .AlreadyReported: // 208
            return "Results previously returned."
        case .ImUsed: // 226
            return "Request fulfilled, reponse is instance-manipulations."
        case .MultipleChoices: // 300
            return "A link list. The user can select a link and go to that location. Maximum five addresses."
        case .MovedPermanently: // 301
            return "The requested page has moved to a new URL."
        case .Found: // 302
            return "The requested page has moved temporarily to a new URL."
        case .SeeOther: // 303
            return "The requested page can be found under a different URL."
        case .NotModified: // 304
            return "Indicates the requested page has not been modified since last requested."
        case .UseProxy: // 305
            return "The requested resource must be accessed through the proxy given by the Location field."
        case .SwitchProxy: // 306
            return "No longer used."
        case .TemporaryRedirect: // 307
            return "The requested page has moved temporarily to a new URL"
        case .ResumeIncomplete: // 308
            return "Used in the resumable requests proposal to resume aborted PUT or POST requests."
        case .BadRequest: // 400
            return "The request cannot be fulfilled due to bad syntax."
        case .Unauthorized: // 401
            return "The request was a legal request, but the server is refusing to respond to it. For use when authentication is possible but has failed or not yet been provided."
        case .PaymentRequired: // 402
            return "Reserved for future use."
        case .Forbidden: // 403
            return "The request was a legal request, but the server is refusing to respond to it."
        case .NotFound: // 404
            return "The requested page could not be found but may be available again in the future."
        case .MethodNotAllowed: // 405
            return "A request was made of a page using a request method not supported by that page."
        case .NotAcceptable: // 406
            return "The server can only generate a response that is not accepted by the client."
        case .ProxyAuthenticationRequired: // 407
            return "The client must first authenticate itself with the proxy."
        case .RequestTimeout: // 408
            return "The server timed out waiting for the request."
        case .Conflict: // 409
            return "The request could not be completed because of a conflict in the request."
        case .Gone: // 410
            return "The requested page is no longer available."
        case .LengthRequired: // 411
            return "The \"Content-Length\" is not defined. The server will not accept the request without it."
        case .PreconditionFailed: // 412
            return "The precondition given in the request evaluated to false by the server."
        case .RequestEntityTooLarge: // 413
            return "The server will not accept the request, because the request entity is too large."
        case .RequestURITooLong: // 414
            return "The server will not accept the request, because the URL is too long. Occurs when you convert a POST request to a GET request with a long query information."
        case .UnsupportedMediaType: // 415
            return "The server will not accept the request, because the media type is not supported."
        case .RequestedRangeNotSatisfiable: // 416
            return "The client has asked for a portion of the file, but the server cannot supply that portion."
        case .ExpectationFailed: // 417
            return "The server cannot meet the requirements of the Expect request-header field."
        case .ImATeapot: // 418
            return "I'm a teapot"
        case .AuthenticationTimeout: // 419
            return "Previously valid authentication has expired."
        case .EnhanceYourCalm: // 420
            return "Twitter rate limiting."
        case .MisdirectedRequest: // 421
            return "The request was directed at a server that is not able to produce a response."
        case .UnprocessableEntity: // 422
            return "Request unable to be followed due to semantic errors."
        case .Locked: // 423
            return "The resource that is being accessed is locked."
        case .FailedDependency: // 424
            return "The request failed due to failure of a previous request."
        case .UpgradeRequired: // 426
            return "The client should switch to a different protocol."
        case .PreconditionRequired: // 428
            return "The origin server requires the request to be conditional."
        case .TooManyRequests: // 429
            return "The user has sent too many requests in a given amount of time."
        case .RequestHeaderFieldsTooLarge: // 431
            return "Server is unwilling to process the request."
        case .LoginTimeout: // 440
            return "Your session has expired."
        case .NoResponse: // 444
            return "Server returns no information and closes the connection."
        case .RetryWith: // 449
            return "Request should be retried after performing action."
        case .BlockedByWindowsParentalControls: // 450
            return "Windows Parental Controls blocking access to webpage."
        case .WrongExchangeServer: // 451
            return "Resource access is denied for legal reasons."
        case .RequestHeaderTooLarge: // 494
            return "Server is unwilling to process the request."
        case .CertError: // 495
            return "SSL client certificate error occurred to distinguish it from 4XX in a log and an error page redirection."
        case .NoCert: // 496
            return "Client didn't provide certificate to distinguish it from 4XX in a log and an error page redirection."
        case .HTTPtoHTTPS: // 497
            return "The plain HTTP requests are sent to HTTPS port to distinguish it from 4XX in a log and an error page redirection."
        case .TokenExpiredOrInvalid: // 498
            return "An expired or otherwise invalid token."
        case .CientClosedRequest: // 499
            return "Connection closed by client while HTTP server is processing."
        case .InternalServerError: // 500
            return "A generic error message, given when no more specific message is suitable."
        case .NotImplemented: // 501
            return "The server either does not recognize the request method, or it lacks the ability to fulfill the request."
        case .BadGateway: // 502
            return "The server was acting as a gateway or proxy and received an invalid response from the upstream server."
        case .ServiceUnavailable: // 503
            return "The server is currently unavailable (overloaded or down)."
        case .GatewayTimeout: // 504
            return "The server was acting as a gateway or proxy and did not receive a timely response from the upstream server."
        case .HTTPVersionNotSupported: // 505
            return "The server does not support the HTTP protocol version used in the request."
        case .VariantAlsoNegotiates: // 506
            return "Transparent content negotiation for the request results in a circular reference."
        case .InsufficientStorage: // 507
            return "The server is unable to store the representation needed to complete the request."
        case .LoopDetected: // 508
            return "The server detected an infinite loop while processing the request."
        case .BandwidthLimitExceeded: // 509
            return "Server reached the bandwidth limit that the system administrator imposed."
        case .NotExtended: // 510
            return "Further extensions to the request are required for the server to fulfil it."
        case .NetworkAuthenticationRequired: // 511
            return "The client needs to authenticate to gain network access."
        case .NetworkReadTimeout: // 598
            return "Network read timeout behind the proxy."
        case .NetworkConnectTimeout: // 599
            return "Network connect timeout behind the proxy."
        }
    }
}

extension NSError {
    public convenience init(status: HTTPStatus, msg: String! = nil) {
        let info = NSBundle.mainBundle().infoDictionary!
        let domain = info[kCFBundleIdentifierKey as String] as? String ?? ""
        let userInfo: [String: String] = [NSLocalizedDescriptionKey: msg ?? status.description]
        self.init(domain: domain, code: status.code, userInfo: userInfo)
    }
}

extension NSURL {
    public var imageRequest: NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: self)
        request.addValue("image/*", forHTTPHeaderField: "Accept")
        return request
    }
}
