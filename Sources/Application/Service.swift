import BluetoothLinux

class Service {
    func execute() async {
        guard let controller = await BluetoothLinux.HostController.default else { return }
        print(controller)
    }
}
