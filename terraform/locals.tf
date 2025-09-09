locals {
  region              = "eu-north-1"
  bucket              = "yacquub-urlshortener-backend"
  project_prefix      = "yacquub"
  ecs_cluster_name    = "yacquub-app-cluster"
  ecr_repository_name = "url-shortner"
  dynamodb_table_name = "yacquub-url-shortner-table"
}