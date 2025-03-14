package main

import (
	"bytes"
	"context"
	"flag"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"go.bug.st/serial"
	"gopkg.in/yaml.v2"
)

// SerialConfig represents the configuration for a serial port connection
type SerialConfig struct {
	Address  string `yaml:"address"`  // Serial port address (e.g., COM1, /dev/ttyUSB0)
	BaudRate int    `yaml:"baudrate"` // Communication speed in bits per second
	StopBits int    `yaml:"stopbits"` // Number of stop bits (1 or 2)
	DataBits int    `yaml:"databits"` // Number of data bits
	Parity   string `yaml:"parity"`   // Parity mode (N: None, E: Even, O: Odd)
}

// ToSerialMode converts SerialConfig to serial.Mode
func (c *SerialConfig) ToSerialMode() (*serial.Mode, error) {
	// Convert stop bits
	var stopBits serial.StopBits
	switch c.StopBits {
	case 1:
		stopBits = serial.OneStopBit
	case 2:
		stopBits = serial.TwoStopBits
	default:
		return nil, fmt.Errorf("unsupported stop bits: %d", c.StopBits)
	}

	// Convert parity
	var parity serial.Parity
	switch c.Parity {
	case "N":
		parity = serial.NoParity
	case "E":
		parity = serial.EvenParity
	case "O":
		parity = serial.OddParity
	default:
		return nil, fmt.Errorf("unsupported parity: %s", c.Parity)
	}

	return &serial.Mode{
		BaudRate: c.BaudRate,
		DataBits: c.DataBits,
		Parity:   parity,
		StopBits: stopBits,
	}, nil
}

// handleSerialConnection handles data forwarding between serial port and network connection
func handleSerialConnection(ctx context.Context, conn net.Conn, serialConfig *SerialConfig) error {
	// Open serial port
	serialMode, err := serialConfig.ToSerialMode()
	if err != nil {
		return fmt.Errorf("failed to convert serial mode: %v", err)
	}

	serialHandler, err := serial.Open(serialConfig.Address, serialMode)
	if err != nil {
		return fmt.Errorf("failed to open serial port: %v", err)
	}
	defer serialHandler.Close()
	log.Printf("Serial port opened")

	// Data forwarding
	ctxConn, cancelCtxConn := context.WithCancel(ctx)
	defer cancelCtxConn()

	// Network -> Serial
	go func() {
		defer cancelCtxConn()
		if written, err := io.Copy(serialHandler, conn); err != nil {
			log.Printf("Error sending to serial port: %v", err.Error())
		} else {
			log.Printf("Sent %v bytes to serial port", written)
		}
	}()

	// Serial -> Network
	go func() {
		defer cancelCtxConn()
		if written, err := io.Copy(conn, serialHandler); err != nil {
			log.Printf("Error reading from serial port: %v", err.Error())
		} else {
			log.Printf("Read %v bytes from serial port", written)
		}
	}()

	<-ctxConn.Done()
	log.Println("Connection closed")
	return nil
}

// handleListener handles incoming connections in listen mode
func handleListener(ctx context.Context, listener net.Listener, serialConfig *SerialConfig) bool {
	conn, err := listener.Accept()
	if err != nil {
		log.Fatalf("Failed to accept connection: %v", err.Error())
		return false
	}
	defer conn.Close()
	log.Println("New connection established")

	if err := handleSerialConnection(ctx, conn, serialConfig); err != nil {
		log.Printf("Failed to handle connection: %v", err)
	}
	return true
}

// handleConnect handles outgoing connections in connect mode
func handleConnect(ctx context.Context, addr string, serialConfig *SerialConfig) error {
	// Parse address
	urlInfos := strings.Split(addr, "://")
	network, address := "tcp", addr
	if len(urlInfos) > 1 {
		network, address = urlInfos[0], urlInfos[1]
	}

	// Establish connection
	dialer := net.Dialer{}
	conn, err := dialer.DialContext(ctx, network, address)
	if err != nil {
		return fmt.Errorf("failed to connect: %v", err)
	}
	defer conn.Close()
	log.Println("Connection established")

	return handleSerialConnection(ctx, conn, serialConfig)
}

// serialYmlContent reads serial configuration from file or stdin
func serialYmlContent(serialYml string) (serialYmlContent []byte, err error) {
	if serialYml == "-" {
		fmt.Printf("[Config] Loading from stdin\n")
		buffer := &bytes.Buffer{}
		if _, err = io.Copy(buffer, os.Stdin); err == nil {
			serialYmlContent = buffer.Bytes()
		}
	} else {
		serialYmlContent, err = os.ReadFile(serialYml)
	}
	return
}

// listenAndServe creates a network listener for the given URL
func listenAndServe(ctx context.Context, url string) (listener net.Listener, err error) {
	urlInfos := strings.Split(url, "://")
	network, addr := "tcp", url
	if len(urlInfos) > 1 {
		network, addr = urlInfos[0], urlInfos[1]
	}
	listenConfig := &net.ListenConfig{}
	return listenConfig.Listen(ctx, network, addr)
}

func main() {
	// Define command line flags
	serialYml := "serial.yml"
	serialYmlFilePath := flag.String("f", "", fmt.Sprintf("Load serial config from file. Default '%v', '-' for stdin", serialYml))
	listenAddr := flag.String("l", "", "Listen address (e.g., 0.0.0.0:8080)")
	listenAddrShort := flag.String("listen", "", "Listen address (e.g., 0.0.0.0:8080)")
	connectAddr := flag.String("c", "", "Connect address (e.g., 192.168.1.100:8080)")
	connectAddrShort := flag.String("connect", "", "Connect address (e.g., 192.168.1.100:8080)")

	flag.Parse()

	// Check address parameters
	var addr string
	if *listenAddr != "" {
		addr = *listenAddr
	} else if *listenAddrShort != "" {
		addr = *listenAddrShort
	} else if *connectAddr != "" {
		addr = *connectAddr
	} else if *connectAddrShort != "" {
		addr = *connectAddrShort
	} else {
		log.Fatal("Must specify either --listen/-l or --connect/-c parameter")
	}

	// Handle config file path
	if serialYmlFilePath != nil && *serialYmlFilePath != "" {
		serialYml = *serialYmlFilePath
	}

	// Read config file
	serialYmlContent, err := serialYmlContent(serialYml)
	if err != nil {
		log.Fatalf("Failed to read serial config: %v", err.Error())
		return
	}

	serialConfig := &SerialConfig{}
	if err := yaml.Unmarshal(serialYmlContent, serialConfig); err != nil {
		log.Fatalf("Failed to parse serial config: %v", err.Error())
		return
	}
	log.Printf("Serial config: %#v", serialConfig)

	ctx := context.Background()

	// Choose mode based on parameters
	if *listenAddr != "" || *listenAddrShort != "" {
		// Listen mode
		listener, err := listenAndServe(ctx, addr)
		if err != nil {
			log.Fatalf("Failed to listen on address: %v", err.Error())
		}
		defer listener.Close()
		log.Printf("Listening on %v", listener.Addr())
		for {
			if !handleListener(ctx, listener, serialConfig) {
				break
			}
		}
	} else {
		// Connect mode
		log.Printf("Connecting to %v", addr)
		for {
			if err := handleConnect(ctx, addr, serialConfig); err != nil {
				log.Printf("Connection failed: %v", err.Error())
				// Wait before retry
				select {
				case <-ctx.Done():
					return
				case <-time.After(time.Second * 5):
					continue
				}
			}
		}
	}
}
