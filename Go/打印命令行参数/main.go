package main

import (
	"fmt"
	"log"
	"os"
	"os/user"
	"path"
)

func main() {
	dirPath, ok := os.LookupEnv("LOG_PATH")
	if !ok {
		user, err := user.Current()
		if err != nil {
			log.Fatal(err)
		}
		dirPath = path.Join(user.HomeDir, "log.txt")
	}
	file, err := os.OpenFile(dirPath, os.O_CREATE|os.O_APPEND|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	_, err = file.WriteString(fmt.Sprintln(os.Args))
	if err != nil {
		log.Fatal(err)
	}
}
