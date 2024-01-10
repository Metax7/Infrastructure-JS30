package main

import (
	"context"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

//Note that in Golang, we define a struct (Event) to represent the structure of the Lambda event.
// The Handler function takes this struct as an argument and returns the same struct along with an error.
// The main function calls lambda.Start(Handler) to start the Lambda function.
// Event represents the Lambda event structure
type Event struct {
	Version        string `json:"version"`
	Region         string `json:"region"`
	CallerContext  string `json:"callerContext"`
	EventType      string `json:"eventType"`
	DatasetRecords string `json:"datasetRecords"`
	TriggerSource  string `json:"triggerSource"`
	UserPoolID     string `json:"userPoolId"`
	ClientID       string `json:"clientId"`
	UserName       string `json:"userName"`
	UserAttributes string `json:"userAttributes"`
	Request        string `json:"request"`
	Response       string `json:"response"`
}

// Handler is the Lambda function handler
func Handler(ctx context.Context, event Event) (Event, error) {
	// Send post authentication data to CloudWatch logs
	log.Println("Authentication successful")
	log.Printf("Event = %+v\n", event)
	log.Printf("Version = %s\n", event.Version)
	log.Printf("Region = %s\n", event.Region)
	log.Printf("Caller context = %s\n", event.CallerContext)
	log.Printf("Event type = %s\n", event.EventType)

	// Check if DatasetRecords is not empty
	if event.DatasetRecords != "" {
		log.Printf("DataSet records = %s\n", event.DatasetRecords)
	}

	log.Printf("Trigger source = %s\n", event.TriggerSource)
	log.Printf("User pool = %s\n", event.UserPoolID)
	log.Printf("App client ID = %s\n", event.ClientID)
	log.Printf("User name = %s\n", event.UserName)
	log.Printf("User attributes = %s\n", event.UserAttributes)
	log.Printf("Request = %s\n", event.Request)
	log.Printf("Response = %s\n", event.Response)

	return event, nil
}

func main() {
	lambda.Start(Handler)
}
