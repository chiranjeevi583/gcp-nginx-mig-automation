provider "google" {
  project     = "my-project-279-436907"
  region      = "us-central1"
  credentials = file("terraform.json")
}

resource "google_compute_instance_template" "nginx_template" {
  name         = "nginx-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
  EOF
}

resource "google_compute_instance_group_manager" "nginx_group" {
  name               = "nginx-group"
  base_instance_name = "nginx"
  zone               = "us-central1-c"
  target_size        = 3

  version {
    instance_template = google_compute_instance_template.nginx_template.self_link
  }
}

output "instance_group_external_ips" {
  value = google_compute_instance_group_manager.nginx_group.instance_group
}
