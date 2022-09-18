provider "google" {
  credentials = "${file("credentials.json")}"
  project = "terraform-362918"
  zone = "southamerica-east1-a"
}

resource "google_compute_instance" "default" {
  name = "pavlov-tf-test"
  machine_type = "e2-micro"
  zone = "southamerica-east1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }


  metadata_startup_script = "echo 'funfou\n' > lanche.txt"


  tags = ["http-server"]
}

resource "google_compute_firewall" "http-server" {
  name = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports = ["9100"]
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
    ports = ["9100"]
  }

  allow {
    protocol = "udp"
    ports = ["7777", "8177"]
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["http-server"]
  direction = "EGRESS"
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
