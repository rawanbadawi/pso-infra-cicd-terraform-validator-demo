terraform {
  backend "gcs" {
    bucket  = "TFSTATE_BUCKET"
    prefix  = "tf-demo/app1"
  }
}
