// basic go lambda test
package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {

	// Log the request
	log.Printf("Request: %v", request)

	// Get the current time
	currentTime := time.Now().Format(time.RFC3339)

	// Create a response
	response := events.APIGatewayProxyResponse{
		StatusCode: http.StatusOK,
		Body:       fmt.Sprintf("Hello, World! Current time is: %s", currentTime),
	}

	// Return the response
	return response, nil
}

// Handler is the function that will be called by AWS Lambda

func main() {
	lambda.Start(handler)
}
