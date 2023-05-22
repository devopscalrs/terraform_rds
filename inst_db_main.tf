
resource "aws_db_parameter_group" "default" {
  name   = "postgres"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}


data "aws_vpc" "default"{
    default = true
}

resource "aws_db_subnet_group" "db_subnet_group" {
  
  name       = "rds-main-subnet"
  subnet_ids = [ for sbnet in data.aws_subnet.public_subnet : sbnet.id ]


  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "db_master" {
  allocated_storage    = 100
  storage_type         = "io1"
  iops                 = 3000
  engine               = "postgres"
  engine_version       = "14.1"
  instance_class       = "db.t3.micro"
  identifier           = "rds-instance-master-sql"
  username             = "carlos"
  password             = "carlos1234"
  parameter_group_name   = aws_db_parameter_group.default.name
  db_subnet_group_name =aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids=[aws_security_group.db.id]
  availability_zone      = "${local.region}${var.servidores["ser-1"].az}" 
  skip_final_snapshot    = true
  publicly_accessible    = true
  backup_retention_period = 1
}


######### REPLICA
resource "aws_db_instance" "db_replica" {
  
  storage_type           = "io1"
  iops                   = 3000
  instance_class         = "db.t3.micro"
  identifier             = "rds-db-read-name"
  replicate_source_db    = aws_db_instance.default.identifier ## refer to the master instance
  parameter_group_name   = aws_db_parameter_group.default.name
  vpc_security_group_ids = [aws_security_group.db.id]
  availability_zone      = "${local.region}${var.servidores["ser-2"].az}"
  skip_final_snapshot    = true
  publicly_accessible    = true
  storage_encrypted      = true
  backup_retention_period = 0
}






resource "aws_security_group" "db" {
  name        = "sg_db_rds"
  description = "Security group data base"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups =[aws_security_group.mi_grupo_de_seguridad.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "end_point" {
  value = aws_db_instance.db_master.endpoint
}
