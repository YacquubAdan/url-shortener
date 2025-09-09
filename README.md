# url-shortener

A serverless URL shortener built with FastAPI and deployed on AWS infrastructure.

## Architecture

```mermaid
graph TB
    User[User] --> ALB[Application Load Balancer]
    ALB --> ECS[ECS Fargate Container]
    ECS --> DDB[DynamoDB Table]
    
    subgraph "AWS Infrastructure"
        subgraph "VPC"
            subgraph "Public Subnets"
                ALB
            end
            subgraph "Private Subnets"
                ECS
            end
        end
        
        subgraph "Security"
            WAF[WAF] --> ALB
            IAM[IAM Roles] --> ECS
        end
        
        subgraph "Storage"
            DDB
        end
        
        subgraph "Container Registry"
            ECR[Amazon ECR]
        end
    end
    
    subgraph "FastAPI Application"
        ECS --> App[FastAPI App]
        App --> POST["/shorten - Create short URL"]
        App --> GET["/{short_id} - Redirect to original URL"]
        App --> Health["/healthz - Health check"]
    end
    
    ECR --> ECS
    App --> DDB
    
    classDef aws fill:#ff9900,stroke:#333,stroke-width:2px,color:#fff
    classDef app fill:#009688,stroke:#333,stroke-width:2px,color:#fff
    classDef user fill:#2196f3,stroke:#333,stroke-width:2px,color:#fff
    
    class ALB,ECS,DDB,WAF,IAM,SG,ECR aws
    class App,POST,GET,Health app
    class User user
```

## Components

### Application Layer
- **FastAPI**: Web framework handling HTTP requests
- **Docker**: Containerised application deployment
- **ECS Fargate**: Serverless container hosting

### Infrastructure Layer
- **VPC**: Network isolation with public/private subnets
- **Application Load Balancer**: Traffic distribution and SSL termination
- **DynamoDB**: NoSQL database for URL mappings
- **WAF**: Web application firewall for security
- **IAM**: Identity and access management

### API Endpoints
- `POST /shorten`: Creates a shortened URL from the original URL
- `GET /{short_id}`: Redirects to the original URL using the short ID
- `GET /healthz`: Health check endpoint
