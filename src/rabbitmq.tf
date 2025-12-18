# resource "aws_mq_broker" "rabbitmq" {
#   broker_name = "${var.projectName}-rabbitmq-broker"

#   engine_type        = "RabbitMQ"
#   engine_version     = var.rabbitmq_engine_version
#   host_instance_type = var.rabbitmq_instance_type
#   deployment_mode    = "SINGLE_INSTANCE"

#   # Para AWS Academy, usamos publicly_accessible = true
#   publicly_accessible = true

#   security_groups = [aws_security_group.rabbitmq_sg.id]
#   subnet_ids      = [aws_subnet.public_subnet[0].id]

#   user {
#     username = var.rabbitmq_username
#     password = var.rabbitmq_password
#   }

#   logs {
#     general = true
#   }

#   maintenance_window_start_time {
#     day_of_week = "SUNDAY"
#     time_of_day = "03:00"
#     time_zone   = "UTC"
#   }

#   tags = merge(var.tags, {
#     Name = "${var.projectName}-rabbitmq-broker"
#   })
# }
