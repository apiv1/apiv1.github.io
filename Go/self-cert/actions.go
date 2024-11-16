package main

import (
	"bytes"
	cryptorand "crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/pem"
	"io"
	"log"
	"math/big"
	"os"
	"time"
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

func LoadPrivateKey(b []byte) (*rsa.PrivateKey, error) {
	pemData, _ := pem.Decode(b)
	priv, err := x509.ParsePKCS1PrivateKey(pemData.Bytes)
	if err != nil {
		return nil, err
	}
	return priv, nil
}

func LoadPublicKey(b []byte) (*rsa.PublicKey, error) {
	pemData, _ := pem.Decode(b)
	publicKey, err := x509.ParsePKCS1PublicKey(pemData.Bytes)
	if err != nil {
		return nil, err
	}
	return publicKey, nil
}

func LoadCert(b []byte) (*x509.Certificate, error) {
	pemData, _ := pem.Decode(b)
	cert, err := x509.ParseCertificate(pemData.Bytes)
	if err != nil {
		return nil, err
	}
	return cert, nil
}

func GeneratePrivateKey() ([]byte, error) {
	priv, err := rsa.GenerateKey(cryptorand.Reader, 2048)
	if err != nil {
		return nil, err
	}

	// Generate key
	keyBuffer := bytes.Buffer{}
	if err := pem.Encode(&keyBuffer, &pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(priv)}); err != nil {
		return nil, err
	}

	return keyBuffer.Bytes(), nil
}

func GeneratePublicKey(pub *rsa.PublicKey) ([]byte, error) {
	// Generate cert
	buffer := bytes.Buffer{}
	if err := pem.Encode(&buffer, &pem.Block{Type: "RSA PUBLIC KEY", Bytes: x509.MarshalPKCS1PublicKey(pub)}); err != nil {
		return nil, err
	}

	return buffer.Bytes(), nil
}

func GenerateSelfSignedCertKey(subject, issuer string, priv *rsa.PrivateKey) ([]byte, error) {
	template := x509.Certificate{
		SerialNumber: big.NewInt(1),
		Subject: pkix.Name{
			CommonName: subject,
		},
		Issuer: pkix.Name{
			CommonName: issuer,
		},
		NotBefore: time.Now(),
		NotAfter:  time.Now().Add(time.Hour * 24 * 365 * 99),

		KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature | x509.KeyUsageCertSign,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
		IsCA:                  true,
	}

	derBytes, err := x509.CreateCertificate(cryptorand.Reader, &template, &template, &priv.PublicKey, priv)
	if err != nil {
		return nil, err
	}

	// Generate cert
	certBuffer := bytes.Buffer{}
	if err := pem.Encode(&certBuffer, &pem.Block{Type: "CERTIFICATE", Bytes: derBytes}); err != nil {
		return nil, err
	}

	return certBuffer.Bytes(), nil
}
