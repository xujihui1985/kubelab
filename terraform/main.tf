provider "google" {
  credentials = "${file(var.credentials_path)}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

resource "google_compute_instance" "kubelab" {
  name         = "kubelab"
  machine_type = "n1-standard-1"
  zone         = "${var.region}-b"

  tags = []
}
