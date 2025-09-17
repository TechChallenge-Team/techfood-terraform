resource "aws_efs_file_system" "techfood_efs" {
  creation_token   = "techfood-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "provisioned"
  
  provisioned_throughput_in_mibps = 100

  tags = {
    Name = "techfood-efs"
  }
}

resource "aws_efs_mount_target" "techfood_efs_mt" {
  count           = length(aws_subnet.subnet_public)
  file_system_id  = aws_efs_file_system.techfood_efs.id
  subnet_id       = aws_subnet.subnet_public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "kubernetes_storage_class_v1" "efs_sc" {
  metadata {
    name = "efs-sc"
    labels = {
      "app.kubernetes.io/name"       = "efs-storageclass"
      "app.kubernetes.io/component"  = "storage"
      "app.kubernetes.io/part-of"    = "techfood-system"
    }
  }

  storage_provisioner    = "efs.csi.aws.com"
  reclaim_policy        = "Retain"
  volume_binding_mode   = "Immediate"
  allow_volume_expansion = true

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.techfood_efs.id
    directoryPerms   = "0755"
    gidRangeStart    = "1000"
    gidRangeEnd      = "2000"
    basePath         = "/dynamic_provisioning"
  }
}
