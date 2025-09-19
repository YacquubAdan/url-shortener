module "vpc" {
  source = "./modules/vpc"
}

module "ecs" {
  source                 = "./modules/ecs"
  private_subnet_ids     = module.vpc.private_subnet_ids
  ecs_sg_id              = module.vpc.ecs_sg_id
  blue_target_group_arn  = module.alb.blue_target_group_arn
  exec_role_arn          = module.iam.exec_role_arn
  task_role_arn          = module.iam.task_role_arn
  ecr_repository_name    = local.ecr_repository_name
}

module "dynamodb" {
  source              = "./modules/dynamodb"
  region              = local.region
  dynamodb_table_name = local.dynamodb_table_name
}

module "iam" {
  source       = "./modules/iam"
  dynamodb_arn = module.dynamodb.dynamodb_arn

}

module "alb" {
  source            = "./modules/alb"
  lb_sg_id          = module.vpc.lb_sg_id
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "codedeploy" {
  source = "./modules/codedeploy"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  ecs_service_name = module.ecs.ecs_service_name
  prod_listener_arn = module.alb.prod_listener_arn
  blue_target_group_name = module.alb.blue_target_group_name
  green_target_group_name = module.alb.green_target_group_name
  codedeploy_role_arn = module.iam.codedeploy_role_arn
  # test_listener_arn = module.alb.test_listener_arn
}






