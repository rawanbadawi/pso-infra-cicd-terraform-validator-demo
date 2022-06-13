terraform {
  backend "gcs" {
    bucket  = "rbadawi-onprem"
    prefix  = "tf-demo/app1"
  }
}
