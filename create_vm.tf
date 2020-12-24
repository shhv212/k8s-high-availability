provider "google" {
  credentials = "${file("service_account.json")}"
  project = "k8s-ha-using-kubeadm-on-gcp"
  region = "asia-southeast1"
}

resource "google_compute_instance" "lb01" {
  boot_disk {
    auto_delete = "true"
    device_name = "lb01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "g1-small"
  name                = "lb01"
  zone = "asia-southeast1-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master01" {
  boot_disk {
    auto_delete = "true"
    device_name = "master01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n2-standard-2"
  name                = "master01"
  zone = "asia-southeast1-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master02" {
  boot_disk {
    auto_delete = "true"
    device_name = "master02"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n2-standard-2"
  name                = "master02"
  zone = "asia-southeast1-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "master03" {
  boot_disk {
    auto_delete = "true"
    device_name = "master03"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n2-standard-2"
  name                = "master03"
  zone = "asia-southeast1-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node01" {
  boot_disk {
    auto_delete = "true"
    device_name = "node01"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node01"
  zone = "asia-southeast2-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node02" {
  boot_disk {
    auto_delete = "true"
    device_name = "node02"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node02"
  zone = "asia-southeast2-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}

resource "google_compute_instance" "node03" {
  boot_disk {
    auto_delete = "true"
    device_name = "node03"
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1604-xenial-v20191204"
      size  = "20"
      type  = "pd-standard"
    }

  }
  allow_stopping_for_update = "true"
  can_ip_forward      = "true"
  deletion_protection = "false"
  enable_display      = "false"
  machine_type        = "n1-standard-1"
  name                = "node03"
  zone = "asia-southeast2-a"
  network_interface {
    access_config {
      nat_ip       = ""
      network_tier = "PREMIUM"
    }
    
    network            = "default"
    network_ip         = ""
  }

  tags = ["https-server",  "http-server"]
  
  metadata_startup_script = "sysctl -w net.ipv4.conf.all.forwarding=1"
  
}