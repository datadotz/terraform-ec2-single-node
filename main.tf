provider "aws" {
  access_key = "${var.aws_accessKey}"
  secret_key = "${var.aws_secretKey}"
  region = "${var.aws_region}"
  max_retries = 2
}


resource "template_file" "single_node_user_data" {
    template = "${file("${path.module}/${var.user_data}")}"
    vars {
        file = "${var.sampletag}"
    }
}

resource "aws_launch_configuration" "single_node_launch_config" {
  name = "${var.instance_name}-config"
  image_id = "${var.aws_image_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.aws_keypair_name}"

  security_groups = ["${split(",", var.security_group)}"]

  user_data = "${template_file.single_node_user_data.rendered}"

  ebs_optimized = "${var.ebs_optimized}"
  enable_monitoring = "true"

  lifecycle {
    create_before_destroy = false
  }

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = "true"
  }
}

resource "aws_autoscaling_group" "single_node_asg" {
  availability_zones = ["${split(",", var.availability_zones)}"]
  name = "${var.instance_name}-asg"
  max_size = "${var.asg_max_size}"
  min_size = "${var.asg_min_size}"
  desired_capacity = "${var.asg_desired_capacity}"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.single_node_launch_config.name}"
  vpc_zone_identifier = ["${split(",", var.subnets_id)}"]
  lifecycle {
    create_before_destroy = false
  }

  tag {
        key = "Name"
        value = "${var.instance_name}"
        propagate_at_launch = "true"
  }
  tag {
        key = "SampleTag"
        value = "${var.sampletag}"
        propagate_at_launch = "true"
  }
}

resource "aws_autoscaling_notification" "single_node_asg_notifications" {
  group_names = [
    "${aws_autoscaling_group.single_node_asg.name}"
  ]
  notifications  = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
  topic_arn = "${var.sns_topic}"
}

resource "aws_elb" "single_node_asg_elb" {
  name = "${var.instance_name}-elb"
  security_groups = ["${split(",", var.security_group)}"]
  subnets = ["${split(",", var.subnets_id)}"]
  internal = "true"

  listener {
    instance_port = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port = "${var.instance_port}"
    lb_protocol = "${var.instance_protocol}"
  }
  cross_zone_load_balancing = true

  tags {
   Name="${var.instance_name}-elb"
  }
}

resource "aws_autoscaling_attachment" "single_node_asg_attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.single_node_asg.name}"
  elb                    = "${aws_elb.single_node_asg_elb.name}"
}
