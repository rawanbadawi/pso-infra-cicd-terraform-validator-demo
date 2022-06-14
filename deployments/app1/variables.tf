variable "app_name" {
    type = string
    default = "myapp"
    description = "The name of the cloud run service."
}
variable "location" {
    type = string
    default = "us-central1"
    description = "Location of cloud run."
}
variable "image" {
    type = string
    default = "us-docker.pkg.dev/cloudrun/container/hello"
    description = "Container image deployed to cloud run."
}
variable "project_id" {
    type = string
    description = "Project ID to deploy the cloudrun app"
}