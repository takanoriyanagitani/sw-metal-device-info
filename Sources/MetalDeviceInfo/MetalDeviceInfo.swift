import struct Foundation.Data
import class Foundation.JSONEncoder
import func FpUtil.Bind
import func FpUtil.Err
import typealias FpUtil.IO
import func FpUtil.Lift
import class Metal.MTLArchitecture
import func Metal.MTLCreateSystemDefaultDevice
import protocol Metal.MTLDevice
import enum Metal.MTLDeviceLocation
import enum Metal.MTLReadWriteTextureTier
import struct Metal.MTLSize

public enum ShowMetalDeviceError: Error {
  case deviceNotFound
  case unimplemented
}

func getMetalDevice() -> Result<MTLDevice, Error> {
  let odev: MTLDevice? = MTLCreateSystemDefaultDevice()
  guard let dev = odev else {
    return .failure(ShowMetalDeviceError.deviceNotFound)
  }

  return .success(dev)
}

public func GetMetalDevice() -> IO<MTLDevice> { return getMetalDevice }

public func MetalTextureTierToString(_ t: MTLReadWriteTextureTier) -> String {
  switch t {
  case .tier1: return "tier1"
  case .tier2: return "tier2"
  case .tierNone: return "tierNone"

  @unknown default: return "UNKONOWN TIER"
  }
}

public struct MetalSize: Codable {
  var width: Int
  var height: Int
  var depth: Int

  public static func fromRaw(raw: MTLSize) -> Self {
    Self(
      width: raw.width,
      height: raw.height,
      depth: raw.depth
    )
  }
}

public func MetalArchitectureString(_ ma: MTLArchitecture) -> String {
  ma.name
}

public func MetalDeviceLocationString(_ loc: MTLDeviceLocation) -> String {
  switch loc {
  case .builtIn: return "builtIn"
  case .slot: return "slot"
  case .external: return "external"
  case .unspecified: return "unspecified"

  @unknown default: return "UNKNOWN LOCATION"
  }
}

public struct MetalDeviceInfo: Codable {
  var maxThreadgroupMemoryLength: Int
  var maxThreadsPerThreadgroup: MetalSize

  var supportsRaytracing: Bool
  var supportsPrimitiveMotionBlur: Bool
  var supportsRaytracingFromRender: Bool
  var supports32BitMSAA: Bool
  var supportsPullModelInterpolation: Bool
  var supportsShaderBarycentricCoordinates: Bool
  var areProgrammableSamplePositionsSupported: Bool
  var areRasterOrderGroupsSupported: Bool

  var supports32BitFloatFiltering: Bool
  var supportsBCTextureCompression: Bool
  var isDepth24Stencil8PixelFormatSupported: Bool
  var supportsQueryTextureLOD: Bool

  var supportsFunctionPointers: Bool
  var supportsFunctionPointersFromRender: Bool

  var currentAllocatedSize: Int
  var recommendedMaxWorkingSetSize: UInt64
  var hasUnifiedMemory: Bool
  var maxTransferRate: UInt64

  var name: String
  var architecture: String
  var registryID: UInt64
  var location: String
  var locationNumber: Int
  var isLowPower: Bool
  var isRemovable: Bool
  var isHeadless: Bool
  var peerGroupID: UInt64
  var peerCount: UInt32
  var peerIndex: UInt32

  public static func fromRaw(raw: MTLDevice) -> Self {
    Self(
      maxThreadgroupMemoryLength: raw.maxThreadgroupMemoryLength,
      maxThreadsPerThreadgroup: MetalSize.fromRaw(
        raw: raw.maxThreadsPerThreadgroup
      ),

      supportsRaytracing: raw.supportsRaytracing,
      supportsPrimitiveMotionBlur: raw.supportsPrimitiveMotionBlur,
      supportsRaytracingFromRender: raw.supportsRaytracingFromRender,
      supports32BitMSAA: raw.supports32BitMSAA,
      supportsPullModelInterpolation: raw.supportsPullModelInterpolation,
      supportsShaderBarycentricCoordinates: raw.supportsShaderBarycentricCoordinates,
      areProgrammableSamplePositionsSupported: raw.areProgrammableSamplePositionsSupported,
      areRasterOrderGroupsSupported: raw.areRasterOrderGroupsSupported,
      supports32BitFloatFiltering: raw.supports32BitFloatFiltering,
      supportsBCTextureCompression: raw.supportsBCTextureCompression,
      isDepth24Stencil8PixelFormatSupported: raw.isDepth24Stencil8PixelFormatSupported,
      supportsQueryTextureLOD: raw.supportsQueryTextureLOD,
      supportsFunctionPointers: raw.supportsFunctionPointers,
      supportsFunctionPointersFromRender: raw.supportsFunctionPointersFromRender,
      currentAllocatedSize: raw.currentAllocatedSize,
      recommendedMaxWorkingSetSize: raw.recommendedMaxWorkingSetSize,
      hasUnifiedMemory: raw.hasUnifiedMemory,
      maxTransferRate: raw.maxTransferRate,
      name: raw.name,
      architecture: MetalArchitectureString(raw.architecture),
      registryID: raw.registryID,
      location: MetalDeviceLocationString(raw.location),
      locationNumber: raw.locationNumber,
      isLowPower: raw.isLowPower,
      isRemovable: raw.isRemovable,
      isHeadless: raw.isHeadless,
      peerGroupID: raw.peerGroupID,
      peerCount: raw.peerCount,
      peerIndex: raw.peerIndex
    )
  }

  public func toJson(encoder: JSONEncoder) -> Result<Data, Error> {
    Result(catching: {
      try encoder.encode(self)
    })
  }
}

public func MetalDeviceInfoJsonSourceNew(encoder: JSONEncoder) -> IO<Data> {
  return {
    let raw: IO<MTLDevice> = GetMetalDevice()
    let dev: IO<MetalDeviceInfo> = Bind(
      raw,
      Lift {
        let r: MTLDevice = $0
        return .success(MetalDeviceInfo.fromRaw(raw: r))
      }
    )
    return Bind(
      dev,
      Lift {
        let d: MetalDeviceInfo = $0
        return d.toJson(encoder: encoder)
      }
    )()
  }
}
