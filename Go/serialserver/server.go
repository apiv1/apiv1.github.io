package main

import (
	"fmt"
	"io"
	"net"
	"os"

	"github.com/jacobsa/go-serial/serial"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: <listen-addr> <file>")
		return
	}
	var err error
	listenAddr, filePath := os.Args[1], os.Args[2]
	tcpAddr, err := net.ResolveTCPAddr("tcp4", listenAddr)
	if err != nil {
		fmt.Println(err)
		return
	}
	listener, err := net.ListenTCP("tcp", tcpAddr)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer listener.Close()
	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Print("accept:")
			fmt.Println(err)
			return
		}
		fmt.Println("connect")
		defer conn.Close()
		options := serial.OpenOptions{
			PortName:        filePath,
			BaudRate:        115200,
			DataBits:        8,
			StopBits:        1,
			MinimumReadSize: 4,
		}
		f, err := serial.Open(options)
		if err != nil {
			fmt.Print("serial:")
			fmt.Println(err)
			return
		}
		done := make(chan struct{})
		go func() {
			io.Copy(f, conn)
			done <- struct{}{}
		}()
		go func() {
			io.Copy(conn, f)
			done <- struct{}{}
		}()
		<-done
		fmt.Println("done")
		f.Close()
	}
}
