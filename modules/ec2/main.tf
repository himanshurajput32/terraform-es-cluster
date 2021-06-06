resource "aws_instance" "this" {
  count = var.instance_count
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  monitoring = var.monitoring
  vpc_security_group_ids = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  iam_instance_profile = var.iam_instance_profile
  disable_api_termination = var.disable_api_termination
  subnet_id = var.subnet_id

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      volume_size = lookup(root_block_device.value, "volume_size", null)
      volume_type = lookup(root_block_device.value, "volume_type", null)
    }
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      device_name = ebs_block_device.value.device_name
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      volume_size = lookup(ebs_block_device.value, "volume_size", null)
      volume_type = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  tags = merge({
    "Name" = var.instance_count > 1 || var.use_num_suffix ? format("%s-%d", var.name, count.index+1) : var.name
  },
  var.tags
  )
}