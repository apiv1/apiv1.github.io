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
	defer func() {
		if err != nil {
			fmt.Println(err)
			return
		}
	}()
	listenAddr, filePath := os.Args[1], os.Args[2]
	tcpAddr, err := net.ResolveTCPAddr("tcp4", listenAddr)
	if err != nil {
		return
	}
	listener, err := net.ListenTCP("tcp", tcpAddr)
	if err != nil {
		return
	}
	conn, err := listener.Accept()
	if err != nil {
		return
	}
	options := serial.OpenOptions{
		PortName:        filePath,
		BaudRate:        115200,
		DataBits:        8,
		StopBits:        1,
		MinimumReadSize: 4,
	}
	f, err := serial.Open(options)
	if err != nil {
		return
	}
	done := make(chan struct{})
	go func() {
		io.Copy(f, conn)
		close(done)
	}()
	go func() {
		io.Copy(conn, f)
		close(done)
	}()
	<-done
}
