module "vpc" {
  source = "./modules/vpc"
}

module "ecs" {
  source              = "./modules/ecs"
  private_subnet_ids  = module.vpc.private_subnet_ids
  ecs_sg_id           = module.vpc.ecs_sg_id
  target_group_arn    = module.alb.target_group_arn
  exec_role_arn       = module.iam.exec_role_arn
  task_role_arn       = module.iam.task_role_arn
  ecr_repository_name = local.ecr_repository_name
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

