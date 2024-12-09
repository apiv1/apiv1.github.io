```serial.yml```说明

配置结构体
```go
type Config struct {
	// Device path (/dev/ttyS0)
	Address string
	// Baud rate (default 19200)
	BaudRate int
	// Data bits: 5, 6, 7 or 8 (default 8)
	DataBits int
	// Stop bits: 1 or 2 (default 1)
	StopBits int
	// Parity: N - None, E - Even, O - Odd (default E)
	// (The use of no parity requires 2 stop bits.)
	Parity string
	// Read (Write) timeout.
	Timeout time.Duration
	// Configuration related to RS485
	RS485 RS485Config
}
```

例子

serial.yml
```yaml
address: COM7
baudRate: 115200
stopBits: 1
dataBits: 8
parity: N
```