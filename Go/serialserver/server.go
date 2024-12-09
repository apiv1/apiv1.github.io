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

	"github.com/goburrow/serial"
	"gopkg.in/yaml.v2"
)

func serialYmlContent(serialYml string) (serialYmlContent []byte, err error) {
	if serialYml == "-" {
		fmt.Printf("[Config] Loding from stdin\n")
		buffer := &bytes.Buffer{}
		if _, err = io.Copy(buffer, os.Stdin); err == nil {
			serialYmlContent = buffer.Bytes()
		}
	} else {
		serialYmlContent, err = os.ReadFile(serialYml)
	}
	return
}

func listenAndServe(ctx context.Context, url string) (listener net.Listener, err error) {
	urlInfos := strings.Split(url, "://")
	network, addr := "tcp", url
	if len(urlInfos) > 1 {
		network, addr = urlInfos[0], urlInfos[1]
	}
	listenConfig := &net.ListenConfig{}
	return listenConfig.Listen(ctx, network, addr)
}

func handleListener(ctx context.Context, listener net.Listener, serialOptions *serial.Config) bool {
	conn, err := listener.Accept()
	if err != nil {
		log.Fatalf("accept failed: %v", err.Error())
		return false
	}
	defer conn.Close()
	log.Println("connect")

	serialHandler, err := serial.Open(serialOptions)
	if err != nil {
		log.Printf("serial open failed: %v", err.Error())
		return true
	}
	defer serialHandler.Close()
	log.Printf("serial opened")

	ctxConn, cancelCtxConn := context.WithCancel(ctx)
	go func() {
		defer cancelCtxConn()
		if written, err := io.Copy(serialHandler, conn); err != nil {
			log.Printf("send to serial error = %v", err.Error())
		} else {
			log.Printf("send to serial %v bytes", written)
		}
	}()
	go func() {
		defer cancelCtxConn()
		if written, err := io.Copy(conn, serialHandler); err != nil {
			log.Printf("read from serial error = %v", err.Error())
		} else {
			log.Printf("read from serial %v bytes", written)
		}
	}()
	<-ctxConn.Done()

	log.Println("done")
	return true
}

func main() {
	if len(os.Args) <= 1 {
		log.Println("Usage: <listen-addr>")
		return
	}
	listenAddr := os.Args[1]

	ctx := context.Background()

	serialYml := "serial.yml"
	serialYmlFilePath := flag.String("f", "", fmt.Sprintf("load serial config. default '%v', '-' for stdin", serialYml))
	flag.Parse()

	if serialYmlFilePath != nil && *serialYmlFilePath != "" {
		serialYml = *serialYmlFilePath
	}

	serialYmlContent, err := serialYmlContent(serialYml)
	if err != nil {
		log.Fatalf("read serial config failed: %v", err.Error())
		return
	}

	serialOptions := &serial.Config{}
	if err := yaml.Unmarshal(serialYmlContent, serialOptions); err != nil {
		log.Fatalf("read serial yml config failed: %v", err.Error())
		return
	}
	log.Printf("serialOptions: %#v", serialOptions)

	listener, err := listenAndServe(ctx, listenAddr)
	if err != nil {
		log.Fatalf("listenAddr failed: %v", err.Error())
	}
	defer listener.Close()
	log.Printf("listen on %v", listener.Addr())
	for {
		if !handleListener(ctx, listener, serialOptions) {
			break
		}
	}
}
