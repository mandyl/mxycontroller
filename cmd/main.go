package main

import (
	"crdtest/mxycontroller/cmd/server"
	"log"
	"os"
)

func main() {
	command := server.NewServerCommand()
	if err := command.Execute(); err != nil {
		log.Println(err)
		os.Exit(1)
	}
}
