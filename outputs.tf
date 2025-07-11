output "admin_password" {
    value = random_password.postgres_admin_password.result
}