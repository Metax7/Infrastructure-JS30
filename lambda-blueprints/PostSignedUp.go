package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

const tableName = "USERS_LIKED_ITEMS_DEV"

// https://docs.aws.amazon.com/lambda/latest/dg/golang-package.html#golang-package-windows
type Event struct {
	UserName string `json:"userName"`
	// Add other event fields as needed
}

func handler(ctx context.Context, event Event) (Event, error) {
	cfg, err := config.LoadDefaultConfig(ctx)
	if err != nil {
		log.Fatalf("failed to load configuration, %v", err)
	}

	client := dynamodb.NewFromConfig(cfg)
	docClient := dynamodb.NewFromConfig(cfg, func(options *dynamodb.Options) {
		options.Marshaler = types.MarshalerOptions{
			PutString: types.PutNumber,
		}.Marshal
		options.Unmarshaler = types.UnmarshalerOptions{
			UnmarshalString: types.UnmarshalNumber,
		}.Unmarshal
	})

	if event.UserName != "" {
		userId := event.UserName
		appName := "JS30"
		likedItems := []int{0}

		_, err := docClient.PutItem(ctx, &dynamodb.PutItemInput{
			TableName: &tableName,
			Item: map[string]types.AttributeValue{
				"UserId":     &types.AttributeValueMemberS{Value: userId},
				"AppName":    &types.AttributeValueMemberS{Value: appName},
				"LikedItems": &types.AttributeValueMemberNS{Value: likedItems},
			},
		})
		if err != nil {
			log.Printf("Error in DynamoDB operation: %v", err)
			return event, err
		}

		fmt.Printf("Item created successfully in %s.\n", tableName)
		return event, nil
	}

	log.Println("Error: userName is missing in the event.")
	return event, nil
}

func main() {
	lambda.Start(HandleRequest)
}
