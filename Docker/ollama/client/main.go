package main

import (
	"context"
	"fmt"
	"log"

	"github.com/ollama/ollama/api"
)

func main() {
	client, err := api.ClientFromEnvironment()
	if err != nil {
		log.Fatalf("创建客户端失败: %v", err)
	}
	ctx := context.Background()
	var conversation []api.Message

	fmt.Println("欢迎使用Ollama聊天机器人! 输入'退出'结束对话。")

	for {
		var userInput string
		fmt.Print("你: ")
		fmt.Scanln(&userInput)

		if userInput == "退出" {
			fmt.Println("再见!")
			break
		}

		conversation = append(conversation, api.Message{Role: "user", Content: userInput})

		request := &api.ChatRequest{
			Model:    "llama3.1",
			Messages: conversation,
		}

		var fullResponse string
		err = client.Chat(ctx, request, func(response api.ChatResponse) error {
			fullResponse += response.Message.Content
			fmt.Print(response.Message.Content)
			return nil
		})

		if err != nil {
			log.Printf("生成回复时出错: %v", err)
			continue
		}

		fmt.Println()
		conversation = append(conversation, api.Message{Role: "assistant", Content: fullResponse})
	}
}
