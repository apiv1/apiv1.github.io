package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/ollama/ollama/api"
)

func main() {
	client, err := api.ClientFromEnvironment()
	if err != nil {
		log.Fatalf("创建客户端失败: %v", err)
	}

	var conversation []api.Message

	fmt.Print("欢迎使用Ollama聊天机器人! 连按Ctrl+C结束对话。")

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	var userQuitAt int64
FOR:
	for {
		var userInput string
		fmt.Println()
		fmt.Print("> ")
		fmt.Scanln(&userInput)
		select {
		case <-sigs:
			now := time.Now().UnixMilli()
			if now-userQuitAt < 2000 {
				break FOR
			}
			fmt.Println()
			fmt.Print("再按Ctrl+C结束对话")
			userQuitAt = now
			continue
		case <-time.After(500 * time.Millisecond):
		}

		if userInput == "" {
			continue
		}

		conversation = append(conversation, api.Message{Role: "user", Content: userInput})

		request := &api.ChatRequest{
			Model:    "llama3.1",
			Messages: conversation,
		}

		ctx, safeQuit := context.WithCancel(context.Background())
		defer safeQuit()

		userQuit := false
		go func() {
			select {
			case <-ctx.Done():
			case <-sigs:
				safeQuit()
				userQuit = true
			}
		}()

		var fullResponse string
		err = client.Chat(ctx, request, func(response api.ChatResponse) error {
			fullResponse += response.Message.Content
			fmt.Print(response.Message.Content)
			return nil
		})
		if userQuit {
			continue
		}

		if err != nil {
			log.Printf("生成回复时出错: %v", err)
			continue
		}

		conversation = append(conversation, api.Message{Role: "assistant", Content: fullResponse})
	}
}
