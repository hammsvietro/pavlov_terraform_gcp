locals {
  name             = "pavlov-server"
  machine_type     = "e2-medium"
  zone             = "southamerica-east1-a"
  instance_user    = "hammsvietro"
  project          = "project_id_here"
  disk_size        = "40"
  credentials_path = "path to credentials json"
  private_key_path = "path to private ssh key"
  public_key_path  = "path to public ssh key"
  udp_ports        = []
  tcp_ports        = []
}