resource "google_compute_instance" "default" {
  name         = local.name
  machine_type = local.machine_type
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = local.disk_size
    }
  }
  network_interface {
    network = "default"
    access_config { }
  }

  tags = ["http-server"]

  connection {
    type        = "ssh"
    user        = local.instance_user
    private_key = local.private_key_path
    host        = self.network_interface.0.access_config.0.nat_ip
  }

  metadata_startup_script = "mkdir pavlov"

  metadata = {
    ssh-keys = "${local.instance_user}:${file(local.public_key_path)}"
  }

  provisioner "file" {
    source      = "configure.sh"
    destination = "configure.sh"
  }

  provisioner "file" {
    source      = "pavlov"
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
  name    = "default-allow-http-terraform"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = concat(["9100", "22"], local.tcp_ports)
  }

  allow {
    protocol = "udp"
    ports    = concat(["7777", "8177"], local.udp_ports)
  }

  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["http-server"]
}

resource "google_compute_firewall" "http-server-egress" {
  name    = "default-allow-http-terraform-egress"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = concat(["9100", "22"], local.tcp_ports)
  }

  allow {
    protocol = "udp"
    ports    = concat(["7777", "8177"], local.udp_ports)
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "EGRESS"
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
