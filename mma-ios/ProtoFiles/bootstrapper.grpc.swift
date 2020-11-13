//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: bootstrapper.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import GRPC
import NIO
import NIOHTTP1
import SwiftProtobuf


/// Usage: instantiate Magma_Orc8r_BootstrapperClient, then call methods of this protocol to make API calls.
public protocol Magma_Orc8r_BootstrapperClientProtocol: GRPCClient {
  func getChallenge(
    _ request: Magma_Orc8r_AccessGatewayID,
    callOptions: CallOptions?
  ) -> UnaryCall<Magma_Orc8r_AccessGatewayID, Magma_Orc8r_Challenge>

  func requestSign(
    _ request: Magma_Orc8r_Response,
    callOptions: CallOptions?
  ) -> UnaryCall<Magma_Orc8r_Response, Magma_Orc8r_Certificate>

}

extension Magma_Orc8r_BootstrapperClientProtocol {

  /// get the challange for gateway specified in hw_id (AccessGatewayID)
  ///
  /// - Parameters:
  ///   - request: Request to send to GetChallenge.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getChallenge(
    _ request: Magma_Orc8r_AccessGatewayID,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Magma_Orc8r_AccessGatewayID, Magma_Orc8r_Challenge> {
    return self.makeUnaryCall(
      path: "/magma.orc8r.Bootstrapper/GetChallenge",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }

  /// send back response and csr for signing
  /// Returns signed certificate.
  ///
  /// - Parameters:
  ///   - request: Request to send to RequestSign.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func requestSign(
    _ request: Magma_Orc8r_Response,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Magma_Orc8r_Response, Magma_Orc8r_Certificate> {
    return self.makeUnaryCall(
      path: "/magma.orc8r.Bootstrapper/RequestSign",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions
    )
  }
}

public final class Magma_Orc8r_BootstrapperClient: Magma_Orc8r_BootstrapperClientProtocol {
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions

  /// Creates a client for the magma.orc8r.Bootstrapper service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  public init(channel: GRPCChannel, defaultCallOptions: CallOptions = CallOptions()) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
  }
}

