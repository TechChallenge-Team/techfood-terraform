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
  count           = length(aws_subnet.subnet_public)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

# PV estático para EFS (não requer CSI driver permissions)
resource "kubernetes_persistent_volume" "techfood_efs_pv" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group,
    aws_efs_mount_target.efs_mt
  ]

  metadata {
    name = "techfood-efs-pv"
  }
  
  spec {
    capacity = {
      storage = "5Gi"
    }
    
    access_modes = ["ReadWriteMany"]
    persistent_volume_reclaim_policy = "Retain"
    
    persistent_volume_source {
      nfs {
        path   = "/"
        server = aws_efs_file_system.efs.dns_name
      }
    }
  }
}

# PVC para aplicação usando PV estático
resource "kubernetes_persistent_volume_claim" "techfood_images_pvc" {
  depends_on = [
    kubernetes_persistent_volume.techfood_efs_pv
  ]
  
  metadata {
    name      = "techfood-images-pvc"
    labels = {
      "app.kubernetes.io/name"      = "techfood-api"
      "app.kubernetes.io/component" = "storage"
      "app.kubernetes.io/part-of"   = "techfood-system"
    }
  }
  
  spec {
    access_modes = ["ReadWriteMany"]
    volume_name  = kubernetes_persistent_volume.techfood_efs_pv.metadata[0].name
    
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}
