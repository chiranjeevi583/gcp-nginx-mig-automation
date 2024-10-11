provider "google" {
  project     = "my-project-279-436907"   # Your GCP project ID
  region      = "us-central1"             # Change if needed
  credentials = file("terraform.json")    # Path to the service account JSON file
}

# Instance Template with NGINX Startup Script
resource "google_compute_instance_template" "nginx_template" {
  name         = "nginx-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"  # Using Debian as the base OS
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {
      # Ephemeral public IP
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
  EOF
}

# Managed Instance Group
resource "google_compute_instance_group_manager" "nginx_group" {
  name               = "nginx-group"
  base_instance_name = "nginx"
  zone               = "us-central1-c"
  target_size        = 3  # Define how many instances to start

  version {
    instance_template = google_compute_instance_template.nginx_template.self_link
  }

  # Auto-scaling configuration can be added if needed
}

# Output the external IPs of the instances in the Managed Instance Group
output "instance_group_external_ips" {
  value = google_compute_instance_group_manager.nginx_group.instance_group
}
