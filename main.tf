variable "gcp_props" {
    type = map
    default = {
      name = "pavlov-server"
      machine_type = "e2-medium"
      zone = "southamerica-east1-a"
      instance_user = "hammsvietro"
      project = "project_id_here"
      disk_size = "40"
      credentials_path = "path to credentials json"
      private_key_path = "path to private ssh key"
    }
}

provider "google" {
  credentials = file(lookup(var.gcp_props, "credentials_path"))
  project = lookup(var.gcp_props, "project")
  zone = lookup(var.gcp_props, "zone")
}

resource "google_compute_instance" "default" {
  name = lookup(var.gcp_props, "name")
  machine_type = lookup(var.gcp_props, "machine_type")
  zone = lookup(var.gcp_props, "zone")

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size = lookup(var.gcp_props, "disk_size")
    }
  }
  network_interface {
    network = "default"
    access_config { }
  }

  tags = ["http-server"]

  connection {
    type = "ssh"
    user = lookup(var.gcp_props, "instance_user")
    private_key = file(lookup(var.gcp_props, "private_key_path"))
    host = self.network_interface.0.access_config.0.nat_ip
  }

  metadata_startup_script = "mkdir pavlov"

  metadata = {
    ssh-keys = "${lookup(var.gcp_props, "instance_user")}:${file(lookup(var.gcp_props, "public_key_path"))}"
  }

  provisioner "file" {
    source = "configure.sh"
    destination = "configure.sh"
  }

  provisioner "file" {
    source = "pavlov"
    destination = "."
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x configure.sh",
      "./configure.sh"
    ]
  }
}

resource "google_compute_firewall" "http-server" {
  name = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9100", "22"]
  }

  allow {
    protocol = "udp"
    ports = ["7777", "8177"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["http-server"]
}

resource "google_compute_firewall" "http-server-egress" {
  name = "default-allow-http-terraform-egress"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9100", "22"]
  }

  allow {
    protocol = "udp"
    ports = ["7777", "8177"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction = "EGRESS"
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
