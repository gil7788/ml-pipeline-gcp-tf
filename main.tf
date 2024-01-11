terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"
  tags         = ["dummy", "ml-pipeline"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }

  metadata_startup_script = <<-EOT
  #!/bin/bash
  apt-get update
  apt-get install -y python3-pip make

  # Create a directory for the project
  mkdir /tmp/ml_project
  cd /tmp/ml_project

  # Download the Makefile and ml_script.py from the GCS bucket
  gsutil cp gs://${google_storage_bucket.ml_bucket.name}/Makefile /tmp/ml_project/Makefile
  gsutil cp gs://${google_storage_bucket.ml_bucket.name}/ml_script.py /tmp/ml_project/ml_script.py

  # Build the environment using the Makefile
  make install

  # Run the ml_script.py which trains the model and uploads it to GCS
  python3 ml_script.py

  # Download the trained model from GCS
  gsutil cp gs://${google_storage_bucket.ml_bucket.name}/iris_model.joblib /tmp/ml_project/iris_model.joblib
EOT

}

resource "google_storage_bucket" "ml_bucket" {
  name     = "my-ml-bucket-101"
  location = var.region
}

resource "random_id" "bucket_suffix" {
  byte_length = 2
}

resource "google_storage_bucket_object" "ml_script" {
  name   = "ml_script.py"
  bucket = google_storage_bucket.ml_bucket.name
  source = "${path.module}/ml_script.py"
}
