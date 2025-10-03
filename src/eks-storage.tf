resource "aws_efs_file_system" "efs" {
  creation_token   = "${var.projectName}-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "provisioned"

  provisioned_throughput_in_mibps = 100

  tags = {
    Name = "${var.projectName}-efs"
  }
}

resource "aws_efs_mount_target" "efs_mt" {
  count           = length(aws_subnet.public_subnet)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.public_subnet[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

# StorageClass para EFS - permite ReadWriteMany
resource "kubernetes_storage_class" "efs_sc" {
  metadata {
    name = "efs-sc"
  }
  
  storage_provisioner    = "efs.csi.aws.com"
  allow_volume_expansion = true
  
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.efs.id
    directoryPerms   = "0755"
  }

  depends_on = [aws_eks_addon.efs_csi_driver]
}

# PersistentVolume para EFS - disponível para a aplicação
resource "kubernetes_persistent_volume" "efs_pv" {
  metadata {
    name = "${var.projectName}-efs-pv"
  }
  
  spec {
    capacity = {
      storage = "5Gi"
    }
    
    access_modes                     = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name              = kubernetes_storage_class.efs_sc.metadata[0].name
    
    persistent_volume_source {
      csi {
        driver        = "efs.csi.aws.com"
        volume_handle = aws_efs_file_system.efs.id
      }
    }
  }

  depends_on = [
    kubernetes_storage_class.efs_sc,
    aws_efs_mount_target.efs_mt
  ]
}
