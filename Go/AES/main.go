package main

import (
	"flag"
	"io"
	"log"
	"os"
)

func ReadDataFromFile(inFile *string) ([]byte, error) {
	if inFile == nil || *inFile == "-" {
		return io.ReadAll(os.Stdin)
	}
	f, err := os.OpenFile(*inFile, os.O_RDONLY, 0644)
	if err != nil {
		log.Fatalf("Open file `%v` failed", *inFile)
	}
	defer f.Close()
	return io.ReadAll(f)
}
func WriteToFile(outFile *string, data []byte) {
	if outFile == nil || *outFile == "-" {
		os.Stdout.Write(data)
		os.Stdout.Sync()
	} else {
		f, err := os.OpenFile(*outFile, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0644)
		if err != nil {
			log.Fatalf("Open file `%v` failed", *outFile)
		}
		f.Write(data)
		f.Sync()
	}
}

func main() {
	inFile := flag.String("i", "-", "read from file, or - for stdin")
	outFile := flag.String("o", "-", "write to file, or - for stdout")

	key := flag.String("k", "", "encrypt/decrypt key")

	isEncrypt := flag.Bool("e", false, "encrypt")
	isDecrypt := flag.Bool("d", false, "decrypt")
	flag.Parse()

	if key == nil || len(*key) == 0 {
		if v, ok := os.LookupEnv("AES_KEY"); ok && len(v) > 0 {
			key = &v
		}
	}

	handleEncrypt := func() {
		if key == nil || len(*key) == 0 {
			log.Fatalf("key empty, quit")
		}
		keyData := []byte(*key)
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		if outData, err := AesEncrypt(data, keyData); err != nil {
			log.Fatalf("AesEncrypt failed: %v", err.Error())
		} else {
			WriteToFile(outFile, outData)
		}
	}

	handleDecrypt := func() {
		if key == nil || len(*key) == 0 {
			log.Fatalf("key empty, quit")
		}
		keyData := []byte(*key)
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		if outData, err := AesDecrypt(data, keyData); err != nil {
			log.Fatalf("AesDecrypt failed: %v", err.Error())
		} else {
			WriteToFile(outFile, outData)
		}
	}

	if isEncrypt != nil && *isEncrypt {
		handleEncrypt()
	} else if isDecrypt != nil && *isDecrypt {
		handleDecrypt()
	} else {
		flag.Usage()
	}
}
