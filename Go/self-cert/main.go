package main

import (
	"crypto/rsa"
	"flag"
	"fmt"
	"log"
)

func main() {
	isKey := flag.Bool("key", false, "generate private key")
	isPub := flag.Bool("pub", false, "generate public key by private key input")
	isPubDetail := flag.Bool("pub-detail", false, "show public key detail (N,E) by public key input")
	isCert := flag.Bool("cert", false, "generate cert by private key input")
	subject := flag.String("subject", "Self-Cert", "cert subject")
	issuer := flag.String("issuer", "Self-Cert", "cert issuer")
	isCertPub := flag.Bool("cert-pub", false, "load publickey from cert input")
	inFile := flag.String("i", "-", "read from file, or - for stdin")
	outFile := flag.String("o", "-", "write to file, or - for stdout")
	flag.Parse()

	handleKey := func() {
		if data, err := GeneratePrivateKey(); err != nil {
			log.Fatalf("GeneratePrivateKey failed: %v", err.Error())
		} else {
			WriteToFile(outFile, data)
		}
	}
	handlePub := func() {
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		priv, err := LoadPrivateKey(data)
		if err != nil {
			log.Fatalf("LoadPrivateKey failed: %v", err.Error())
		}
		if data, err := GeneratePublicKey(&priv.PublicKey); err != nil {
			log.Fatalf("GeneratePublicKey failed: %v", err.Error())
		} else {
			WriteToFile(outFile, data)
		}
	}
	handlePubDetail := func() {
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		publicKey, err := LoadPublicKey(data)
		if err != nil {
			log.Fatalf("LoadPublicKey failed: %v", err.Error())
		}
		pubDetail := fmt.Sprintf("%d %d", publicKey.N, publicKey.E)
		WriteToFile(outFile, []byte((pubDetail)))
	}
	handleCert := func() {
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		priv, err := LoadPrivateKey(data)
		if err != nil {
			log.Fatalf("LoadPrivateKey failed: %v", err.Error())
		}
		if data, err := GenerateSelfSignedCertKey(*subject, *issuer, priv); err != nil {
			log.Fatalf("GenerateSelfSignedCertKey failed: %v", err.Error())
		} else {
			WriteToFile(outFile, data)
		}
	}
	handleCertPub := func() {
		data, err := ReadDataFromFile(inFile)
		if err != nil {
			log.Fatalf("ReadDataFromFile failed: %v", err.Error())
		}
		cert, err := LoadCert(data)
		if err != nil {
			log.Fatalf("LoadCert failed: %v", err.Error())
		}
		publicKey, ok := cert.PublicKey.(*rsa.PublicKey)
		if !ok {
			log.Fatalf("Load PublicKey failed")
		}
		if data, err := GeneratePublicKey(publicKey); err != nil {
			log.Fatalf("GeneratePublicKey failed: %v", err.Error())
		} else {
			WriteToFile(outFile, data)
		}
	}

	if isKey != nil && *isKey {
		handleKey()
	} else if isPub != nil && *isPub {
		handlePub()
	} else if isPubDetail != nil && *isPubDetail {
		handlePubDetail()
	} else if isCert != nil && *isCert {
		handleCert()
	} else if isCertPub != nil && *isCertPub {
		handleCertPub()
	} else {
		flag.Usage()
	}
}
