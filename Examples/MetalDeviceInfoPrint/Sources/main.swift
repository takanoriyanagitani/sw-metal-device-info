import struct Foundation.Data
import class Foundation.JSONEncoder
import func FpUtil.Bind
import typealias FpUtil.IO
import func MetalDeviceInfo.MetalDeviceInfoJsonSourceNew

func PrintData(_ data: Data) -> IO<Void> {
  return {
    let s: String = String(data: data, encoding: .utf8)!
    print("\( s )")
    return .success(())
  }
}

@main
struct MetalDeviceInfoPrint {
  static func main() {
    let jenc: JSONEncoder = JSONEncoder()
    let midat: IO<Data> = MetalDeviceInfoJsonSourceNew(encoder: jenc)
    let minf2dat2stdout: IO<Void> = Bind(
      midat,
      PrintData
    )

    let res: Result<_, _> = minf2dat2stdout()
    do {
      try res.get()
    } catch {
      print("\( error )")
    }
  }
}
