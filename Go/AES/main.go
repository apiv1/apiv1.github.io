package main

import (
	"crypto/rand"
	"flag"
	"fmt"
	"io"
	"log"
	"math"
	"os"
)

const ATTACH_HEAD_LEN int64 = 2
const ATTACH_TAIL_LEN int64 = 16

func seekToAttach(f *os.File) (int64, error) {
	_, err := f.Seek(-ATTACH_TAIL_LEN, io.SeekEnd)
	if err != nil {
		return 0, fmt.Errorf("seek file: attach tail failed : %v", err)
	}
	tailBytes := make([]byte, ATTACH_TAIL_LEN)
	n, err := f.Read(tailBytes)
	if n != int(ATTACH_TAIL_LEN) || err != nil {
		return 0, fmt.Errorf("read attach tail failed : %v", err)
	}
	var attachLength int64 = 0
	for i, n := 0, int(ATTACH_TAIL_LEN); i < n; i++ {
		c := tailBytes[n-1-i]
		if c == 0 {
			break
		}
		attachLength += int64(c) * int64(math.Pow(0x100, float64(i)))
	}
	var checksum int16 = 0
	for i, n := 0, int(ATTACH_TAIL_LEN); i < n; i++ {
		c := tailBytes[n-1-i]
		checksum += int16(c)
	}
	_, err = f.Seek(-(ATTACH_HEAD_LEN + ATTACH_TAIL_LEN + attachLength), io.SeekEnd)
	if err != nil {
		return 0, fmt.Errorf("seek file: attach head failed : %v", err)
	}
	headBytes := make([]byte, ATTACH_HEAD_LEN)
	n, err = f.Read(headBytes)
	if n != int(ATTACH_HEAD_LEN) || err != nil {
		return 0, fmt.Errorf("read attach head failed : %v", err)
	}
	var headValue int16 = 0
	for _, b := range headBytes {
		headValue <<= 8
		headValue += int16(b)
	}
	if headValue != checksum {
		return 0, fmt.Errorf("checksum verification failed : (%v != %v)", headValue, checksum)
	}
	return attachLength, nil
}

func ReadDataFromFile(inFile *string, isAttach bool) ([]byte, error) {
	if inFile == nil || *inFile == "-" {
		return io.ReadAll(os.Stdin)
	}
	f, err := os.OpenFile(*inFile, os.O_RDONLY, 0644)
	if err != nil {
		log.Fatalf("Open file `%v` failed", *inFile)
	}
	defer f.Close()
	if isAttach {
		attachLength, err := seekToAttach(f)
		if err != nil {
			log.Fatalf("Seek to `%v` attach failed : %v", *inFile, err)
		}
		result := make([]byte, attachLength)
		if n, err := f.Read(result); err != nil || n != len(result) {
			log.Fatalf("Read attach `%v` failed", *inFile)
		}
		return result, nil
	}
	return io.ReadAll(f)
}
func WriteToFile(outFile *string, data []byte, isAttach bool) {
	if isAttach {
		tailBytes := make([]byte, ATTACH_TAIL_LEN)
		rand.Read(tailBytes)
		attachLength := len(data)
		for i, n := 0, int(ATTACH_TAIL_LEN); i < n; i++ {
			tailBytes[n-1-i] = byte(attachLength)
			if attachLength == 0 {
				break
			}
			attachLength >>= 8
		}
		var checksum int16 = 0
		for _, b := range tailBytes {
			checksum += int16(b)
		}
		headBytes := []byte{byte(checksum >> 8), byte(checksum)}
		f, err := os.OpenFile(*outFile, os.O_WRONLY, 0644)
		if err != nil {
			log.Fatalf("Open attach file `%v` failed", *outFile)
		}
		_, err = seekToAttach(f)
		if err == nil {
			currentOffset, err := f.Seek(ATTACH_HEAD_LEN, io.SeekCurrent)
			if err != nil {
				log.Fatalf("Seek file `%v` old attach head failed", *outFile)
			}
			err = f.Truncate(currentOffset)
			if err != nil {
				log.Fatalf("Truncate file `%v` old attach failed", *outFile)
			}
		} else {
			_, err = f.Seek(0, io.SeekEnd)
			if err != nil {
				log.Fatalf("Seek file `%v` end failed", *outFile)
			}
		}
		f.Write(headBytes)
		f.Write(data)
		f.Write(tailBytes)
	} else if outFile == nil || *outFile == "-" {
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
	isAttach := flag.Bool("a", false, "attach mode (read from file attach / attach into file)")
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
		data, err := ReadDataFromFile(inFile, false)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		if outData, err := AesEncrypt(data, keyData); err != nil {
			log.Fatalf("AesEncrypt failed: %v", err.Error())
		} else {
			WriteToFile(outFile, outData, *isAttach)
		}
	}

	handleDecrypt := func() {
		if key == nil || len(*key) == 0 {
			log.Fatalf("key empty, quit")
		}
		keyData := []byte(*key)
		data, err := ReadDataFromFile(inFile, *isAttach)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		if outData, err := AesDecrypt(data, keyData); err != nil {
			log.Fatalf("AesDecrypt failed: %v", err.Error())
		} else {
			WriteToFile(outFile, outData, false)
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
