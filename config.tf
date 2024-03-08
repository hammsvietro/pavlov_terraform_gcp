provider "google" {
  credentials = file(local.credentials_path)
  project     = local.project
  zone        = local.zone
}
